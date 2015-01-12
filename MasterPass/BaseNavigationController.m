//
//  BaseNavigationController.m
//  MasterPass
//
//  Created by David Benko on 5/21/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController
-(IBAction)toggleDrawer{
    [self.drawer toggle];
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}
@end
