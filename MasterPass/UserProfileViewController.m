//
//  UserProfileViewController.m
//  MasterPass
//
//  Created by David Benko on 4/28/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TextFieldCell.h"
#import "MPConnectCell.h"
#import "CardManager.h"
#import "MasterPassConnectViewController.h"
#import "MPLinkedCell.h"
#import "MPLearnMoreCell.h"
#import "MPManager.h"
#import <APSDK/AuthManager+Protected.h>
#import <APSDK/User.h>
#import <APSDK/APObject+Local.h>

@interface UserProfileViewController () <MPManagerDelegate>
@property(nonatomic, weak) IBOutlet UITableView *profileTable;
@end

@implementation UserProfileViewController

//TODO
/*
 Pairing Works but none of the events fire correctly yet.
 Will need extra work to continue with pairing events
 */

-(NSString *)serverAddress{
    return @"https://mysterious-beyond-8033.herokuapp.com";
}


-(void)pairingDidComplete:(BOOL)success error:(NSError *)error{
    NSLog(@"Pairing Did Complete: %d",success);
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.profileTable.backgroundColor = [UIColor superGreyColor];
    if ([self.profileTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.profileTable setSeparatorInset:UIEdgeInsetsZero];
    }
    self.profileTable.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (connected) name:@"ConnectedMasterPass" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (connectMasterPass) name:@"mp_connect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (learnMore) name:@"mp_learn_more" object:nil];
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.profileTable.layoutMargins = UIEdgeInsetsZero;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(IBAction)connectMasterPass{
    
    User *user = (User *)[[AuthManager defaultManager] currentCredentials];
    if ([[user isPaired] boolValue]) {
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Connect with MasterPass" andMessage:@"You are already paired with your MasterPass account!"];
        
        [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
        
        alert.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alert show];
    }
    else {
        MPManager *manager = [MPManager sharedInstance];
        manager.delegate = self;
        [manager pairInViewController:self callback:^(BOOL success, NSError *error) {
            NSLog(@"Pair complete");
        }];
    }
}

-(IBAction)learnMore{
    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Connect with MasterPass" andMessage:@"Connect your MasterPass with GadgetShop to check out faster. When you connect your MasterPass to GadgetShop, GadgetShop receives certain information that it may use to personalize your shopping experience and help you make easier purchases."];
    
    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
    
    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alert show];
    
}

-(void)connected{
    
    CardManager *cm = [CardManager getInstance];
    cm.isLinkedToMasterPass = YES;
    
    User *user = (User *)[[AuthManager defaultManager] currentCredentials];
    user.isPaired = @1;
    [user saveLocal];
    
    
    [self.profileTable reloadData];
    
    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Connect with MasterPass" andMessage:@"Your account is now paired with your MasterPass wallet. The next time you checkout, you will simply need to enter your MasterPass password to process the order."];
    
    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
    
    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alert show];
}
#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:return 3;
        case 1:return 1;
        case 2:return 1;
        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:return 44;
        case 1:{
            User *user = (User *)[[AuthManager defaultManager] currentCredentials];
            if ([user.isPaired boolValue]) {
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
        
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Name";
                cell.textField.text = @"Susan Smith";
                break;
            case 1:
                cell.textLabel.text = @"Email";
                cell.textField.text = @"s.smith@mastercard.com";
                break;
            case 2:
                cell.textLabel.text = @"Phone";
                cell.textField.text = @"(808) 233-2342";
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
        User *user = (User *)[[AuthManager defaultManager] currentCredentials];
        if ([user.isPaired boolValue]) {
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
