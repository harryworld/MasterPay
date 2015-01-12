//
//  UserRegistrationViewController.h
//  MasterPass
//
//  Created by David Benko on 12/3/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UserRegistrationViewController : BaseViewController 
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@end
