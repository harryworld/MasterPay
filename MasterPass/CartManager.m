//
//  CartManager.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "CartManager.h"
#import "Product.h"

@implementation CartManager
static CartManager *sharedInstance;

+ (void)initialize
{
    static BOOL initialized = NO;
    unless(initialized)
    {
        initialized = YES;
        sharedInstance = [[CartManager alloc] init];
        sharedInstance.products = [[NSMutableArray alloc]init];
    }
}

+ (CartManager *) getInstance{
    return sharedInstance;
}

-(double)subtotal{
    __block double subTotal = 0;
    [self.products each:^(Product* object) {
        subTotal += [object.price doubleValue];
    }];
    
    return subTotal;
}

-(double)tax{
    return [self subtotal] * 0.13;
}

-(double)shipping{
    return [self subtotal] *0.37;
}

-(double)total{
    return [self subtotal] + [self tax] + [self shipping];
}
@end
