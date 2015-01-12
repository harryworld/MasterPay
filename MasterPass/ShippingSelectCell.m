//
//  ShippingSelectCell.m
//  MasterPass
//
//  Created by David Benko on 12/10/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "ShippingSelectCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShippingSelectCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor superLightGreyColor];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 70);
        
        [self.textView removeFromSuperview];
        self.textView = nil;
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectZero];
        self.textView.selectable = NO;
        self.textView.editable = NO;
        self.textView.backgroundColor = [UIColor superLightGreyColor];
        [self.contentView addSubview:self.textView];
        
        [self.textView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(padding);
            make.center.equalTo(self.contentView);
        }];
        
        
        self.selectShippingButton = [[UIButton alloc]initWithFrame:CGRectZero];
        self.selectShippingButton.titleLabel.textColor = [UIColor whiteColor];
        self.selectShippingButton.backgroundColor = [UIColor fireOrangeColor];
        self.selectShippingButton.layer.cornerRadius = 5;
        [self.selectShippingButton setTitle:@"Select" forState:UIControlStateNormal];
        self.selectShippingButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.selectShippingButton];
        [self.selectShippingButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
            make.width.equalTo(@50);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
        
        
        self.textView.textAlignment = NSTextAlignmentLeft;
        self.textView.font = [UIFont systemFontOfSize:14];
        [self.textView setUserInteractionEnabled:NO];
        self.textView.textColor = [UIColor steelColor];
        self.textView.scrollEnabled = NO;
    };
    return self;
}
@end
