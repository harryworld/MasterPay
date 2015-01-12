//
//  MPLinkedCell.m
//  MasterPass
//
//  Created by David Benko on 5/21/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "MPLinkedCell.h"

@implementation MPLinkedCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor brightBlueColor];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(5, 30, 5, 30);
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectZero];
        textView.text = @"Your account is now paired with your MasterPass wallet.";
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor brightBlueColor];
        textView.editable = NO;
        textView.selectable = NO;
        textView.scrollEnabled = NO;
        textView.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:textView];
        [textView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(padding);
            make.center.equalTo(self.contentView);
        }];
        
    };
    return self;
}
@end
