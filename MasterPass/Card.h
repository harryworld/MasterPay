//
//  Card.h
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property(nonatomic, strong) NSString *lastFour;
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *iconName;
@property(nonatomic, strong) NSNumber *isMasterPass;
@property(nonatomic, strong) NSString *expDate;
@end
