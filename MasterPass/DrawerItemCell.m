//
//  DrawerItemCell.m
//  MasterPass
//
//  Created by David Benko on 5/14/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "DrawerItemCell.h"

@implementation DrawerItemCell
- (void)awakeFromNib{
    [super awakeFromNib];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor deepBlueColor];
        CGFloat padding = 10;
        CGFloat imageSizeLength = 20;
        
        // Label
        self.itemLabel = [[UILabel alloc]initWithFrame:CGRectMake((padding *2) + imageSizeLength, padding, 100, 20)];
        self.itemLabel.textColor = [UIColor superGreyColor];
        [self.contentView addSubview:self.itemLabel];
        
        //Image
        
        self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(padding, padding, imageSizeLength, imageSizeLength)];
        [self.contentView addSubview:self.iconView];
        
    };
    return self;
}


@end
