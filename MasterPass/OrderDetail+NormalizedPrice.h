//
//  OrderDetail+NormalizedPrice.h
//  MasterPass
//
//  Created by David Benko on 11/26/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <APSDK/OrderDetail.h>

@interface OrderDetail (NormalizedPrice)
-(NSNumber *)normalizedPrice;
@end
