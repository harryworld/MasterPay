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
    
    
    /*UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.profileTable.frame.size.width, 100)];
    header.backgroundColor = [UIColor deepBlueColor];
    
    self.profileTable.tableHeaderView = header;*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (connected) name:@"ConnectedMasterPass" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (connectMasterPass) name:@"mp_connect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (learnMore) name:@"mp_learn_more" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(IBAction)connectMasterPass{
    CardManager *cm = [CardManager getInstance];
    if ([cm isLinkedToMasterPass]) {
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Connect with MasterPass" andMessage:@"You are already paired with your MasterPass account!"];
        
        [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
        
        alert.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alert show];
    }
    else {
        [self performSegueWithIdentifier:@"MPConnect" sender:nil
                               withBlock:^(id sender, id destinationVC) {
                                   CardManager *cm = [CardManager getInstance];
                                   MasterPassConnectViewController *dest = [[((UINavigationController *)destinationVC) viewControllers] firstObject];
                                   unless (cm.isExpressEnabled) {
                                       dest.path = [[NSBundle mainBundle] pathForResource:@"mp1" ofType:@"html"];
                                   }
                                   else {
                                       dest.path = [[NSBundle mainBundle] pathForResource:@"mp1-express" ofType:@"html"];
                                   }
                               }];
    }
}

-(IBAction)learnMore{
    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Connect with MasterPass" andMessage:@"Connect with MasterPass allows for a better and quicker shopping experience. You first need to pair this merchant site with your MasterPass wallet"];
    
    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
    
    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alert show];
    
}

-(void)connected{
    
    CardManager *cm = [CardManager getInstance];
    cm.isLinkedToMasterPass = YES;
    
    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Connect with MasterPass" andMessage:@"Your account is now paired with your MasterPass wallet. The next time you checkout, you will simply need to enter your MasterPass password to process the order."];
    
    [alert addButtonWithTitle:@"Submit" type:SIAlertViewButtonTypeCancel handler:nil];
    
    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alert show];
}
#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:return 3;
        case 1:return 1;
        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:return 44;
        case 1: return 180;
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
                cell.textField.text = @"Justin Guavin";
                break;
            case 1:
                cell.textLabel.text = @"Email";
                cell.textField.text = @"j.guavin@gmail.com";
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
        
        return cell;
        
    }
    if (indexPath.section == 1) {
        
        MPConnectCell *cell = [tableView dequeueReusableCellWithIdentifier:processCellId];
        
        if (cell == nil)
        {
            cell = [[MPConnectCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:processCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    
    //fallback
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"DefaultCell"];
}
@end
