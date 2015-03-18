//
//  CheckoutViewController.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "CheckoutViewController.h"
#import <SwipeView/SwipeView.h>
#import "SubtotalItemCell.h"
#import "SubtotalTitleItemCell.h"
#import "CardSelectCell.h"
#import "TotalItemCell.h"
#import "TextFieldCell.h"
#import "BaseNavigationController.h"
#import "TextViewCell.h"
#import "OrderConfirmationViewController.h"
#import "MPManager.h"
#import "MPCreditCard.h"
#import "MPECommerceManager.h"
#import "OrderHeader+NormalizedTotals.h"
#import "ShippingSelectCell.h"

@interface CheckoutViewController () <UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic, strong) UIPickerView *addressPickerView;
@property(nonatomic, strong) UIToolbar *addressPickerToolbar;
@property(nonatomic, strong) MPCreditCard *selectedCard;
@property(nonatomic, strong) MPAddress *selectedShippingInfo;
@property(nonatomic, strong) UIButton *cardSelectorButton;

@property(nonatomic, strong) NSString *cardType;

@property (nonatomic, strong)NSArray *confirmProducts; //used for order confirmation
@property (nonatomic, assign)BOOL purchasingWithMP;
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
    
    self.addressPickerView = [[UIPickerView alloc]initWithFrame:
                              CGRectMake(0, self.view.frame.size.height - 216., self.view.frame.size.width, 216.)];
    self.addressPickerView.delegate = self;
    self.addressPickerView.dataSource = self;
    self.addressPickerView.backgroundColor = [UIColor whiteColor];
    self.addressPickerView.showsSelectionIndicator = YES;
    self.addressPickerView.hidden = YES;
    [self.view addSubview:self.addressPickerView];
    
    self.addressPickerToolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,self.addressPickerView.frame.origin.y - 44,320,44)];
    [self.addressPickerToolbar setBarStyle:UIBarStyleBlackOpaque];
    self.addressPickerToolbar.hidden = YES;
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(pickerDone:)];
    
    self.addressPickerToolbar.items = [[NSArray alloc] initWithObjects:barButtonDone,nil];
    barButtonDone.tintColor=[UIColor whiteColor];
    [self.view addSubview:self.addressPickerToolbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (switchCards:) name:@"CheckoutCardSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (pairMP:) name:@"CheckoutPairSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (addCard:) name:@"CheckoutNewCardSelected" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (processOrder:) name:@"order_processed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (popToRoot) name:@"StartOver" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (confirmOrder) name:@"MasterPassCheckoutComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkoutCancelled) name:@"MasterPassCheckoutCancelled" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self selectDefaultCard];
    [self selectDefaultShipping];
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.containerTable.layoutMargins = UIEdgeInsetsZero;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Event Responding

-(void)switchCards:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    MPCreditCard *card = (MPCreditCard *)[dict objectForKey:@"card"];
    [self switchToCard:card];
}

-(void)selectDefaultCard{
    for (int i = 0; i < self.cards.count; i++){
        MPCreditCard *card = self.cards[i];
        if ([card.selectedAsDefault boolValue]) {
            [self switchToCard:card];
            return;
        }
    }
    
    if (self.cards.count > 0) {
        [self switchToCard:self.cards[0]];
    }
}

-(void)switchToCard:(MPCreditCard *)card{
    self.selectedCard = card;
    
    if (card && self.cards.count == 1){
        self.buttonType = kButtonTypeProcess;
    }
    else if (card) {
        self.buttonType = kButtonTypeMasterPass;
    }
    else {
        self.buttonType = kButtonTypeProcess;
    }
    
    [self.containerTable reloadData];
}
-(void)addCard:(NSNotification *)notification{
    self.selectedCard = nil;
    [self selectShipping:0];
    self.buttonType = kButtonTypeProcess;
    [self.containerTable reloadData];
}

-(void)pairMP:(NSNotification *)notification{
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
            return;
        }
    }
    
    if (self.addresses.count > 0) {
        [self selectShipping:0];
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

-(void)showShippingPicker{
    self.addressPickerToolbar.hidden = !self.addressPickerView.hidden;
    self.addressPickerView.hidden = !self.addressPickerView.hidden;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
    __weak typeof(self) weakSelf = self;
    [ecommerce getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        weakSelf.confirmProducts = cart;
        MPManager *manager = [MPManager sharedInstance];
        if (weakSelf.selectedCard == nil) {
            
            
            //[manager completeManualCheckoutForOrder:header.id];
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [weakSelf confirmOrder];
        }
        else if ([manager isAppPaired] && !self.precheckoutConfirmation) {
            weakSelf.purchasingWithMP = TRUE;
            
            if ([manager expressCheckoutEnabled]) {
                [manager expressCheckoutForOrder:header.id
                                      walletInfo:weakSelf.walletInfo
                                            card:weakSelf.selectedCard
                                 shippingAddress:weakSelf.selectedShippingInfo
                                        callback:^(BOOL success, NSDictionary *response, NSError *error) {
                                            
                                            if (success) {
                                                [self confirmOrder];
                                            }
                                            else {
                                                [self checkoutCancelled];
                                                SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Error" andMessage:[error localizedDescription]];
                                                                          
                                                [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
                                                alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                                                [alertView show];

                                            }
                                        }];
            }
            else {
                [manager returnCheckoutForOrder:header.id
                                     walletInfo:weakSelf.walletInfo
                                           card:weakSelf.selectedCard
                                shippingAddress:weakSelf.selectedShippingInfo
                           showInViewController:weakSelf];
            }
        }
        else if ([manager isAppPaired] && weakSelf.precheckoutConfirmation){
            weakSelf.purchasingWithMP = TRUE;
            [manager completePairCheckoutForOrder:header.id transaction:self.walletInfo[@"transaction_id"] preCheckoutTransaction:self.walletInfo[@"pre_checkout_transaction_id"]];
        }
    }];
}

-(void)confirmOrder {
    if ([self.navigationController.visibleViewController isEqual:self]) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"ConfirmOrder" sender:nil];
    }
}

-(void)checkoutCancelled {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ConfirmOrder"]) {
        OrderConfirmationViewController *ocvc = (OrderConfirmationViewController *)[segue destinationViewController];
        ocvc.products = self.confirmProducts;
        ocvc.purchasedWithMP = self.purchasingWithMP;
        ocvc.total = self.total;
    }
}

-(void)popToRoot{
    [self.navigationController popToRootViewControllerAnimated:NO];
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
            if (self.selectedCard) {
                return 0;
            }
            else {
                return 4;
            }
        }
        case 5:return 1;  // Shipping Info
        case 6:return 0;  // TextView Cell
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
            if (self.selectedCard){
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
    if (section == 4 && !self.selectedCard){
        return 44;
    }
    else if (section == 5) {
        return 44;
    }
    else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 4 || section == 5) {
        
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
    static NSString *totalTitleCellId = @"TotalTitleCell";
    static NSString *subTotalTitleCellId = @"SubtotalTitleCell";
    static NSString *subTotalCellId = @"SubtotalCell";
    static NSString *cardSelectCellId = @"CardSelectCell";
    static NSString *processOrderCellId = @"ProcessOrderCell";
    static NSString *textFieldCellId = @"TextFieldCell";
    static NSString *textViewCellId = @"TextViewCell";
    static NSString *selectShippingCellId = @"SelectShippingCell";
    
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
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self formatCurrency:self.subtotal]];
                break;
            case 1:
                cell.textLabel.text = @"Tax";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self formatCurrency:self.tax]];
                break;
            case 2:
                cell.textLabel.text = @"Shipping";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self formatCurrency:self.shipping]];
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
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ USD",[self formatCurrency:self.total]];
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
        [cell setReturnCheckout:!self.precheckoutConfirmation];
        [cell setCards:self.cards showManualEntry:!self.precheckoutConfirmation]; // TODO
        [cell reloadMPImageUI]; //
        
        if (!self.precheckoutConfirmation) {
            [cell setMasterPassImage:self.walletInfo[@"masterpass_logo_url"] andBrandImage:self.walletInfo[@"wallet_partner_logo_url"]];
        }
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
                [self.cardSelectorButton addTarget:self action:@selector(chooseCardType) forControlEvents:UIControlEventTouchUpInside];
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
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    else if (indexPath.section == 5) { // Shipping
        
        ShippingSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:selectShippingCellId];
        
        if (cell == nil)
        {
            cell = [[ShippingSelectCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:selectShippingCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.selectShippingButton addTarget:self action:@selector(showShippingPicker) forControlEvents:UIControlEventTouchUpInside];
        }
        if (self.selectedShippingInfo) {
            cell.textView.text = [NSString stringWithFormat:@"%@ %@\n%@, %@ %@",
                                  [self nullSafeString:self.selectedShippingInfo.lineOne],
                                  [self nullSafeString:self.selectedShippingInfo.lineTwo],
                                  [self nullSafeString:self.selectedShippingInfo.countrySubdivision],
                                  [self nullSafeString:self.selectedShippingInfo.country],
                                  [self nullSafeString:self.selectedShippingInfo.postalCode]];
            
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
        [cell setButtonType:self.buttonType];
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    
    //fallback
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"DefaultCell"];
}

-(NSString *)nullSafeString:(NSString *)str{
    if ((!str) || ([str isEqual: [NSNull null]])) {
        return @"";
    }
    return str;
}

#pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self selectShipping:(int)row];
}

// tell the picker how many rows are available for a given component
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.addresses.count;
}

// tell the picker how many components it will have
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    MPAddress *address = ((MPAddress *)self.addresses[row]);
    return address.shippingAlias ?: address.lineOne;
}

// tell the picker the width of each row for a given component
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

-(void)pickerDone:(id)sender{
    
    self.addressPickerToolbar.hidden = !self.addressPickerView.hidden;
    self.addressPickerView.hidden = !self.addressPickerView.hidden;
}

@end
