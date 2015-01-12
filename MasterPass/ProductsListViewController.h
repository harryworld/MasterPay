//
//  ProductsListViewController.h
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KLScrollSelect/KLScrollSelect.h>
#import "BaseViewController.h"

@interface ProductsListViewController : BaseViewController <KLScrollSelectDataSource, KLScrollSelectDelegate>

@end
