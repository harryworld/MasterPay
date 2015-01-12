//
//  SubtotalTitleItemCell.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "SubtotalTitleItemCell.h"

@implementation SubtotalTitleItemCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor blackColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
    };
    return self;
}
@end
