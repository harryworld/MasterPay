//
//  MPCreditCard.m
//  MasterPass
//
//  Created by David Benko on 11/19/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "MPCreditCard.h"

@implementation MPCreditCard

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self->_brandId = dictionary[@"brand_id"];
        self->_brandName = dictionary[@"brand_name"];
        self->_cardAlias = dictionary[@"card_alias"];
        self->_cardHolderName = dictionary[@"card_holder_name"];
        self->_cardId = dictionary[@"card_id"];
        self->_expiryMonth = dictionary[@"expiry_month"];
        self->_expiryYear = dictionary[@"expiry_year"];
        self->_lastFour = dictionary[@"last_four"];
        self->_selectedAsDefault = dictionary[@"selected_as_default"];
    }
    return self;
}

@end
