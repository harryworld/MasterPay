//
//  DrawerViewController.m
//  MasterPass
//
//  Created by David Benko on 5/13/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "DrawerViewController.h"
#import "DrawerItemCell.h"
#import "BaseNavigationController.h"

@implementation DrawerViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor deepBlueColor];
    self.tableView.separatorColor = [UIColor cartSeperatorColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    self.tableView.tableHeaderView = header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" GADGET SHOP";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    DrawerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[DrawerItemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    switch (indexPath.row) {
        case 0:{
            cell.itemLabel.text = @"Home";
            FAKFontAwesome *homeIcon = [FAKFontAwesome homeIconWithSize:20];
            [homeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor superGreyColor]];
            cell.iconView.image = [homeIcon imageWithSize:CGSizeMake(20, 20)];
            break;
        }
        case 1:{
            cell.itemLabel.text = @"My Cart";
            FAKFontAwesome *cartIcon = [FAKFontAwesome shoppingCartIconWithSize:20];
            [cartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor superGreyColor]];
            cell.iconView.image = [cartIcon imageWithSize:CGSizeMake(20, 20)];
            break;
        }
        case 2:{
            cell.itemLabel.text = @"My Profile";
            FAKFontAwesome *userIcon = [FAKFontAwesome userIconWithSize:20];
            [userIcon addAttribute:NSForegroundColorAttributeName value:[UIColor superGreyColor]];
            cell.iconView.image = [userIcon imageWithSize:CGSizeMake(20, 20)];
            break;
        }
        case 3:{
            cell.itemLabel.text = @"Settings";
            FAKFontAwesome *gearIcon = [FAKFontAwesome cogsIconWithSize:20];
            [gearIcon addAttribute:NSForegroundColorAttributeName value:[UIColor superGreyColor]];
            cell.iconView.image = [gearIcon imageWithSize:CGSizeMake(20, 20)];
            break;
        }
        default:
            cell.itemLabel.text = nil;
            cell.iconView.image = nil;
            break;
    }
    
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle: nil];
    switch (indexPath.row) {
        case 0:{
            BaseNavigationController *products = [storyboard instantiateViewControllerWithIdentifier:@"ProductsList"];
            [self.drawer replaceCenterViewControllerWithViewController:products];
            break;
        }
        case 1:{
            BaseNavigationController *cart = [storyboard instantiateViewControllerWithIdentifier:@"Cart"];
            [self.drawer replaceCenterViewControllerWithViewController:cart];
            break;
        }
        case 2:{
            UIViewController *cart = [storyboard instantiateViewControllerWithIdentifier:@"UserProfile"];
            BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:cart];
            [self.drawer replaceCenterViewControllerWithViewController:nav];
            break;
        }
        case 3:{
            UIViewController *settings = [storyboard instantiateViewControllerWithIdentifier:@"Settings"];
            BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:settings];
            [self.drawer replaceCenterViewControllerWithViewController:nav];
            break;
        }
        default:
            break;
    }
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.tableView.layoutMargins = UIEdgeInsetsZero;
}

@end
