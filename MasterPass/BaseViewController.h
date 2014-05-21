//
//  BaseViewController.h
//  MasterPass
//
//  Created by David Benko on 5/14/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
@interface BaseViewController : UIViewController <ICSDrawerControllerChild, ICSDrawerControllerPresenting>
@property(nonatomic, weak) ICSDrawerController *drawer;
@end
