//
//  OrderConfirmationCell.m
//  MasterPass
//
//  Created by David Benko on 5/19/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "OrderConfirmationCell.h"

@implementation OrderConfirmationCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *recieptLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [recieptLabel setTextColor:[UIColor deepBlueColor]];
        recieptLabel.text = @"Receipt";
        [recieptLabel setFont:[UIFont systemFontOfSize:25]];
        [self.contentView addSubview:recieptLabel];
        [recieptLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@200);
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(10);
        }];
        
        UILabel *chargedLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [chargedLabel setTextColor:[UIColor deepBlueColor]];
        chargedLabel.text = @"You have been charged";
        [self.contentView addSubview:chargedLabel];
        [chargedLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@200);
            make.right.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(recieptLabel).with.offset(40);
        }];
        
        UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [totalLabel setTextColor:[UIColor deepBlueColor]];
        totalLabel.text = @"Total";
        [self.contentView addSubview:totalLabel];
        [totalLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@200);
            make.left.equalTo(chargedLabel);
            make.top.equalTo(chargedLabel).with.offset(40);
        }];
        
        self.totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.totalPriceLabel setTextColor:[UIColor deepBlueColor]];
        [self.totalPriceLabel setTextColor:[UIColor fireOrangeColor]];
        [self.totalPriceLabel setFont:[UIFont boldSystemFontOfSize:25]];
        [self.contentView addSubview:self.totalPriceLabel];
        [self.totalPriceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@140);
            make.right.equalTo(self.contentView);
            make.top.equalTo(chargedLabel).with.offset(40);
        }];
        
    };
    return self;
}

@end
