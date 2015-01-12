//
//  ProcessOrderCell.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "ProcessOrderCell.h"

@interface ProcessOrderCell ()
@property (nonatomic, assign) ProcessButtonType buttonType;
@end

@implementation ProcessOrderCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor superGreyColor];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        // Process Button
        self.processButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.processButton setTitle:@"Process Order" forState:UIControlStateNormal];
        [self.processButton setBackgroundColor:[UIColor fireOrangeColor]];
        [self.processButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.processButton.layer setCornerRadius:4];
        self.processButton.hidden = YES;
        self.processButton.userInteractionEnabled = NO;
        [self.contentView addSubview:self.processButton];
        [self.processButton makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(insets);
            make.center.equalTo(self.contentView);
        }];
        
        // MasterPass Button
        self.masterPassButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.masterPassButton setTitle:@"" forState:UIControlStateNormal];
        [self.masterPassButton setBackgroundImage:[UIImage imageNamed:@"buy-with-masterpass.png"] forState:UIControlStateNormal];
        [self.masterPassButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        self.masterPassButton.hidden = YES;
        self.masterPassButton.userInteractionEnabled = NO;
        [self.contentView addSubview:self.masterPassButton];
        [self.masterPassButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@58);
            make.width.equalTo(@249);
            make.center.equalTo(self.contentView);
        }];
        
        [self.processButton bk_addEventHandler:^(id sender) {
            [self processOrder:sender];
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.masterPassButton bk_addEventHandler:^(id sender) {
            [self processOrder:sender];
        } forControlEvents:UIControlEventTouchUpInside];
        
    };
    return self;
}

-(void)setButtonType:(ProcessButtonType)buttonType{
    _buttonType = buttonType;
    if (self.buttonType == kButtonTypeProcess) {
        self.processButton.hidden = NO;
        self.processButton.userInteractionEnabled = YES;
        
        self.masterPassButton.hidden = YES;
        self.masterPassButton.userInteractionEnabled = NO;
    }
    else if(self.buttonType == kButtonTypeMasterPass){
        self.masterPassButton.hidden = NO;
        self.masterPassButton.userInteractionEnabled = YES;
        
        self.processButton.hidden = YES;
        self.processButton.userInteractionEnabled = NO;
    }
}

-(void)processOrder:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"order_processed"
                                                        object:nil
                                                      userInfo:@{@"isMasterPass": ((sender == self.masterPassButton) ? @1 : @0)}
     ];
}
@end
