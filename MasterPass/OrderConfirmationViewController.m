//
//  OrderConfirmationViewController.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "OrderConfirmationViewController.h"
#import "TextViewCell.h"
#import "CartManager.h"
#import "ContinueShoppingCell.h"
#import "TableTitleCell.h"
#import "CartProductCell.h"
#import "BoldTotalItemCell.h"

@interface OrderConfirmationViewController ()
@property (nonatomic, weak) IBOutlet UITableView *confirmationTable;
@property (nonatomic, weak) IBOutlet UIView *footer;
@property (nonatomic, weak) IBOutlet UIButton *continueButton;
@end

@implementation OrderConfirmationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.confirmationTable.backgroundColor = [UIColor superGreyColor];
    self.footer.backgroundColor = [UIColor fireOrangeColor];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    CartManager *cm = [CartManager getInstance];
    [cm.products removeAllObjects];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:return 1;
        case 1:return 1;
        case 2:{
            CartManager *cm = [CartManager getInstance];
            return cm.products.count;
        }
        case 3:return 1;
        case 4:return 1;
        default:return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:return 150;
        case 1:return 50;
        case 2:return 50;
        case 3: return 50;
        case 4: return 50;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleCellId = @"TitleCell";
    static NSString *textViewCellId = @"TextViewCell";
    static NSString *continueShoppingCell = @"continueCell";
    static NSString *itemCell = @"Cell";
    
    if (indexPath.section == 0) {
        
        TableTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        
        if (cell == nil)
        {
            cell = [[TableTitleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:titleCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.headline.text = @"Success";
        cell.tagline.text = @"Your purchase has been confirmed and will ship soon.";
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
        cell.textView.text = @"CONFIRMATION";
        cell.textView.textAlignment = NSTextAlignmentCenter;
        cell.textView.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textView.textColor = [UIColor deepBlueColor];
        cell.textView.scrollEnabled = NO;
        cell.textView.selectable = NO;
        cell.textView.font = [UIFont boldSystemFontOfSize:20];
        return cell;
        
    }
    else if (indexPath.section == 2) {
        
        CartProductCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
        
        if (cell == nil)
        {
            cell = [[CartProductCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:itemCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CartManager *cm = [CartManager getInstance];
        [cell setProduct:(Product *)[[cm products] objectAtIndex:indexPath.row]];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.productName.textColor = [UIColor deepBlueColor];
        [cell.productImage.layer setBorderWidth:0];
        [cell.productImage.layer setBorderColor:nil];
        [cell.productImage.layer setCornerRadius:0];
        
        return cell;
        
    }
    else if (indexPath.section == 3){
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textViewCellId];
        
        if (cell == nil)
        {
            cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:textViewCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textView.text = @"Order Confirmation Number: D64H7829";
        cell.textView.textAlignment = NSTextAlignmentCenter;
        cell.textView.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textView.textColor = [UIColor deepBlueColor];
        cell.textView.scrollEnabled = NO;
        cell.textView.selectable = NO;
        cell.textView.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    else if (indexPath.section == 4) {
        
        BoldTotalItemCell *cell = [tableView dequeueReusableCellWithIdentifier:continueShoppingCell];
        
        if (cell == nil)
        {
            cell = [[BoldTotalItemCell alloc] initWithStyle:UITableViewCellStyleValue2
                                                reuseIdentifier:continueShoppingCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"Total";
        CartManager *cm = [CartManager getInstance];
        cell.detailTextLabel.text = [self formatCurrency:[NSNumber numberWithDouble:[cm total]]];
        
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

-(IBAction)finish{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartOver" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
