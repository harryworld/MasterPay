//
//  CheckoutViewController.h
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CheckoutAlertType {
    kCheckoutAlertTypeMasterPassPassword,
    kCheckoutAlertTypeCardType,
    kCheckoutAlertTypeShippingInfo
} CheckoutAlertType;
#import "ProcessOrderCell.h"

@interface CheckoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, assign)ProcessButtonType buttonType;
@property(nonatomic, weak) IBOutlet UITableView *containerTable;

@property(nonatomic, assign)BOOL precheckoutConfirmation;
@property(nonatomic, strong) NSArray *cards;
@property(nonatomic, strong) NSArray *addresses;
@property(nonatomic, strong) NSDictionary *walletInfo;

@property (nonatomic, strong) NSNumber *subtotal;
@property (nonatomic, strong) NSNumber *tax;
@property (nonatomic, strong) NSNumber *shipping;
@property (nonatomic, strong) NSNumber *total;

-(void)selectShipping:(int)index;
@end
