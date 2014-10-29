//
//  MPECommerceManager.h
//  MasterPass
//
//  Created by David Benko on 10/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APSDK/Product+Remote.h>

@interface MPECommerceManager : NSObject

- (void)getCurrentCart:(void (^)(NSArray *cart))callback;
- (void)addProductToCart:(Product *)product;
@end
