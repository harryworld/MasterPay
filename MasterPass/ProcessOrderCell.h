//
//  ProcessOrderCell.h
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ProcessButtonType{
    kButtonTypeProcess,
    kButtonTypeMasterPass
} ProcessButtonType;

@interface ProcessOrderCell : UITableViewCell
@property (nonatomic, strong) UIButton *processButton;
@property (nonatomic, strong) UIButton *masterPassButton;

-(void)setButtonType:(ProcessButtonType)buttonType;
@end
