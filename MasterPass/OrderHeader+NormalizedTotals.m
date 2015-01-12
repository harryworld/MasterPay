//
//  OrderHeader+NormalizedTotals.m
//  MasterPass
//
//  Created by David Benko on 11/26/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "OrderHeader+NormalizedTotals.h"

@implementation OrderHeader (NormalizedTotals)
-(NSNumber *)normalizedSubTotal{
    return [NSNumber numberWithDouble:[self.subtotal doubleValue] / 100.];
}
-(NSNumber *)normalizedTax{
    return [NSNumber numberWithDouble:[self.tax doubleValue] / 100.];
}
-(NSNumber *)normalizedShipping{
    return [NSNumber numberWithDouble:[self.shipping doubleValue] / 100.];
}
-(NSNumber *)normalizedTotal{
    return [NSNumber numberWithDouble:[self.total doubleValue] / 100.];
}
@end
