//
//  CartViewController.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "CartViewController.h"
#import "CartProductCell.h"
#import "CartManager.h"
#import "CardManager.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "MasterPassConnectViewController.h"
#import "BaseNavigationController.h"
#import "CheckoutViewController.h"
#import "MPECommerceManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <APSDK/User.h>
#import <APSDK/AuthManager+Protected.h>
#import <APSDK/OrderDetail.h>
#import "MPManager.h"

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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
    [ecommerce getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        self.orderHeader = header;
        self.orderDetails = cart;
        self.totalLabel.text = [self formatCurrency:header.subtotal];
        [self.cartTable reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    /*
     *
     * If already paired, contraints should already be linked in storyboard (we do nothing here)
     *
     * If not paired, we are overriding the storyboard setup and linking
     * our own constraints and event handlers
     *
     */
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (oneTimePairingComplete) name:@"ConnectedMasterPass" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmPreCheckout:) name:@"MasterPassPreCheckoutComplete" object:nil];
    
    [self.cartTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.totalLabel.text = [self formatCurrency:self.orderHeader.subtotal];
    [self.cartTable reloadData];
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
    MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
    [ecommerce getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        MPManager *manager = [MPManager sharedInstance];
        [manager pairCheckoutForOrder:header.id showInViewController:self];
    }];
}

-(void)confirmPreCheckout:(NSNotification *)notification{
    if (self.navigationController.visibleViewController == self) {
        NSDictionary *userInfo = [notification userInfo];
        NSDictionary *cardInfo = userInfo[@"checkout"][@"card"];
        NSDictionary *shippingInfo = userInfo[@"shipping_address"];
        MPCreditCard *card = [[MPCreditCard alloc]initWithDictionary:cardInfo];
        MPAddress *address = [[MPAddress alloc]initWithDictionary:shippingInfo];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        CheckoutViewController *vc = (CheckoutViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Checkout"];
        vc.precheckoutConfirmation = TRUE;
        vc.cards = @[card];
        vc.addresses = @[address];
        vc.walletInfo = @{@"transaction_id":userInfo[@"checkout"][@"transaction_id"],
                          @"pre_checkout_transaction_id":userInfo[@"checkout"][@"pre_checkout_transaction_id"]};
        vc.buttonType = kButtonTypeProcess;
        [vc.containerTable reloadData];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)oneTimePairingComplete{
    if (self.navigationController.visibleViewController == self) {
        CardManager *cm = [CardManager getInstance];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        CheckoutViewController *vc = (CheckoutViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Checkout"];
        vc.oneTimePairedCard = cm.cards.firstObject;
        vc.isPairing = YES;
        [vc selectShipping:0];
        vc.buttonType = kButtonTypeProcess;
        [vc.containerTable reloadData];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderDetails count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    CartProductCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[CartProductCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    OrderDetail *product = (OrderDetail *)[self.orderDetails objectAtIndex:indexPath.row];
    cell.product = product;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)moveToCheckout{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CheckoutViewController *checkout = (CheckoutViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Checkout"];
    NSLog(@"%@",self.navigationController.viewControllers);
    [self.navigationController pushViewController:checkout animated:YES];
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.cartTable.layoutMargins = UIEdgeInsetsZero;
}
@end
