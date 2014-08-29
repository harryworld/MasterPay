//
//  MasterPassConnectViewController.h
//  MasterPass
//
//  Created by David Benko on 4/28/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterPassConnectViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, strong)NSString *path;
@property (nonatomic, assign)BOOL checkoutAuth;
@end
