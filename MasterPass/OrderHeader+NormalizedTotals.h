//
//  OrderHeader+NormalizedTotals.h
//  MasterPass
//
//  Created by David Benko on 11/26/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <APSDK/OrderHeader.h>

@interface OrderHeader (NormalizedTotals)
-(NSNumber *)normalizedSubTotal;
@end
