//
//  UserProfileViewController.m
//  MasterPass
//
//  Created by David Benko on 4/28/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TextFieldCell.h"
#import "MPConnectCell.h"
#import "MPLinkedCell.h"
#import "MPLearnMoreCell.h"
#import "MPManager.h"
#import <APSDK/AuthManager+Protected.h>
#import <APSDK/User.h>
#import <APSDK/APObject+Local.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface UserProfileViewController ()
@property(nonatomic, weak) IBOutlet UITableView *profileTable;
@end

@implementation UserProfileViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.profileTable.backgroundColor = [UIColor superGreyColor];
    if ([self.profileTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.profileTable setSeparatorInset:UIEdgeInsetsZero];
    }
    self.profileTable.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (connected) name:@"ConnectedMasterPass" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (notConnected) name:@"MasterPassConnectionCancelled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (connectMasterPass) name:@"mp_connect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (learnMore) name:@"mp_learn_more" object:nil];
    
    // Call precheckout to test if we are actually paired
    // This is a bit of a hack, but it fixes the issue
    // where a user un-pairs from MasterPass console
    // but the ecommerce doesn't know (still thinks
    // it has a valid long token)
    
    
    MPManager *manager = [MPManager sharedInstance];
    if ([manager isAppPaired]) {
        [manager precheckoutDataCallback:^(NSArray *cards, NSArray *addresses, NSDictionary *contactInfo, NSDictionary *walletInfo, NSError *error) {
            // Hack to force pairing status reload.
            // This can be replaced once there is a
            // public pairing status check against MasterPass
            [self.profileTable reloadData];
        }];
    }
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.profileTable.layoutMargins = UIEdgeInsetsZero;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(IBAction)connectMasterPass{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MPManager *manager = [MPManager sharedInstance];
    [manager pairInViewController:self];
}

-(IBAction)learnMore{
    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Connect with MasterPass" andMessage:@"Connect your MasterPass with GadgetShop to check out faster. When you connect your MasterPass to GadgetShop, GadgetShop receives certain information that it may use to personalize your shopping experience and help you make easier purchases."];
    
    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
    
    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alert show];
    
}

-(void)connected {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.profileTable reloadData];
    
    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Connect with MasterPass" andMessage:@"Your account is now paired with your MasterPass wallet. The next time you checkout, you will simply need to enter your MasterPass password to process the order."];
    
    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
    
    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alert show];
}

-(void)notConnected {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:return 1;
        case 1:return 1;
        case 2:return 1;
        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:return 44;
        case 1:{
            if ([[MPManager sharedInstance] isAppPaired]) {
                return 60;
            }
            else {
                return 70;
            }
        }
        case 2:return 60;
        default: return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }
    else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        view.backgroundColor = [UIColor superGreyColor];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectZero];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"Edit Profile Information";
        [view addSubview:title];
        [title makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
            make.center.equalTo(view);
        }];
        
        return view;
    }
    else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *processCellId = @"ProcessOrerCellId";
    static NSString *textFieldCellId = @"TextFieldCell";
    static NSString *linkedCell = @"MPLinkedCell";
    static NSString *learnmoreCell = @"MPLearnMoreCell";
    
    if (indexPath.section == 0) {
        
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellId];
        if (cell == nil)
        {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:textFieldCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        User *user = (User *)[[AuthManager defaultManager] currentCredentials];
        
        [cell.textField setUserInteractionEnabled:false];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Username";
                cell.textField.text = user.email;
                break;
            default:
                cell.textLabel.text = nil;
                cell.textField.text = nil;
                break;
        }
        
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    else if (indexPath.section == 1) {
        if ([[MPManager sharedInstance] isAppPaired]) {
            MPLinkedCell *cell = [tableView dequeueReusableCellWithIdentifier:linkedCell];
            if (cell == nil)
            {
                cell = [[MPLinkedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:linkedCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.layoutMargins = UIEdgeInsetsZero;
            return cell;
        }
        else {
            MPConnectCell *cell = [tableView dequeueReusableCellWithIdentifier:processCellId];
            if (cell == nil)
            {
                cell = [[MPConnectCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:processCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.layoutMargins = UIEdgeInsetsZero;
            return cell;
        }
        
    }
    else if (indexPath.section == 2) {
        MPLearnMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:learnmoreCell];
        if (cell == nil)
        {
            cell = [[MPLearnMoreCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:learnmoreCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    
    //fallback
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"DefaultCell"];
}
@end
