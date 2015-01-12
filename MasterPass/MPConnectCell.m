//
//  MPConnectCell.m
//  MasterPass
//
//  Created by David Benko on 5/16/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "MPConnectCell.h"

@implementation MPConnectCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor superGreyColor];
        
        // MasterPass Button
        self.masterPassButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.masterPassButton setTitle:@"" forState:UIControlStateNormal];
        [self.masterPassButton setBackgroundImage:[UIImage imageNamed:@"connect_with_masterpass.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.masterPassButton];
        [self.masterPassButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@58);
            make.width.equalTo(@249);
            make.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
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
@end
