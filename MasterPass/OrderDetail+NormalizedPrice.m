//
//  OrderDetail+NormalizedPrice.m
//  MasterPass
//
//  Created by David Benko on 11/26/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "OrderDetail+NormalizedPrice.h"

@implementation OrderDetail (NormalizedPrice)
-(NSNumber *)normalizedPrice{
    return [NSNumber numberWithDouble:[self.productPrice doubleValue] / 100.];
}
@end
