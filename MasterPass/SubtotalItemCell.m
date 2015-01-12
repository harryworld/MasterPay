//
//  SubtotalItemCell.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "SubtotalItemCell.h"

@implementation SubtotalItemCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor blackColor];
        self.textLabel.textColor = [UIColor superGreyColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor superGreyColor];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
    };
    return self;
}
@end
