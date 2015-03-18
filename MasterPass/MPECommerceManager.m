//
//  MPECommerceManager.m
//  MasterPass
//
//  Created by David Benko on 10/27/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
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
            
            /*
             * Possible race condition here if we try to get the cart
             * header a bunch of times. If we figure that there is no cart,
             * we start a mutex lock on the singleton instance, and check again. 
             * If we are still sure that there is no cart, we will create one.
             */
            
            @synchronized (self) {
                NSError *queryError = nil;
                NSArray *headers = [OrderHeader query:@"my_open_orders" params:@{} error:&queryError];
                
                // Just kidding, there is a cart. Proceed as normal.
                if (!queryError && headers.count > 0) {
                    [self getCartItemsForHeaderId:[(headers[0]) id] callback:^(NSArray *cart) {
                        if (callback) {
                            callback(header, cart);
                        }
                    }];
                }
                // There is not a cart, create one
                else if (!queryError && headers.count == 0) {
                    NSError *createError = nil;
                    OrderHeader *newHeader = [[OrderHeader alloc]init];
                    newHeader.userId = ((User *)[[AuthManager defaultManager]currentCredentials]).id;
                    [newHeader create:&createError];
                    [self getCurrentCart:callback];
                }
                // Some other error. Do not recurse here, for fear of an infinite loop.
                else {
                    NSLog(@"Error Retrieving Cart: %@", [queryError localizedDescription]);
                    if (callback) {
                        callback(nil,nil);
                    }
                }
            }
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

- (void)addProductToCart:(Product *)product quantity:(NSNumber *)quantity callback:(void (^)(NSError *))callback{
    [self getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        
        for(OrderDetail *existing in cart) {
            if ([existing.productId isEqualToString:product.id]) {
                existing.quantity = [NSNumber numberWithInt:([existing.quantity intValue] + [quantity intValue])];
                [existing updateAsync:^(id object, NSError *error) {
                    
                    if (error) {
                        NSLog(@"Error Adding Product to Cart (%@): %@",self.cartId,[error localizedDescription]);
                    }
                    
                    if (callback) {
                        callback(error);
                    }
                }];
                return;
            }
        }
        
        OrderDetail *od = [[OrderDetail alloc]init];
        od.orderHeaderId = header.id;
        od.productId = product.id;
        od.quantity = quantity;
        [od createAsync:^(id object, NSError *error) {
            if (error) {
                NSLog(@"Error Adding Product to Cart (%@): %@",self.cartId,[error localizedDescription]);
            }
            
            if (callback) {
                callback(error);
            }
        }];
    }];

}

- (void)addProductToCart:(Product *)product callback:(void (^)(NSError *error))callback{
    [self getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        
        for(OrderDetail *existing in cart) {
            if ([existing.productId isEqualToString:product.id]) {
                existing.quantity = [NSNumber numberWithInt:([existing.quantity intValue] + 1)];
                [existing updateAsync:^(id object, NSError *error) {
                    
                    if (error) {
                        NSLog(@"Error Adding Product to Cart (%@): %@",self.cartId,[error localizedDescription]);
                    }
                    
                    if (callback) {
                        callback(error);
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
            
            if (callback) {
                callback(error);
            }
        }];
    }];
}

- (void)getCartQuantityCallback:(void (^)(NSNumber *quantity))callback{
    [self getCurrentCart:^(OrderHeader *header, NSArray *cart) {
        int quant = 0;
        for (OrderDetail *detail in cart) {
            quant += [detail.quantity intValue];
        }
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback([NSNumber numberWithInt:quant]);
            });
        }
    }];
}

@end
