//
//  MPAddress.h
//  MasterPass
//
//  Created by David Benko on 11/21/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPAddress : NSObject

@property (nonatomic, strong, readonly) NSNumber *addressId;
@property (nonatomic, strong, readonly) NSString *city;
@property (nonatomic, strong, readonly) NSString *country;
@property (nonatomic, strong, readonly) NSString *countrySubdivision;
@property (nonatomic, strong, readonly) NSString *lineOne;
@property (nonatomic, strong, readonly) NSString *lineTwo;
@property (nonatomic, strong, readonly) NSString *lineThree;
@property (nonatomic, strong, readonly) NSString *postalCode;
@property (nonatomic, strong, readonly) NSString *recipientName;
@property (nonatomic, strong, readonly) NSString *recipientPhoneNumber;
@property (nonatomic, strong, readonly) NSNumber *selectedAsDefault;
@property (nonatomic, strong, readonly) NSString *shippingAlias;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
