//
//  MPCreditCard.h
//  MasterPass
//
//  Created by David Benko on 11/19/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCreditCard : NSObject

@property (nonatomic, strong, readonly) NSString *brandId;
@property (nonatomic, strong, readonly) NSString *brandName;
@property (nonatomic, strong, readonly) NSString *cardAlias;
@property (nonatomic, strong, readonly) NSString *cardHolderName;
@property (nonatomic, strong, readonly) NSNumber *cardId;
@property (nonatomic, strong, readonly) NSNumber *expiryMonth;
@property (nonatomic, strong, readonly) NSNumber *expiryYear;
@property (nonatomic, strong, readonly) NSNumber *lastFour;
@property (nonatomic, strong, readonly) NSNumber *selectedAsDefault;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
