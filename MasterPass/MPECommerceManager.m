//
//  MPECommerceManager.m
//  MasterPass
//
//  Created by David Benko on 10/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "MPECommerceManager.h"
#import <APSDK/APObject+Remote.h>
#import <APSDK/OrderDetail+Remote.h>
#import <APSDK/Product+Remote.h>
#import <APSDK/AuthManager+Protected.h>
#import <APSDK/User.h>

@interface MPECommerceManager ()
@property (nonatomic, strong) NSString *cartId;
@property (nonatomic, strong) NSArray *productCache;
@end

@implementation MPECommerceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static MPECommerceManager *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

- (void)getAllProducts:(void (^)(NSArray *products))callback{
    
    if (self.productCache && self.productCache.count > 0) {
        if (callback) {
            callback(self.productCache);
        }
    }
    else {
        [Product allAsync:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error Retrieving Products: %@", [error localizedDescription]);
            }
            else {
                self.productCache = objects;
                if (callback) {
                    callback(objects);
                }
            }
        }];
    }
}

- (void)getCurrentCart:(void (^)(OrderHeader *header, NSArray *cart))callback{
    [self getCurrentCartHeader:^(OrderHeader *header) {
        
        if (header) {
            [self getCartItemsForHeaderId:header.id callback:^(NSArray *cart) {
                if (callback) {
                    callback(header, cart);
                }
            }];
        }
        else {
            OrderHeader *newHeader = [[OrderHeader alloc]init];
            newHeader.userId = ((User *)[[AuthManager defaultManager]currentCredentials]).id;
            [newHeader createAsync:^(id object, NSError *error) {
                if (callback) {
                    callback((OrderHeader *)object, [[NSArray alloc]init]);
                }
            }];
        }
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
            NSLog(@"Error: No Cart Headers Exist For User");
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
    [self getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        
        for(OrderDetail *existing in cart) {
            if ([existing.productId isEqualToString:product.id]) {
                existing.quantity = [NSNumber numberWithInt:([existing.quantity intValue] + 1)];
                [existing updateAsync:^(id object, NSError *error) {
                    if (error) {
                        NSLog(@"Error Adding Product to Cart (%@): %@",self.cartId,[error localizedDescription]);
                    }
                }];
                return;
            }
        }
        
        OrderDetail *od = [[OrderDetail alloc]init];
        od.orderHeaderId = header.id;
        od.productId = product.id;
        od.quantity = @1;
        [od createAsync:^(id object, NSError *error) {
            if (error) {
                NSLog(@"Error Adding Product to Cart (%@): %@",self.cartId,[error localizedDescription]);
            }
        }];
    }];
}
@end
