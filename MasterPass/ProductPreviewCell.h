//
//  ProductPreviewCell.h
//  MasterPass
//
//  Created by David Benko on 5/6/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <APSDK/Product.h>

#define kDefaultCellImageEdgeInset UIEdgeInsetsMake(5, 5, 5, 5)
@interface ProductPreviewCell : UITableViewCell
@property (nonatomic, strong) UIImageView* image;
@property (nonatomic, strong) UILabel* productTitle;
@property (nonatomic, strong) UILabel* productDesc;
@property (nonatomic, strong) UILabel* productPrice;
@property (nonatomic, strong) UILabel* productVendor;
@property (nonatomic, strong) UIButton *addToCartButton;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) Product *product;

-(void)setProduct:(Product *)product;
-(void)refreshProductInfo;

@end
