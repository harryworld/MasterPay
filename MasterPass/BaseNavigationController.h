//
//  BaseNavigationController.h
//  MasterPass
//
//  Created by David Benko on 5/21/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
@interface BaseNavigationController : UINavigationController <ICSDrawerControllerChild, ICSDrawerControllerPresenting>
@property(nonatomic, weak) ICSDrawerController *drawer;
-(IBAction)toggleDrawer;
@end
