//
//  Product.h
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject <NSCopying>
@property(nonatomic, assign) int productId;
@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSString * imageUrl;
@property(nonatomic, strong) NSNumber * price;
@property(nonatomic, strong) NSString * desc;
@property(nonatomic, assign) int quantity;

@end
