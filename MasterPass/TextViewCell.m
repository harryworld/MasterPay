//
//  TextViewCell.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "TextViewCell.h"

@implementation TextViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
        
        self.contentView.backgroundColor = [UIColor superGreyColor];
        self.textView = [[UITextView alloc]initWithFrame:CGRectZero];
        self.textView.textColor = [UIColor deepBlueColor];
        self.textView.backgroundColor = [UIColor superGreyColor];
        self.textView.selectable = NO;
        self.textView.editable = NO;
        [self.contentView addSubview:self.textView];
        
        [self.textView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(padding);
            make.center.equalTo(self.contentView);
        }];
    };
    return self;
}
@end
