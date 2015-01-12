//
//  UserRegistrationViewController.m
//  MasterPass
//
//  Created by David Benko on 12/3/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "UserRegistrationViewController.h"
#import <APSDK/User+Remote.h>
#import <APSDK/APObject+Remote.h>

@implementation UserRegistrationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.view.backgroundColor = [UIColor deepBlueColor];
}

-(IBAction)registerUser{
    if (self.emailField.text.length == 0) {
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Error" andMessage:@"Please enter a username"];
        [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
        alert.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alert show];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        User *u = [User new];
        u.email = self.emailField.text;
        [u createAsync:^(id object, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error) {
                SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Error" andMessage:@"Username already taken - Please try another"];
                [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
                alert.transitionStyle = SIAlertViewTransitionStyleBounce;
                [alert show];
            }
            else {
                SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Success" andMessage:@"You have successfully registered."];
                [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
                    [self close];
                }];
                alert.transitionStyle = SIAlertViewTransitionStyleBounce;
                [alert show];

            }
        }];
    }
}

-(void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
