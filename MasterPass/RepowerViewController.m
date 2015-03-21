//
//  RepowerViewController.m
//  MasterPass
//
//  Created by Harry Ng on 21/3/15.
//  Copyright (c) 2015 David Benko. All rights reserved.
//

#import "RepowerViewController.h"

@interface RepowerViewController ()

@end

@implementation RepowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)submitButtonClicked:(id)sender
{
    if ([self.amountToBeAdded.text isEqualToString:@""]) return;
    
    self.balance.text = self.amountToBeAdded.text;
}

@end
