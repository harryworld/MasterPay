//
//  CartViewController.h
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "BaseViewController.h"
@interface CartViewController : BaseViewController
@property(nonatomic,strong) Product * product;
@end
