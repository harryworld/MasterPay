//
//  CheckoutViewController.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "CheckoutViewController.h"
#import <SwipeView/SwipeView.h>
#import "SubtotalItemCell.h"
#import "SubtotalTitleItemCell.h"
#import "CardSelectCell.h"
#import "CartManager.h"
#import "CardManager.h"
#import "TotalItemCell.h"
#import "TextFieldCell.h"
#import "MasterPassConnectViewController.h"
#import "ShippingInfo.h"
#import "BaseNavigationController.h"
#import "TextViewCell.h"
#import "OrderConfirmationViewController.h"
#import "PasswordViewController.h"
#import "MPManager.h"
#import "MPCreditCard.h"
#import "MPECommerceManager.h"

@interface CheckoutViewController ()
@property(nonatomic, strong) SwipeView *cardSwipeView;
@property(nonatomic, strong) ProcessOrderCell *processOrderCell;
@property(nonatomic, strong) MPCreditCard *selectedCard;
@property(nonatomic, strong) MPAddress *selectedShippingInfo;
@property(nonatomic, strong) UIButton *cardSelectorButton;

@property(nonatomic, strong) NSString *cardType;
@end

@implementation CheckoutViewController

#pragma mark Inherited Methods

-(void)viewDidLoad{
    [super viewDidLoad];

    self.containerTable.backgroundColor = [UIColor deepBlueColor];
    self.containerTable.separatorColor = [UIColor deepBlueColor];
    if ([self.containerTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.containerTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (oneTimePairingComplete) name:@"ConnectedMasterPass" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (switchCards:) name:@"CheckoutCardSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (pairMP:) name:@"CheckoutPairSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (addCard:) name:@"CheckoutNewCardSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (processOrder:) name:@"order_processed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (popToRoot) name:@"StartOver" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (confirmOrder ) name:@"MasterPassCheckoutComplete" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MPManager *manager = [MPManager sharedInstance];
    if ([manager isAppPaired] && !self.precheckoutConfirmation) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager precheckoutDataCallback:^(NSArray *cards, NSArray *addresses, NSDictionary *contactInfo, NSDictionary *walletInfo, NSError *error) {
            self.cards = cards;
            self.addresses = addresses;
            self.walletInfo = walletInfo;
            [self switchToCard:self.cards.firstObject];
            [self selectDefaultShipping];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.containerTable.layoutMargins = UIEdgeInsetsZero;
}

-(void)viewWillDisappear:(BOOL)animated{
    // If we have a delayed pair - lets pair now
    
    
    // TODO
    CardManager *manager = [CardManager getInstance];
    if (manager.wantsDelayedPair) {
        manager.isLinkedToMasterPass = YES;
        manager.wantsDelayedPair = NO;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Event Responding

-(void)switchCards:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    MPCreditCard *card = (MPCreditCard *)[dict objectForKey:@"card"];
    self.isPairing = NO;
    [self switchToCard:card];
}

-(void)switchToCard:(MPCreditCard *)card{
    self.selectedCard = card;
    
    if (card) {
        self.buttonType = kButtonTypeMasterPass;
    }
    else {
        self.buttonType = kButtonTypeProcess;
    }
    
    [self.containerTable reloadData];
}
-(void)addCard:(NSNotification *)notification{
    self.isPairing = NO;
    self.selectedCard = nil;
    [self selectShipping:0];
    self.buttonType = kButtonTypeProcess;
    [self.containerTable reloadData];
}

-(void)pairMP:(NSNotification *)notification{
    self.isPairing = YES;
    self.selectedCard = nil;
    [self selectShipping:0];
    [self.containerTable reloadData];
}

#pragma mark - Shipping Address

-(void)selectDefaultShipping{
    for (int i = 0; i < self.addresses.count; i++){
        MPAddress *address = self.addresses[i];
        if ([address.selectedAsDefault boolValue]) {
            [self selectShipping:i];
            break;
        }
    }
}

-(void)selectShipping:(int)index{
    if ((index < ([self.addresses count])) && (index > -1)) {
        self.selectedShippingInfo = (MPAddress *)self.addresses[index];
    }
    else {
        self.selectedShippingInfo = nil;
    }
    [self.containerTable reloadData];
}

#pragma mark - Card Types

-(void)chooseCardType{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Select Card Type" andMessage:@"Select a credit card provider from the list of supported providers"];
    
    [@[@"MasterCard",@"Visa",@"Discover",@"American Express"] each:^(NSString * cardType) {
        [alertView addButtonWithTitle:cardType
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  self.cardType = cardType;
                                  [self.containerTable reloadData];
                              }];
    }];
    
    [alertView addButtonWithTitle:@"Cancel" type:SIAlertViewButtonTypeCancel handler:nil];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

#pragma mark - Data Formatting

-(NSString *)formatCurrency:(NSNumber *)price{
    double currency = [price doubleValue];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:currency]];
    return numberAsString;
}

#pragma mark - Processing Orders

-(void)processOrder:(NSNotification *)notification{
    MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
    [ecommerce getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        MPManager *manager = [MPManager sharedInstance];
        if ([manager isAppPaired] && !self.precheckoutConfirmation) {
            [manager returnCheckoutForOrder:header.id
                                 walletInfo:self.walletInfo
                                       card:self.selectedCard
                            shippingAddress:self.selectedShippingInfo
                       showInViewController:self];
        }
        else if ([manager isAppPaired] && self.precheckoutConfirmation){
            [manager completePairCheckoutForOrder:header.id transaction:self.walletInfo[@"transaction_id"] preCheckoutTransaction:self.walletInfo[@"pre_checkout_transaction_id"]];
        }
    }];
    
    //TODO
    /*if (cm.isLinkedToMasterPass && self.selectedCard && [self.selectedCard.isMasterPass boolValue] && !cm.isExpressEnabled) {
        [self performSegueWithIdentifier:@"MPCheckout" sender:nil];
    }
    else if (self.isPairing && self.oneTimePairedCard){
        [self confirmOrder];
    }
    else if (self.isPairing) {
        [self performSegueWithIdentifier:@"MPConnect" sender:nil];
    }
    else{
        //other process
        [self confirmOrder];
    }*/
}

-(void)oneTimePairingComplete{
    CardManager *cm = [CardManager getInstance];
    self.oneTimePairedCard = cm.cards.firstObject;
    [self selectShipping:0];
    self.buttonType = kButtonTypeProcess;
    [self.containerTable reloadData];
}

-(void)confirmOrder {
    if ([self.navigationController.visibleViewController isEqual:self]) {
        [self performSegueWithIdentifier:@"ConfirmOrder" sender:nil];
    }
    else {
        [self performSelector:@selector(confirmOrder) withObject:nil afterDelay:0.5];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //TODO
    
    /*if ([segue.identifier isEqualToString:@"ConfirmOrder"]) {
        CardManager *cm = [CardManager getInstance];
        if ((cm.isLinkedToMasterPass && self.selectedCard && [self.selectedCard.isMasterPass boolValue]) || (self.isPairing && self.oneTimePairedCard)) {
            ((OrderConfirmationViewController *)segue.destinationViewController).purchasedWithMP = true;
        }
        else {
            ((OrderConfirmationViewController *)segue.destinationViewController).purchasedWithMP = false;
        }
    }
    else if ([[segue identifier] isEqualToString:@"MPCheckout"]) {
        MasterPassConnectViewController *dest = (MasterPassConnectViewController *)[[(UINavigationController *)[segue destinationViewController] viewControllers] firstObject];
        
        dest.checkoutAuth = TRUE;
        
        //[self confirmOrder];
    }*/
}

-(void)popToRoot{
    [self.navigationController popToRootViewControllerAnimated:NO];
    CartManager *cm = [CartManager getInstance];
    [cm cleanCart];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:return 1;  // Subtotal Title
        case 1:return 3;  // Subtotal items
        case 2:return 1;  // Total
        case 3:return 1;  // Card Selector
        case 4:  {        // Card Info Form
            //if (self.selectedCard && self.selectedCard.isMasterPass) { TODO
            if (self.selectedCard) {
                return 0;
            }
            else if (self.isPairing && self.oneTimePairedCard){
                return 0;
            }
            else if (self.isPairing){
                return 0;
            }
            else {
                return 4;
            }
        }
        case 5:  {         // Shipping Info Form
            if (self.isPairing && self.oneTimePairedCard) {
                return 1;
            }
            else if (self.isPairing){
                return 0;
            }
            else {
                return 1;
            }
        }
        case 6:{            // TextView Cell
            if (self.isPairing && !self.oneTimePairedCard) {
                return 1;
            }
            else{
                return 0;
            }
        }
        case 7:return 1;  // Process Order Button
        default:return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:return 26;  // Subtotal Title
        case 1:return 26;  // Subtotal items
        case 2:return 26;  // Total
        case 3:return 160; // Card Selector
        case 4:return 44;  // Card Info Form
        case 5:return 70;  // Shipping Info Form
        case 6:return 44;  // TextView Cell
        case 7:   {        // Process Order Button
            //if (self.selectedCard && self.selectedCard.isMasterPass) { TODO
            if (self.selectedCard){
                return 80;
            }
            else if (self.isPairing && !self.oneTimePairedCard){
                return 80;
            }
            else {
                return 60;
            }
        }
        default:return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isPairing && self.oneTimePairedCard && section == 4) {
        return 0;
    }
    else if (section == 4 && !self.selectedCard && (!self.isPairing || self.oneTimePairedCard)){
        return 44;
    }
    else if (section == 5 && (!self.isPairing || self.oneTimePairedCard)) {
        return 44;
    }
    else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.isPairing && self.oneTimePairedCard && section == 4) {
        return nil;
    }
    
    if ((section == 4 || section == 5) && (!self.isPairing || self.oneTimePairedCard)) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        view.backgroundColor = [UIColor superGreyColor];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectZero];
        title.textAlignment = NSTextAlignmentCenter;
        [view addSubview:title];
        [title makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
            make.center.equalTo(view);
        }];
        
        // Set Text
        
        switch (section) {
            case 4:
                title.text = @"Credit Card Details";
                break;
            case 5:
                title.text = @"Shipping Information";
                break;
            default:
                title.text = nil;
                break;
        }
        
        return view;
    }
    else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartManager *cm = [CartManager getInstance];
    static NSString *totalTitleCellId = @"TotalTitleCell";
    static NSString *subTotalTitleCellId = @"SubtotalTitleCell";
    static NSString *subTotalCellId = @"SubtotalCell";
    static NSString *cardSelectCellId = @"CardSelectCell";
    static NSString *processOrderCellId = @"ProcessOrderCell";
    static NSString *textFieldCellId = @"TextFieldCell";
    static NSString *textViewCellId = @"TextViewCell";
    
    if (indexPath.section == 0) { // Subtotal Title
        
        SubtotalTitleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:subTotalTitleCellId];
        
        if (cell == nil)
        {
            cell = [[SubtotalTitleItemCell alloc] initWithStyle:UITableViewCellStyleValue1
                                         reuseIdentifier:subTotalTitleCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"Sub Total";
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    else if (indexPath.section == 1) { // Subtotal items
        
        SubtotalItemCell *cell = [tableView dequeueReusableCellWithIdentifier:subTotalCellId];
        
        if (cell == nil)
        {
            cell = [[SubtotalItemCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:subTotalCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Items";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self formatCurrency:[NSNumber numberWithDouble:[cm subtotal]]]];
                break;
            case 1:
                cell.textLabel.text = @"Tax";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self formatCurrency:[NSNumber numberWithDouble:[cm tax]]]];
                break;
            case 2:
                cell.textLabel.text = @"Shipping";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self formatCurrency:[NSNumber numberWithDouble:[cm shipping]]]];
                break;
            default:
                cell.textLabel.text = nil;
                cell.detailTextLabel.text = nil;
                break;
        }
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    else if (indexPath.section == 2) { // Total
        
        TotalItemCell *cell = [tableView dequeueReusableCellWithIdentifier:totalTitleCellId];
        
        if (cell == nil)
        {
            cell = [[TotalItemCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                reuseIdentifier:totalTitleCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"Total";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ USD",[self formatCurrency:[NSNumber numberWithDouble:[cm total]]]];
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    else if (indexPath.section == 3) { // Card Selector
        
        CardSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cardSelectCellId];
        
        if (cell == nil)
        {
            cell = [[CardSelectCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cardSelectCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setCards:self.cards showManualEntry:!self.precheckoutConfirmation]; // TODO
        [cell setMasterPassImage:self.walletInfo[@"masterpass_logo_url"] andBrandImage:self.walletInfo[@"wallet_partner_logo_url"]];
        cell.showsMPPair = self.oneTimePairedCard ? true : false;
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    else if (indexPath.section == 4) { // Card Info Form
        
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellId];
        
        if (cell == nil)
        {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:textFieldCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textField.text = nil;
        self.cardSelectorButton = nil;
        cell.textField.userInteractionEnabled = YES;
        
        if ([cell.contentView viewWithTag:kCheckoutAlertTypeCardType]) {
            [[cell.contentView viewWithTag:kCheckoutAlertTypeCardType] removeFromSuperview];
        }
        
        if(self.oneTimePairedCard && self.isPairing) {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Card Number";
                    cell.textField.text = [NSString stringWithFormat:@"Card ending in %@",self.oneTimePairedCard.lastFour];
                    break;
                case 1:
                    cell.textLabel.text = @"Exp Date";
                    cell.textField.text = self.oneTimePairedCard.expDate;
                    break;
                default:
                    cell.textLabel.text = nil;
                    break;
            }
        }
        else {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Full Name";
                    break;
                case 1:{
                    cell.textLabel.text = nil;
                    cell.textField.text = self.cardType;
                    cell.textField.userInteractionEnabled = NO;
                    self.cardSelectorButton = [[UIButton alloc]initWithFrame:CGRectZero];
                    [self.cardSelectorButton setTitle:@"Select Card Type" forState:UIControlStateNormal];
                    [self.cardSelectorButton setTitleColor:[UIColor steelColor] forState:UIControlStateNormal];
                    self.cardSelectorButton.tag = kCheckoutAlertTypeCardType;
                    [self.cardSelectorButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                    self.cardSelectorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [cell.contentView addSubview:self.cardSelectorButton];
                    [self.cardSelectorButton bk_addEventHandler:^(id sender) {
                        [self chooseCardType];
                    } forControlEvents:UIControlEventTouchUpInside];
                    [self.cardSelectorButton makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
                        make.center.equalTo(cell.contentView);
                    }];
                    break;
                }
                case 2:
                    cell.textLabel.text = @"Card Number";
                    break;
                case 3:
                    cell.textLabel.text = @"Exp Date";
                    break;
                default:
                    cell.textLabel.text = nil;
                    break;
            }
        }
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    else if (indexPath.section == 5) { // Shipping
        
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textViewCellId];
        
        if (cell == nil)
        {
            cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:textViewCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textView.textAlignment = NSTextAlignmentLeft;
        cell.textView.font = [UIFont systemFontOfSize:14];
        cell.contentView.backgroundColor = [UIColor superLightGreyColor];
        cell.textView.backgroundColor = [UIColor superLightGreyColor];
        cell.textView.textColor = [UIColor steelColor];
        cell.textView.scrollEnabled = NO;
        if (![NSThread isMainThread]) { NSLog(@"Huh?"); }
        if (self.selectedShippingInfo) {
            cell.textView.text = [NSString stringWithFormat:@"%@ %@\n%@, %@ %@",
                                  self.selectedShippingInfo.lineOne,
                                  self.selectedShippingInfo.lineTwo,
                                  self.selectedShippingInfo.countrySubdivision,
                                  self.selectedShippingInfo.country,
                                  self.selectedShippingInfo.postalCode];
        }
        else {
            cell.textView.text = nil;
        }
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    else if (indexPath.section == 6) { // TextView
        
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textViewCellId];
        
        if (cell == nil)
        {
            cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:textViewCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textView.text = @"Tap to log into your MasterPass wallet account";
        cell.textView.textAlignment = NSTextAlignmentCenter;
        cell.textView.scrollEnabled = NO;
        cell.contentView.backgroundColor = [UIColor superLightGreyColor];
        cell.textView.backgroundColor = [UIColor superLightGreyColor];
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    else if (indexPath.section == 7) { // Process order
        
        ProcessOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:processOrderCellId];
        
        if (cell == nil)
        {
            cell = [[ProcessOrderCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:processOrderCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        self.processOrderCell = cell;
        [cell setButtonType:self.buttonType];
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    
    //fallback
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"DefaultCell"];
}
@end
