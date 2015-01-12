//
//  CartProductCell.h
//  MasterPass
//
//  Created by David Benko on 5/13/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <APSDK/OrderDetail.h>

@interface CartProductCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *productImage;
@property (nonatomic, weak) IBOutlet UILabel *productName;
@property (nonatomic, weak) IBOutlet UILabel *productPrice;
@property (nonatomic, weak) IBOutlet UILabel *productQuant;
@property (nonatomic, strong) OrderDetail *product;

-(void)setProduct:(OrderDetail *)product;
-(void)refreshProductInfo;
@end
