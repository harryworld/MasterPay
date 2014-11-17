//
//  CartManager.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "CartManager.h"
#import <APSDK/Product.h>

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

- (void)addProductToCart:(Product *)product{
    //TODO
    /*NSArray *existingProductCheck = [self.products select:^BOOL(Product* object) {
        return object.productId == product.productId;
    }];
    
    if (existingProductCheck.count > 0) {
        Product *existing = [existingProductCheck firstObject];
        existing.quantity ++;
    }
    else{
        [self.products addObject:product];
    }*/
}

- (void)cleanCart{
    //TODO
    /*
    for (Product *product in self.products) {
        product.quantity = 1;
    }
    [self.products removeAllObjects];
     */
}

- (int)cartSize{
    //TODO
    /*
    __block int size = 0;
    [self.products each:^(Product* object) {
        size += object.quantity;
    }];
    
    return size;
     */
    return 0;
}

- (NSArray *)expandedCart{
    //TODO
    /*NSMutableArray *expanded = [[NSMutableArray alloc]init];
    [self.products each:^(Product* object) {
        for (int i = 0; i < object.quantity; i++) {
            Product *p = [object copy];
            p.quantity = 1;
            [expanded addObject:p];
        }
    }];
    
    return expanded;
     */
    return [NSArray new];
}

- (double)subtotal{
    __block double subTotal = 0;
    [self.products each:^(Product* object) {
        subTotal += [object.price doubleValue];
    }];
    
    return subTotal;
}

- (double)tax{
    return [self subtotal] * 0.13;
}

- (double)shipping{
    return [[self products] count] * 4.37;
}

- (double)total{
    return [self subtotal] + [self tax] + [self shipping];
}
@end
