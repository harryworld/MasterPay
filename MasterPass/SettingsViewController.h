//
//  SettingsViewController.h
//  MasterPass
//
//  Created by David Benko on 5/16/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingsViewController : BaseViewController
@property(nonatomic, weak) IBOutlet UISwitch *mpPaired;
@property(nonatomic, weak) IBOutlet UISwitch *mpExpress;
@end
