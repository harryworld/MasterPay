//
//  CartManager.h
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APSDK/Product.h>

@interface CartManager : NSObject

@property(nonatomic, strong) NSMutableArray *products;

+ (CartManager *) getInstance;
- (void)cleanCart;
- (int)cartSize;
- (void)addProductToCart:(Product *)product;
- (NSArray *)expandedCart; //returns cart as multiple objects (dupes) with quant 1
- (double) subtotal;
- (double) tax;
- (double) shipping;
- (double) total;
@end
