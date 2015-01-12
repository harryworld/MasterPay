//
//  UIColor+ExtendedColors.m
//  MasterPass
//
//  Created by David Benko on 5/7/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "UIColor+ExtendedColors.h"

@implementation UIColor (ExtendedColors)
+(UIColor *)deepBlueColor{
    return [UIColor colorWithRed:39./255 green:41./255 blue:50./255 alpha:1];
}
+(UIColor *)brightBlueColor{
    return [UIColor colorWithRed:31./255 green:120./255 blue:213./255 alpha:1];
}
+(UIColor *)selectedDeepBlueColor{
    return [UIColor colorWithRed:29./255 green:30./255 blue:39./255 alpha:1];
}
+(UIColor *)fireOrangeColor{
    return [UIColor colorWithRed:218./255 green:69./255 blue:29./255 alpha:1];
}
+(UIColor *)brightOrangeColor{
    return [UIColor colorWithRed:246./255 green:152./255 blue:22./255 alpha:1];
}
+(UIColor *)superGreyColor{
    return [UIColor colorWithRed:201./255 green:203./255 blue:214./255 alpha:1];
}
+(UIColor *)superLightGreyColor{
    return [UIColor colorWithRed:213./255 green:216./255 blue:225./255 alpha:1];
}
+(UIColor *)steelColor{
    return [UIColor colorWithRed:90./255 green:92./255 blue:99./255 alpha:1];
}
+(UIColor *)cartSeperatorColor{
    return [UIColor colorWithRed:34./255 green:35./255 blue:40./255 alpha:1];
}
+(UIColor *)facebookBlue{
    return [UIColor colorWithRed:47./255 green:72./255 blue:133./255 alpha:1];
}
+(UIColor *)twitterBlue{
    return [UIColor colorWithRed:58./255 green:156./255 blue:230./255 alpha:1];
}
+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
@end
