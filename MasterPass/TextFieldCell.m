//
//  TextFieldCell.m
//  MasterPass
//
//  Created by David Benko on 5/16/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
        
        self.contentView.backgroundColor = [UIColor superLightGreyColor];
        self.textLabel.textColor = [UIColor steelColor];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectZero];
        self.textField.textColor = [UIColor steelColor];
        self.textField.font = [UIFont systemFontOfSize:13];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textField];
        [self.textField makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.contentView);
            make.width.equalTo(@250);
            make.right.equalTo(self.contentView).with.offset(-padding.right);
            make.centerY.equalTo(self.contentView);
        }];
    };
    return self;
}
@end
