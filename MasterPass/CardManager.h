//
//  CardManager.h
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardManager : NSObject

@property(nonatomic, assign) BOOL isLinkedToMasterPass;
@property(nonatomic, assign) BOOL isExpressEnabled;
@property(nonatomic, assign) BOOL wantsDelayedPair;

+ (CardManager *) getInstance;
- (NSArray *)cards;
- (NSArray *)shippingDetails;
- (UIImage *)cardBackgroundImage;
@end
