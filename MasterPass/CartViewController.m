//
//  CartViewController.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "CartViewController.h"
#import "CartProductCell.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "BaseNavigationController.h"
#import "CheckoutViewController.h"
#import "MPECommerceManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <APSDK/User.h>
#import <APSDK/AuthManager+Protected.h>
#import <APSDK/OrderDetail.h>
#import "MPManager.h"
#import "OrderHeader+NormalizedTotals.h"

@interface CartViewController ()
@property (nonatomic, weak)IBOutlet UITableView *cartTable;
@property (nonatomic, weak)IBOutlet UIView *footer;
@property (nonatomic, weak)IBOutlet UIView *totalBar;
@property (nonatomic, weak)IBOutlet UILabel *totalLabel;
@property (nonatomic, weak)IBOutlet UIButton *checkoutButton;
@property (nonatomic, strong) UIButton *masterPassButton;
@property (nonatomic, strong) OrderHeader *orderHeader;
@property (nonatomic, strong) NSArray *orderDetails;
@end

@implementation CartViewController

#pragma mark - UIViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.footer.backgroundColor = [UIColor superGreyColor];
    self.totalBar.backgroundColor = [UIColor deepBlueColor];
    self.cartTable.backgroundColor = [UIColor deepBlueColor];
    [self.cartTable setSeparatorColor:[UIColor cartSeperatorColor]];
    if ([self.cartTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.cartTable setSeparatorInset:UIEdgeInsetsZero];
    }
    self.cartTable.tableFooterView = [[UIView alloc] init];
    
    [self reloadCart];
    
    /*
     *
     * If already paired, contraints should already be linked in storyboard (we do nothing here)
     *
     * If not paired, we are overriding the storyboard setup and linking
     * our own constraints and event handlers
     *
     */
    
    [self notPairedUISetup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmPreCheckout:) name:@"MasterPassPreCheckoutComplete" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(precheckoutCancelled) name:@"MasterPassPreCheckoutCancelled" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (reloadCart) name:@"StartOver" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)reloadCart{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
    [ecommerce getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        self.orderHeader = header;
        self.orderDetails = cart;
        self.totalLabel.text = [self formatCurrency:[header normalizedSubTotal]];
        [self.cartTable reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.totalLabel.text = [self formatCurrency:[self.orderHeader normalizedSubTotal]];
    [self.cartTable reloadData];
}

-(void)notPairedUISetup{
    if(![[MPManager sharedInstance] isAppPaired]) {
        [self.footer removeConstraints:self.footer.constraints];
        [self.footer updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@150);
            make.width.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.centerX.equalTo(self.view);
        }];
        
        self.masterPassButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.masterPassButton setBackgroundImage:[UIImage imageNamed:@"buy-with-masterpass.png"] forState:UIControlStateNormal];
        [self.footer addSubview:self.masterPassButton];
        [self.checkoutButton removeConstraints:self.checkoutButton.constraints];
        [self.masterPassButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
            make.width.equalTo(@280);
            make.top.equalTo(self.footer).with.offset(10);
            make.centerX.equalTo(self.footer);
        }];
        
        [self.masterPassButton bk_addEventHandler:^(id sender) {
            [self pairAndCheckout];
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.checkoutButton makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.footer).with.offset(-10);
            make.height.equalTo(@40);
            make.width.equalTo(@280);
            make.centerX.equalTo(self.footer);
        }];
        
        UILabel *orLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        orLabel.textAlignment = NSTextAlignmentCenter;
        orLabel.font = [UIFont boldSystemFontOfSize:20];
        orLabel.textColor = [UIColor deepBlueColor];
        orLabel.text = @"- OR -";
        [self.footer addSubview:orLabel];
        [orLabel makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@280);
            make.top.equalTo(self.masterPassButton.bottom);
            make.bottom.equalTo(self.checkoutButton.top);
            make.centerX.equalTo(self.footer);
        }];
    }
}

#pragma mark - Data Formatting
-(NSString *)formatCurrency:(NSNumber *)price{
    double currency = [price doubleValue];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:currency]];
    return numberAsString;
}

#pragma mark - Pairing Flow

-(void)pairAndCheckout{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
    [ecommerce getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        MPManager *manager = [MPManager sharedInstance];
        [manager pairCheckoutForOrder:header.id showInViewController:self];
    }];
}

-(void)precheckoutCancelled{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)confirmPreCheckout:(NSNotification *)notification{
    if (self.navigationController.visibleViewController == self) {
        
        // TODO merge with moveToCheckout:
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
        __weak typeof(self) weakSelf = self;
        [ecommerce getCurrentCart:^(OrderHeader *header, NSArray *cart) {
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            CheckoutViewController *checkout = (CheckoutViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Checkout"];
            
            checkout.subtotal = [header normalizedSubTotal];
            checkout.total = [header normalizedTotal];
            checkout.tax = [header normalizedTax];
            checkout.shipping = [header normalizedShipping];
            
            NSDictionary *userInfo = [notification userInfo];
            NSDictionary *cardInfo = userInfo[@"checkout"][@"card"];
            NSDictionary *shippingInfo = userInfo[@"checkout"][@"shipping_address"];
            MPCreditCard *card = [[MPCreditCard alloc]initWithDictionary:cardInfo];
            MPAddress *address = [[MPAddress alloc]initWithDictionary:shippingInfo];
            
            checkout.precheckoutConfirmation = TRUE;
            checkout.cards = @[card];
            checkout.addresses = @[address];
            checkout.walletInfo = @{@"transaction_id":userInfo[@"checkout"][@"transaction_id"],
                              @"pre_checkout_transaction_id":userInfo[@"checkout"][@"pre_checkout_transaction_id"]};
            checkout.buttonType = kButtonTypeProcess;
            [checkout.containerTable reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [weakSelf.navigationController pushViewController:checkout animated:YES];
        }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    CartProductCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[CartProductCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }

    OrderDetail *product = (OrderDetail *)[self.orderDetails objectAtIndex:indexPath.row];
    cell.product = product;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

-(IBAction)moveToCheckout{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    
    MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    __block CheckoutViewController *checkout = (CheckoutViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Checkout"];
    
    [ecommerce getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        
        checkout.subtotal = [header normalizedSubTotal];
        checkout.total = [header normalizedTotal];
        checkout.tax = [header normalizedTax];
        checkout.shipping = [header normalizedShipping];
        
        MPManager *manager = [MPManager sharedInstance];
        if ([manager isAppPaired]) {
            [manager precheckoutDataCallback:^(NSArray *cards, NSArray *addresses, NSDictionary *contactInfo, NSDictionary *walletInfo, NSError *error) {
                
                if (error) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    [weakSelf notPairedUISetup];
                    
                    SIAlertView *alert = nil;
                    if ([error.localizedDescription isEqualToString:MPErrorNotPaired]) {
                        alert = [[SIAlertView alloc]initWithTitle:@"Message" andMessage:@"Your account is no longer paired with your MasterPass wallet. Please pair again."];
                    }
                    else {
                        alert = [[SIAlertView alloc]initWithTitle:@"Error" andMessage:[error localizedDescription]];
                    }
                    
                    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
                    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
                    [alert show];
                    
                    [weakSelf.cartTable reloadData];
                }
                else {
                    
                    checkout.cards = cards;
                    checkout.addresses = addresses;
                    checkout.walletInfo = walletInfo;
                    
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    [weakSelf.navigationController pushViewController:checkout animated:YES];
                }
            }];
        }
        else {
            [weakSelf.navigationController pushViewController:checkout animated:YES];
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        }
    }];
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.cartTable.layoutMargins = UIEdgeInsetsZero;
}
@end
