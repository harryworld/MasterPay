//
//  ProductPreviewCell.m
//  MasterPass
//
//  Created by David Benko on 5/6/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "ProductPreviewCell.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "Product+NormalizedPrice.h"

@interface ProductPreviewCell ()
@end

@implementation ProductPreviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    };
    return self;
}

-(void) willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // On iOS 5 willMoveToSuperview method always gets called, so by checking existence of self.image ,
    // we prevent imageView initialization of reused cells otherwise we face with low performance while scrolling
    [self setup];
    [self refreshProductInfo];
    
}

-(void)setup{
    if(self.container){
        [self.container removeFromSuperview];
        self.container = nil;
    }
    
    
    self.backgroundColor = [UIColor clearColor];
    self.container = [[UIView alloc] initWithFrame: CGRectMake(kDefaultCellImageEdgeInset.left,
                                                               kDefaultCellImageEdgeInset.top,
                                                               self.frame.size.width - (kDefaultCellImageEdgeInset.left + kDefaultCellImageEdgeInset.right),
                                                               self.frame.size.height - (kDefaultCellImageEdgeInset.top + kDefaultCellImageEdgeInset.bottom))];
    
    [self.container.layer setCornerRadius:6.];
    self.container.backgroundColor = [UIColor whiteColor];
    
    
    self.image = [[UIImageView alloc] initWithFrame: CGRectMake(0,0,
                                                                self.container.bounds.size.width,
                                                                self.container.bounds.size.height / 2)];
    
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.image.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(6., 6.)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.image.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.image.layer.mask = maskLayer;
    
    [self.image setClipsToBounds:YES];
    
    [self addSubview:self.container];
    [self.container addSubview: self.image];
    
    CGFloat labelHeight = 20;
    CGFloat padding = 10;
    CGFloat smallPadding = 5;
    
    self.productTitle = [[UILabel alloc] initWithFrame: CGRectMake(self.container.frame.origin.x + smallPadding,
                                                                   (self.container.frame.size.height / 2) + padding,
                                                                   self.container.frame.size.width - (smallPadding * 2),
                                                                   labelHeight)];
    
    [self.productTitle setBackgroundColor:[UIColor clearColor]];
    [self.productTitle setTextColor:[UIColor blackColor]];
    [self.productTitle setTextAlignment:NSTextAlignmentLeft];
    [self.productTitle setFont:[UIFont boldSystemFontOfSize: 15]];
    self.productTitle.adjustsFontSizeToFitWidth = YES;
    [self.container addSubview:self.productTitle];
    
    self.productDesc = [[UILabel alloc] initWithFrame: CGRectMake(self.container.frame.origin.x + smallPadding,
                                                                  (self.container.frame.size.height / 2) + smallPadding + labelHeight,
                                                                  self.container.frame.size.width - (smallPadding * 2),
                                                                  labelHeight * 3)];
    
    [self.productDesc setBackgroundColor:[UIColor clearColor]];
    [self.productDesc setTextColor:[UIColor blackColor]];
    [self.productDesc setTextAlignment:NSTextAlignmentLeft];
    [self.productDesc setFont:[UIFont systemFontOfSize: 12]];
    self.productDesc.numberOfLines = 3;
    [self.container addSubview:self.productDesc];
    
    self.productPrice = [[UILabel alloc] initWithFrame: CGRectMake(self.container.frame.origin.x + smallPadding,
                                                                   self.container.frame.size.height - padding - labelHeight,
                                                                   self.container.frame.size.width / 2 - (padding * 2),
                                                                   labelHeight)];
    
    [self.productPrice setBackgroundColor:[UIColor clearColor]];
    [self.productPrice setTextColor:[UIColor colorWithRed:217./255. green:70./255. blue:29./255. alpha:1.]];
    [self.productPrice setTextAlignment:NSTextAlignmentLeft];
    [self.productPrice setFont:[UIFont boldSystemFontOfSize: 20]];
    self.productPrice.adjustsFontSizeToFitWidth = YES;
    [self.container addSubview:self.productPrice];
    
    [self.layer setShouldRasterize:YES];
    [self.layer setRasterizationScale: [UIScreen mainScreen].scale];
}

- (void)prepareForReuse{
    CGFloat padding = 10;
    CGFloat smallPadding = 5;
    
    if(self.addToCartButton){
        [self.addToCartButton removeFromSuperview];
        self.addToCartButton = nil;
    }
    
    self.addToCartButton = [[UIButton alloc]initWithFrame:CGRectMake(self.container.frame.size.width - padding - 75,
                                                                     self.container.frame.size.height - smallPadding - 30,
                                                                     75,
                                                                     30)];
    
    self.addToCartButton.backgroundColor = [UIColor colorWithRed:246./255. green:152./255. blue:22./255. alpha:1.];
    [self.addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addToCartButton setTitle:@"+ ADD" forState:UIControlStateNormal];
    [self.addToCartButton.titleLabel setFont:[UIFont boldSystemFontOfSize: 15]];
    [self.addToCartButton.layer setCornerRadius:10.];
    [self.container addSubview:self.addToCartButton];
    [self refreshProductInfo];
}

-(void)setProduct:(Product *)product{
    _product = product;
    [self refreshProductInfo];
}

-(void)refreshProductInfo{
    self.productTitle.text = _product.name;
    self.productPrice.text = [self formatCurrency:[_product normalizedPrice]];
    self.productDesc.text = _product.desc;
    [self.image setImageWithURL:[NSURL URLWithString:_product.imageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

-(NSString *)formatCurrency:(NSNumber *)price{
    double currency = [price doubleValue];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:0];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:currency]];
    return numberAsString;
}
@end
