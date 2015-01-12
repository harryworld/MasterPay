//
//  BaseViewController.m
//  MasterPass
//
//  Created by David Benko on 5/14/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"

@implementation BaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count > 0) {
        if ([self.navigationController.viewControllers firstObject] == self) {
            FAKFontAwesome *barsIcon = [FAKFontAwesome barsIconWithSize:20];
            [barsIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
            UIImage *leftImage = [barsIcon imageWithSize:CGSizeMake(20, 20)];
            barsIcon.iconFontSize = 15;
            UIImage *leftLandscapeImage = [barsIcon imageWithSize:CGSizeMake(15, 15)];
            self.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithImage:leftImage
                               landscapeImagePhone:leftLandscapeImage
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(toggleDrawer)];
        }
    }
}

-(IBAction)toggleDrawer{
    if (self.navigationController) {
        BaseNavigationController *bnc = (BaseNavigationController *)self.navigationController;
        [bnc toggleDrawer];
    }
}
@end
