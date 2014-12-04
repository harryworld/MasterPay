//
//  OrderHeader+NormalizedTotals.m
//  MasterPass
//
//  Created by David Benko on 11/26/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "OrderHeader+NormalizedTotals.h"

@implementation OrderHeader (NormalizedTotals)
-(NSNumber *)normalizedSubTotal{
    return [NSNumber numberWithDouble:[self.subtotal doubleValue] / 100.];
}
@end
