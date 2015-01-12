//
//  BoldTotalItemCell.m
//  MasterPass
//
//  Created by David Benko on 6/9/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "BoldTotalItemCell.h"

@implementation BoldTotalItemCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor deepBlueColor];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = [UIColor fireOrangeColor];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:22];
    };
    return self;
}
@end
