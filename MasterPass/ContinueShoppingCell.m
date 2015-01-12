//
//  ContinueShoppingCell.m
//  MasterPass
//
//  Created by David Benko on 5/19/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "ContinueShoppingCell.h"

@implementation ContinueShoppingCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor superGreyColor];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
        
        self.continueShoppingButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.continueShoppingButton setTitle:@"CONTINUE SHOPPING" forState:UIControlStateNormal];
        [self.continueShoppingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.continueShoppingButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.continueShoppingButton setBackgroundColor:[UIColor fireOrangeColor]];
        [self.contentView addSubview:self.continueShoppingButton];
        [self.continueShoppingButton makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(padding);
            make.center.equalTo(self.contentView);
        }];
        
    };
    return self;
}
@end
