//
//  Product+NormalizedPrice.m
//  MasterPass
//
//  Created by David Benko on 11/26/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "Product+NormalizedPrice.h"


@implementation Product (NormalizedPrice)
-(NSNumber *)normalizedPrice{
    return [NSNumber numberWithDouble:[self.price doubleValue] / 100.];
}
@end
