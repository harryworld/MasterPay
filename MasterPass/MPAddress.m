//
//  MPAddress.m
//  MasterPass
//
//  Created by David Benko on 11/21/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "MPAddress.h"

@implementation MPAddress

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self->_addressId = dictionary[@"address_id"];
        self->_city = dictionary[@"city"];
        self->_country = dictionary[@"country"];
        self->_countrySubdivision = dictionary[@"country_subdivision"];
        self->_lineOne = dictionary[@"line1"];
        self->_lineTwo = dictionary[@"line2"];
        self->_lineThree = dictionary[@"line3"];
        self->_postalCode = dictionary[@"postal_code"];
        self->_recipientName = dictionary[@"recipient_name"];
        self->_recipientPhoneNumber = dictionary[@"recipient_phone_number"];
        self->_selectedAsDefault = dictionary[@"selected_as_default"];
        self->_shippingAlias = dictionary[@"shipping_alias"];
    }
    return self;
}
@end
