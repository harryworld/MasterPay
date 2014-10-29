//
//  MPECommerceManager.m
//  MasterPass
//
//  Created by David Benko on 10/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "MPECommerceManager.h"
#import <APSDK/APObject+Remote.h>
#import <APSDK/OrderHeader+Remote.h>
#import <APSDK/OrderDetail+Remote.h>
#import <APSDK/Product+Remote.h>

@interface MPECommerceManager ()
@property (nonatomic, strong) NSString *cartId;
@property (nonatomic, strong) NSArray *productCache;
@end

@implementation MPECommerceManager

- (void)getAllProducts:(void (^)(NSArray *products))callback{
    [Product allAsync:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error Retrieving Products: %@", [error localizedDescription]);
        }
    }];
}

- (void)getCurrentCart:(void (^)(NSArray *cart))callback{
    [self getCurrentCartHeader:^(OrderHeader *header) {
        [self getCartItemsForHeaderId:header.id callback:^(NSArray *cart) {
            if (callback) {
                callback(cart);
            }
        }];
    }];
}

-(void)getCurrentCartHeader:(void(^)(OrderHeader *header))callback{
    [OrderHeader query:@"my_open_orders" params:@{} async:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error Retrieving Cart Header: %@",[error localizedDescription]);
            if (callback) {
                callback(nil);
            }
        }
        else if (objects.count == 0) {
            NSLog(@"No Cart Headers Exist For User: %@",[error localizedDescription]);
            if (callback) {
                callback(nil);
            }
        }
        
        if (!error && callback) {
            callback([objects firstObject]);
        }
    }];
}

- (void)getCartItemsForHeaderId:(NSString *)headerId callback:(void (^)(NSArray *cart))callback{
    if (!headerId) {
        NSLog(@"Error: HeaderId is nil");
        return;
    }

    [OrderDetail exactMatchWithParams:@{@"order_header_id":headerId} async:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error Retrieving Cart Items: %@",[error localizedDescription]);
        }
        
        if (callback) {
            callback(objects);
        }
    }];
}

- (void)addProductToCart:(Product *)product{
    OrderDetail *od = [OrderDetail new];
    od.orderHeaderId = self.cartId;
    od.productId = product.id;
    [od createAsync:^(id object, NSError *error) {
        if (error) {
            NSLog(@"Error Adding Product to Cart (%@): %@",self.cartId,[error localizedDescription]);
        }
    }];
}
@end
