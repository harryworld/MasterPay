//
//  CardManager.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "CardManager.h"
#import "Card.h"
#import "ShippingInfo.h"

@implementation CardManager
static CardManager *sharedInstance;

+ (void)initialize
{
    static BOOL initialized = NO;
    unless(initialized)
    {
        initialized = YES;
        sharedInstance = [[CardManager alloc] init];
        sharedInstance.isLinkedToMasterPass = NO;
        sharedInstance.isExpressEnabled = NO;
    }
}

+ (CardManager *) getInstance{
    return sharedInstance;
}

-(NSArray *)cards{
    Card *cardOne = [Card new];
    cardOne.lastFour = @"8733";
    cardOne.imageUrl = @"http://dev.starteconome.com/images/wells.jpg";
    cardOne.iconName = @"blue_cc.png";
    cardOne.isMasterPass = @1;
    cardOne.expDate = @"03/17";
    
    Card *cardTwo = [Card new];
    cardTwo.lastFour = @"9023";
    cardTwo.imageUrl = @"http://blogs.houstonpress.com/hairballs/Chase-Bank-Logo-Clean.jpeg";
    cardTwo.iconName = @"black_cc.png";
    cardTwo.isMasterPass = @1;
    cardTwo.expDate = @"08/15";
    
    return @[cardOne,cardTwo];
}

-(NSArray *)shippingDetails{
    ShippingInfo *si1 = [ShippingInfo new];
    si1.street = @"1453 Main Street";
    si1.city = @"Reston";
    si1.state = @"VA";
    si1.zip = @"20191";
    
    ShippingInfo *si2 = [ShippingInfo new];
    si2.street = @"83928 Runway Lane";
    si2.city = @"San Francisco";
    si2.state = @"CA";
    si2.zip = @"94117";
    
    return @[si1,si2];
}

- (UIImage *)cardBackgroundImage{
    return [UIImage new];
}
@end
