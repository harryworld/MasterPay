//
//  PasswordViewController.m
//  MasterPass
//
//  Created by Christian Sampaio on 7/28/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "PasswordViewController.h"

@implementation PasswordViewController

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock) {
            self.completionBlock(NO);
        }
    }];
}

- (IBAction)confirmAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock) {
            self.completionBlock(YES);
        }
    }];
}

@end
