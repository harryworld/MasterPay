//
//  Product.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "Product.h"

@implementation Product
- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        // Copy NSObject subclasses
        [copy setName:[self.name copyWithZone:zone]];
        [copy setImageUrl:[self.imageUrl copyWithZone:zone]];
        [copy setPrice:[self.price copyWithZone:zone]];
        [copy setDesc:[self.desc copyWithZone:zone]];
        
        
        // Set primitives
        [copy setProductId:self.productId];
        [copy setQuantity:self.quantity];
    }
    
    return copy;
}
@end
