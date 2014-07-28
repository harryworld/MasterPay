//
//  PasswordViewController.h
//  MasterPass
//
//  Created by Christian Sampaio on 7/28/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController

@property (nonatomic, copy) void(^completionBlock)(BOOL validPassword);

@end
