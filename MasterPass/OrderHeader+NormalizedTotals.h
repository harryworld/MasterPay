//
//  OrderHeader+NormalizedTotals.h
//  MasterPass
//
//  Created by David Benko on 11/26/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <APSDK/OrderHeader.h>

@interface OrderHeader (NormalizedTotals)
-(NSNumber *)normalizedSubTotal;
-(NSNumber *)normalizedTax;
-(NSNumber *)normalizedShipping;
-(NSNumber *)normalizedTotal;
@end
