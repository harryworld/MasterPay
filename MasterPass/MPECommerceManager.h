//
//  MPECommerceManager.h
//  MasterPass
//
//  Created by David Benko on 10/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APSDK/Product+Remote.h>
#import <APSDK/OrderHeader+Remote.h>

@interface MPECommerceManager : NSObject

+ (instancetype)sharedInstance;
- (void)getAllProducts:(void (^)(NSArray *products))callback;
- (void)getCurrentCart:(void (^)(OrderHeader *header, NSArray *cart))callback;
- (void)addProductToCart:(Product *)product;
@end
