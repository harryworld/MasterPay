//
//  DrawerViewController.h
//  MasterPass
//
//  Created by David Benko on 5/13/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController/ICSDrawerController.h"

@interface DrawerViewController : UITableViewController <ICSDrawerControllerChild, ICSDrawerControllerPresenting>
@property(nonatomic, weak) ICSDrawerController *drawer;
@end
