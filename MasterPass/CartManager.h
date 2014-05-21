//
//  CartManager.h
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartManager : NSObject

@property(nonatomic, strong) NSMutableArray *products;

+ (CartManager *) getInstance;

-(double) subtotal;
-(double) tax;
-(double) shipping;
-(double) total;
@end
