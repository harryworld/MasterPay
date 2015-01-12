//
//  OrderConfirmationViewController.h
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmationViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) BOOL purchasedWithMP;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSNumber *total;
@end
