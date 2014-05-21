//
//  CheckoutViewController.h
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CheckoutAlertType {
    kCheckoutAlertTypeMasterPassPassword,
    kCheckoutAlertTypeCardType,
    kCheckoutAlertTypeShippingInfo
} CheckoutAlertType;

@interface CheckoutViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end
