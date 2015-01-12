//
//  TableTitleCell.m
//  MasterPass
//
//  Created by David Benko on 6/9/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "TableTitleCell.h"

@implementation TableTitleCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor deepBlueColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        
        self.headline = [[UILabel alloc]initWithFrame:CGRectZero];
        self.headline.font = [UIFont boldSystemFontOfSize:24];
        self.headline.textColor = [UIColor whiteColor];
        self.headline.backgroundColor = [UIColor clearColor];
        self.headline.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.headline];
        [self.headline makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@200);
            make.center.equalTo(self.contentView);
        }];
        
        self.tagline = [[UILabel alloc]initWithFrame:CGRectZero];
        self.tagline.numberOfLines = 3;
        self.tagline.textAlignment = NSTextAlignmentCenter;
        self.tagline.font = [UIFont systemFontOfSize:14];
        self.tagline.textColor = [UIColor whiteColor];
        self.tagline.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.tagline];
        [self.tagline makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headline.bottom);
            make.left.equalTo(self.contentView).with.offset(30);
            make.right.equalTo(self.contentView).with.offset(-30);
            make.bottom.equalTo(self.contentView);
        }];
        
    };
    return self;
}
@end
