//
//  MPConnectCell.m
//  MasterPass
//
//  Created by David Benko on 5/16/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "MPConnectCell.h"

@implementation MPConnectCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor superGreyColor];
        
        //Learn More Button
        self.learnMoreButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.learnMoreButton setTitle:@"Learn More about MasterPass" forState:UIControlStateNormal];
        [self.learnMoreButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.learnMoreButton setTitleColor:[UIColor steelColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.learnMoreButton];
        [self.learnMoreButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.width.equalTo(@225);
            make.bottom.equalTo(self.contentView).with.offset(5);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.learnMoreButton bk_addEventHandler:^(id sender) {
            [self learnMore];
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        // MasterPass Button
        self.masterPassButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.masterPassButton setTitle:@"" forState:UIControlStateNormal];
        [self.masterPassButton setBackgroundImage:[UIImage imageNamed:@"connect_with_masterpass.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.masterPassButton];
        [self.masterPassButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@58);
            make.width.equalTo(@249);
            make.center.equalTo(self.contentView);
        }];
        
        [self.masterPassButton bk_addEventHandler:^(id sender) {
            [self processOrder:sender];
        } forControlEvents:UIControlEventTouchUpInside];
        
    };
    return self;
}

-(void)processOrder:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"mp_connect" object:nil];
}

-(void)learnMore{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"mp_learn_more" object:nil];
}
@end
