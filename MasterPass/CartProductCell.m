//
//  CartProductCell.m
//  MasterPass
//
//  Created by David Benko on 5/13/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "CartProductCell.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "OrderDetail+NormalizedPrice.h"

@implementation CartProductCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor deepBlueColor];
    
    [self.productName setTextColor:[UIColor whiteColor]];
    [self.productQuant setTextColor:[UIColor whiteColor]];
    [self.productQuant setFont:[UIFont systemFontOfSize:13]];
    
    [self.productPrice setTextColor:[UIColor fireOrangeColor]];
    [self.productPrice setFont:[UIFont boldSystemFontOfSize:13]];
    
    [self.productImage.layer setBorderWidth:2];
    [self.productImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.productImage.layer setCornerRadius:4.];
    
    [self.layer setShouldRasterize:YES];
    [self.layer setRasterizationScale: [UIScreen mainScreen].scale];
}

-(void)setProduct:(OrderDetail *)product{
    _product = product;
    [self refreshProductInfo];
}

-(void)refreshProductInfo{
    self.productName.text = self.product.productName;
    self.productPrice.text = [self formatCurrency:[self.product normalizedPrice]];
    [self.productImage setImageWithURL:[NSURL URLWithString:self.product.productImageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //TODO Fix
    self.productQuant.text = [NSString stringWithFormat:@"Quantity: %d",[self.product.quantity intValue]];
}
-(NSString *)formatCurrency:(NSNumber *)price{
    double currency = [price doubleValue];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:currency]];
    return numberAsString;
}
@end
