//
//  SettingsViewController.m
//  MasterPass
//
//  Created by David Benko on 5/16/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "SettingsViewController.h"
#import "CardManager.h"

@implementation SettingsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    CardManager *cm = [CardManager getInstance];
    self.mpExpress.on = cm.isExpressEnabled;
    self.mpPaired.on = cm.isLinkedToMasterPass;
    
}

-(IBAction)switchMPLinked:(UISwitch *)sender{
    CardManager *cm = [CardManager getInstance];
    cm.isLinkedToMasterPass = sender.on;
}
-(IBAction)switchMPExpress:(UISwitch *)sender{
    CardManager *cm = [CardManager getInstance];
    cm.isExpressEnabled = sender.on;
}
@end
