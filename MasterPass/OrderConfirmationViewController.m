//
//  OrderConfirmationViewController.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "OrderConfirmationViewController.h"
#import "SubtotalTitleItemCell.h"
#import "TextViewCell.h"
#import "OrderConfirmationCell.h"
#import "CartManager.h"
#import "ContinueShoppingCell.h"

@interface OrderConfirmationViewController ()
@property (nonatomic, weak)IBOutlet UITableView *confirmationTable;
@end

@implementation OrderConfirmationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.confirmationTable.backgroundColor = [UIColor superGreyColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CartManager *cm = [CartManager getInstance];
    [cm.products removeAllObjects];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:return 1;
        case 1:return 1;
        case 2: return 1;
        case 3: return 1;
        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:return 35;
        case 1:return 70;
        case 2:return 150;
        case 3: return 50;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *subTotalTitleCellId = @"SubtotalTitleCell";
    static NSString *textViewCellId = @"TextViewCell";
    static NSString *orderConfirmationCell = @"orderConfirmationCell";
    static NSString *continueShoppingCell = @"continueCell";
    
    if (indexPath.section == 0) {
        
        SubtotalTitleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:subTotalTitleCellId];
        
        if (cell == nil)
        {
            cell = [[SubtotalTitleItemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:subTotalTitleCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"Order Confirmation #: 54126";
        return cell;
        
    }
    else if (indexPath.section == 1) {
        
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textViewCellId];
        
        if (cell == nil)
        {
            cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:textViewCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textView.text = @"Your order has been processed. You will recieve an email confirmation with your order details.";
        return cell;
        
    }
    else if (indexPath.section == 2) {
        
        OrderConfirmationCell *cell = [tableView dequeueReusableCellWithIdentifier:orderConfirmationCell];
        
        if (cell == nil)
        {
            cell = [[OrderConfirmationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:orderConfirmationCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CartManager *cm = [CartManager getInstance];
        cell.totalPriceLabel.text = [self formatCurrency:[NSNumber numberWithDouble:[cm total]]];
        
        return cell;
        
    }
    else if (indexPath.section == 3) {
        
        ContinueShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:continueShoppingCell];
        
        if (cell == nil)
        {
            cell = [[ContinueShoppingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:continueShoppingCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell.continueShoppingButton bk_addEventHandler:^(id sender) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }
    
    //fallback
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"DefaultCell"];
}

-(NSString *)formatCurrency:(NSNumber *)price{
    double currency = [price doubleValue];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:currency]];
    return numberAsString;
}
@end
