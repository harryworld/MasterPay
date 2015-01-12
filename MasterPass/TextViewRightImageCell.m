//
//  TextViewRightImageCell.m
//  MasterPass
//
//  Created by David Benko on 6/18/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "TextViewRightImageCell.h"

@implementation TextViewRightImageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
                
        self.contentView.backgroundColor = [UIColor superGreyColor];
        self.textView = [[UITextView alloc]initWithFrame:CGRectZero];
        self.textView.textColor = [UIColor deepBlueColor];
        self.textView.backgroundColor = [UIColor superGreyColor];
        self.textView.selectable = NO;
        self.textView.editable = NO;
        [self.contentView addSubview:self.textView];
        
        [self.textView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@110);
            make.height.equalTo(@30);
            make.left.equalTo(self.contentView).with.offset(70);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.rightImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.rightImage];
        [self.rightImage makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@35);
            make.width.equalTo(@55);
            make.left.equalTo(self.textView.right).with.offset(5);
            make.centerY.equalTo(self.contentView);
        }];
    };
    return self;
}
@end
