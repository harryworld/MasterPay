//
//  CardManager.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "CardManager.h"
#import "Card.h"

@implementation CardManager
static CardManager *sharedInstance;

+ (void)initialize
{
    static BOOL initialized = NO;
    unless(initialized)
    {
        initialized = YES;
        sharedInstance = [[CardManager alloc] init];
        sharedInstance.isLinkedToMasterPass = YES;
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
    cardOne.street = @"1453 Main Street";
    cardOne.city = @"Reston";
    cardOne.state = @"VA";
    cardOne.zip = @"20191";
    
    Card *cardTwo = [Card new];
    cardTwo.lastFour = @"9023";
    cardTwo.imageUrl = @"http://blogs.houstonpress.com/hairballs/Chase-Bank-Logo-Clean.jpeg";
    cardTwo.iconName = @"black_cc.png";
    cardTwo.isMasterPass = @1;
    cardTwo.expDate = @"08/15";
    cardTwo.street = @"83928 Runway Lane";
    cardTwo.city = @"San Francisco";
    cardTwo.state = @"CA";
    cardTwo.zip = @"94117";
    
    return @[cardOne,cardTwo];
}

- (UIImage *)cardBackgroundImage{
    return [UIImage new];
}
@end
