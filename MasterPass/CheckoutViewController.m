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
#import "ProcessOrderCell.h"
#import "Card.h"
#import "TextFieldCell.h"
#import "MasterPassConnectViewController.h"
#import "ShippingInfo.h"
#import "BaseNavigationController.h"
#import "TextViewCell.h"

@interface CheckoutViewController ()
@property(nonatomic, strong)SwipeView *cardSwipeView;
@property(nonatomic, weak) IBOutlet UITableView *containerTable;
@property(nonatomic, strong)ProcessOrderCell *processOrderCell;
@property(nonatomic, strong)Card *selectedCard;
@property(nonatomic, strong)Card *oneTimePairedCard;
@property(nonatomic, strong)ShippingInfo *selectedShippingInfo;
@property(nonatomic, assign)BOOL isPairing;
@property(nonatomic, strong)UIButton *cardSelectorButton;
@property(nonatomic, strong)NSString *cardType;
@property(nonatomic, assign)ProcessButtonType buttonType;
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
    
    CardManager *cm = [CardManager getInstance];
    self.selectedShippingInfo = [[cm shippingDetails] firstObject];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Event Responding

-(void)switchCards:(NSNotification *)notification{
    NSDictionary *dict = [notification userInfo];
    Card *card = (Card *)[dict objectForKey:@"card"];
    self.isPairing = NO;
    [self switchToCard:card];
}

-(void)switchToCard:(Card *)card{
    self.selectedCard = card;
    if ([card.isMasterPass boolValue]) {
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
    self.selectedShippingInfo = nil;
    self.buttonType = kButtonTypeProcess;
    [self.containerTable reloadData];
}

-(void)pairMP:(NSNotification *)notification{
    self.isPairing = YES;
    self.selectedCard = nil;
    self.selectedShippingInfo = nil;
    self.buttonType = kButtonTypeMasterPass;
    [self.containerTable reloadData];
}

#pragma mark - Shipping Address

-(void)editShipping{
    
    CardManager *cm = [CardManager getInstance];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Shipping Details" andMessage:@"Select or add an address to receieve your items"];
    
    [cm.shippingDetails eachWithIndex:^(ShippingInfo * si, NSUInteger index) {
        [alertView addButtonWithTitle:si.label
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  [self selectShipping:(int)index];
                              }];
    }];
    
    [alertView addButtonWithTitle:@"Create New Address"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [self selectShipping:-1];
                          }];
    
    [alertView addButtonWithTitle:@"Cancel" type:SIAlertViewButtonTypeCancel handler:nil];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

-(void)selectShipping:(int)index{
    CardManager *cm = [CardManager getInstance];
    if ((index < ([[cm shippingDetails] count])) && (index > -1)) {
        self.selectedShippingInfo = (ShippingInfo *)[[cm shippingDetails] objectAtIndex:index];
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
    static bool alertIsShowing = false;
    CardManager *cm = [CardManager getInstance];
    if (cm.isLinkedToMasterPass && self.selectedCard && [self.selectedCard.isMasterPass boolValue] && !cm.isExpressEnabled) {
        unless(alertIsShowing){
            alertIsShowing = true;
            SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Enter MasterPass Password" andMessage:@"Enter your MasterPass password to continue to checkout"];
            [alert addInputFieldWithPlaceholder:@"Password" andHandler:nil];
            [alert addButtonWithTitle:@"Enter" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
                [self confirmOrder];
            }];
            [alert addButtonWithTitle:@"Cancel" type:SIAlertViewButtonTypeCancel handler:nil];
            alert.transitionStyle = SIAlertViewTransitionStyleBounce;
            alert.didDismissHandler = ^(SIAlertView *alertView) {
                alertIsShowing = false;
            };
            [alert show];
        }
    }
    else if (self.isPairing && self.oneTimePairedCard){
        [self confirmOrder];
    }
    else if (self.isPairing) {
        [self performSegueWithIdentifier:@"MPConnect" sender:nil withBlock:^(id sender, id destinationVC) {
            MasterPassConnectViewController *dest = [[((BaseNavigationController *)destinationVC) viewControllers] firstObject];
            unless(cm.isExpressEnabled) {
                dest.path = [[NSBundle mainBundle] pathForResource:@"mp1-checkout" ofType:@"html"];
            }
            else {
                dest.path = [[NSBundle mainBundle] pathForResource:@"mp1-express-checkout" ofType:@"html"];
            }
        }];
    }
    else{
        //other process
        [self confirmOrder];
    }
}

-(void)oneTimePairingComplete{
    CardManager *cm = [CardManager getInstance];
    self.oneTimePairedCard = cm.cards.firstObject;
    [self selectShipping:0];
    self.buttonType = kButtonTypeProcess;
    [self.containerTable reloadData];
}

-(void)confirmOrder {
    if (self.navigationController.visibleViewController == self) {
        // Fake Delay and then proceed to confirmation
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Processing Your Payment";
        [self bk_performBlock:^(id obj) {
            [hud hide:YES];
            [self performSegueWithIdentifier:@"ConfirmOrder" sender:nil];
        } afterDelay:2.5];
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
            if (self.selectedCard && self.selectedCard.isMasterPass) {
                return 0;
            }
            else if (self.isPairing && self.oneTimePairedCard){
                return 2;
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
                return 4;
            }
            else if (self.isPairing){
                return 0;
            }
            else {
                return 4;
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
        case 3:return 200; // Card Selector
        case 4:return 44;  // Card Info Form
        case 5:return 44;  // Shipping Info Form
        case 6:return 44;  // TextView Cell
        case 7:   {        // Process Order Button
            if (self.selectedCard && self.selectedCard.isMasterPass) {
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
    if (section == 4 && !self.selectedCard && (!self.isPairing || self.oneTimePairedCard)){
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
        
        
        // Edit Shipping button
        if (section == 5) {
            UIButton *shippingButton = [[UIButton alloc]initWithFrame:CGRectZero];
            [shippingButton setTitle:@"Edit" forState:UIControlStateNormal];
            [shippingButton setBackgroundColor:[UIColor brightOrangeColor]];
            [shippingButton.layer setCornerRadius:6];
            [view addSubview:shippingButton];
            
            [shippingButton bk_addEventHandler:^(id sender) {
                [self editShipping];
            } forControlEvents:UIControlEventTouchUpInside];
            
            [shippingButton makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@30);
                make.width.equalTo(@50);
                make.right.equalTo(view).with.offset(-10);
                make.centerY.equalTo(view);
            }];
        }
        
        
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
        
        if(self.oneTimePairedCard) {
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
        
        return cell;
        
    }
    else if (indexPath.section == 5) { // Shipping
        
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellId];
        
        if (cell == nil)
        {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:textFieldCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textField.userInteractionEnabled = YES;
        if ([cell.contentView viewWithTag:kCheckoutAlertTypeCardType]) {
            [[cell.contentView viewWithTag:kCheckoutAlertTypeCardType] removeFromSuperview];
        }
        
        cell.textField.text = nil;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Street Address";
                if (self.selectedShippingInfo) {
                    cell.textField.text = self.selectedShippingInfo.street;
                }
                break;
            case 1:
                cell.textLabel.text = @"City";
                if (self.selectedShippingInfo) {
                    cell.textField.text = self.selectedShippingInfo.city;
                }
                break;
            case 2:
                cell.textLabel.text = @"State";
                if (self.selectedShippingInfo) {
                    cell.textField.text = self.selectedShippingInfo.state;
                }
                break;
            case 3:
                cell.textLabel.text = @"Zip";
                if (self.selectedShippingInfo) {
                    cell.textField.text = self.selectedShippingInfo.zip;
                }
                break;
            default:
                cell.textLabel.text = nil;
                break;
        }
        
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
        
        return cell;
        
    }
    
    //fallback
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"DefaultCell"];
}
@end
