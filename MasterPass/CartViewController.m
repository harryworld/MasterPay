//
//  CartViewController.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "CartViewController.h"
#import "CartManager.h"
#import "CartProductCell.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface CartViewController ()
@property (nonatomic, weak)IBOutlet UITableView *cartTable;
@property (nonatomic, weak)IBOutlet UIView *footer;
@end

@implementation CartViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.footer.backgroundColor = [UIColor superGreyColor];
    self.cartTable.backgroundColor = [UIColor deepBlueColor];
    [self.cartTable setSeparatorColor:[UIColor cartSeperatorColor]];
    if ([self.cartTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.cartTable setSeparatorInset:UIEdgeInsetsZero];
    }
    self.cartTable.tableFooterView = [[UIView alloc] init];
    
    [self.cartTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.cartTable reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CartManager *manager = [CartManager getInstance];
    return [[manager products] count];    //count number of row from counting array hear cataGorry is An Array
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
    CartManager *manager = [CartManager getInstance];
    Product *product = (Product*)[[manager products] objectAtIndex:indexPath.row];
    cell.product = product;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
