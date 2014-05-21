//
//  CartProductCell.h
//  MasterPass
//
//  Created by David Benko on 5/13/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface CartProductCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *productImage;
@property (nonatomic, weak) IBOutlet UILabel *productName;
@property (nonatomic, weak) IBOutlet UILabel *productPrice;
@property (nonatomic, weak) IBOutlet UILabel *productQuant;
@property (nonatomic, strong) Product *product;

-(void)setProduct:(Product *)product;
-(void)refreshProductInfo;
@end
