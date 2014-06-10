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
#import "ProcessOrderCell.h"
#import "Card.h"

@interface CheckoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)Card *oneTimePairedCard;
@property(nonatomic, assign)ProcessButtonType buttonType;
@property(nonatomic, weak) IBOutlet UITableView *containerTable;
@property(nonatomic, assign)BOOL isPairing;

-(void)selectShipping:(int)index;
@end
