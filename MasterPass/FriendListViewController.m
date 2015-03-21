//
//  FriendListViewController.m
//  MasterPass
//
//  Created by Harry Ng on 21/3/15.
//  Copyright (c) 2015 David Benko. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendFieldCell.h"

@interface FriendListViewController ()

@property(nonatomic, weak) IBOutlet UITableView *friendTable;

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Friend List");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *textFieldCellId = @"FriendFieldCell";
    
    if (indexPath.section == 0) {
        
        FriendFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellId];
        if (cell == nil)
        {
            cell = [[FriendFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:textFieldCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell.textField setUserInteractionEnabled:false];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Harry";
                break;
            case 1:
                cell.textLabel.text = @"David";
                break;
            case 2:
                cell.textLabel.text = @"Ian";
                break;
            default:
                cell.textLabel.text = nil;
                cell.textField.text = nil;
                break;
        }
        
        cell.layoutMargins = UIEdgeInsetsZero;
        return cell;
        
    }
    
    //fallback
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"DefaultCell"];
}

@end
