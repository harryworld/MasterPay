//
//  MPLearnMoreCell.m
//  MasterPass
//
//  Created by David Benko on 5/21/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "MPLearnMoreCell.h"

@implementation MPLearnMoreCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor superGreyColor];
        
        //Learn More Button
        self.learnMoreButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.learnMoreButton setTitle:@"Learn More" forState:UIControlStateNormal];
        [self.learnMoreButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.learnMoreButton setTitleColor:[UIColor steelColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.learnMoreButton];
        [self.learnMoreButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.width.equalTo(@225);
            make.top.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.learnMoreButton bk_addEventHandler:^(id sender) {
            [self learnMore];
        } forControlEvents:UIControlEventTouchUpInside];
        
    };
    return self;
}
-(void)learnMore{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"mp_learn_more" object:nil];
}
@end
