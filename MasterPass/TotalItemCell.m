//
//  TotalItemCell.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "TotalItemCell.h"

@implementation TotalItemCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor deepBlueColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
    };
    return self;
}
@end
