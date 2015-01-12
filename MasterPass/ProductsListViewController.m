//
//  ProductsListViewController.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "ProductsListViewController.h"
#import <APSDK/Product.h>
#import "CartViewController.h"
#import "ProductPreviewCell.h"
#import "BBBadgeBarButtonItem.h"
#import "MPECommerceManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Product+NormalizedPrice.h"

@interface ProductsListViewController ()
@property (nonatomic, strong) NSArray *productsData;
@property (nonatomic, strong) NSArray *fullProductsData;
@property (nonatomic, strong) NSMutableArray *col1Data;
@property (nonatomic, strong) NSMutableArray *col2Data;
@property (nonatomic, weak) IBOutlet UISegmentedControl *productFilter;
@property(nonatomic, weak) IBOutlet KLScrollSelect *productScrollSelect;
@end

@implementation ProductsListViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    // Nav Bar Logo
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    UIImage* logoImage = [UIImage imageNamed:@"logo.png"];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [iv setImage:logoImage];
    [header addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@140);
        make.center.equalTo(header);
    }];
    self.navigationItem.titleView = header;
        
    self.productsData = [[NSMutableArray alloc]init];
    self.productScrollSelect.backgroundColor = [UIColor colorWithRed:201./255. green:203./255. blue:214./255. alpha:1.];
    [self.productScrollSelect setAutoScrollEnabled:NO];
    self.productScrollSelect.delegate = self;
    self.productScrollSelect.dataSource = self;
    
    [self.productFilter bk_addEventHandler:^(UISegmentedControl * sender) {
        
        NSInteger index = [sender selectedSegmentIndex];
        
        switch (index) {
            case 0:
                self.productsData = self.fullProductsData;
                break;
            case 1:
                self.productsData = [self filterInventory:self.fullProductsData byLowPrice:0 andHighPrice:50];
                break;
            case 2:
                self.productsData = [self filterInventory:self.fullProductsData byLowPrice:50 andHighPrice:100];
                break;
            case 3:
                self.productsData = [self filterInventory:self.fullProductsData byLowPrice:100 andHighPrice:99999999999];
                break;
            default:
                break;
        }
        //[self.productScrollSelect reloadData];
    } forControlEvents:UIControlEventValueChanged];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self fullInventory:^(NSArray *products) {
        self.productsData = [NSArray arrayWithArray:products];
        self.fullProductsData = [NSArray arrayWithArray:products];
        [self.productScrollSelect reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshCartBadge];    
}

-(void)fullInventory:(void (^)(NSArray *products))callback{
    MPECommerceManager *manager = [MPECommerceManager sharedInstance];
    [manager getAllProducts:callback];
}

-(NSArray *)filterInventory:(NSArray *)inventory byLowPrice:(double)lowPrice andHighPrice:(double)highPrice{
    return [inventory select:^BOOL(Product * object) {
        return ([[object normalizedPrice] doubleValue] >= lowPrice && [[object normalizedPrice] doubleValue] <= highPrice);
    }];
}


#pragma mark - KLScrollSelect Delegate

- (CGFloat)scrollRateForColumnAtIndex: (NSInteger) index {
    return 15 + index * 15;
}
- (NSInteger)scrollSelect:(KLScrollSelect *)scrollSelect numberOfRowsInColumnAtIndex:(NSInteger)index{
    return [self.productsData count];
}
- (CGFloat) scrollSelect: (KLScrollSelect*) scrollSelect heightForColumnAtIndex: (NSInteger) index{
    return 250;
}
- (UITableViewCell*) scrollSelect:(KLScrollSelect*)scrollSelect cellForRowAtIndexPath:(KLIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    if ([[scrollSelect columns] count] < indexPath.column || indexPath.column == -1) {
        return [[ProductPreviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    KLScrollingColumn* column = [[scrollSelect columns] objectAtIndex: indexPath.column];
    ProductPreviewCell * cell;
        
    //registerClass only works on iOS 6 so if the app runs on iOS 5 we shouldn't use this method.
    //On iOS 5 we only initialize a new KLImageCell if the cell is nil
    if ([column respondsToSelector:@selector(registerClass:)]) {
        [column registerClass:[ProductPreviewCell class] forCellReuseIdentifier:identifier];
        cell = [column dequeueReusableCellWithIdentifier:identifier forIndexPath:[indexPath innerIndexPath]];
        if (cell == nil) {
            cell = [[ProductPreviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
    } else {
        cell = [column dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ProductPreviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Set Cell Product - all setup is done in cell class
    Product *product = (Product*)[self.productsData objectAtIndex:indexPath.row];
    cell.product = product;
    
    [cell.addToCartButton bk_addEventHandler:^(id sender) {
        [self initiateAddProduct:[self.productsData objectAtIndex:indexPath.row] toCart:sender fromCell:cell];
    } forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (NSInteger)numberOfColumnsInScrollSelect:(KLScrollSelectViewController *)scrollSelect{
    return 2;
}

- (void)scrollSelect:(KLScrollSelect *)tableView didSelectCellAtIndexPath:(KLIndexPath *)indexPath{

}
#pragma mark - animation
- (IBAction) initiateAddProduct:(Product*)product toCart:(UIView *)sender fromCell:(UITableViewCell *)cell{
    MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ecommerce addProductToCart:product callback:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self animateViewToCart:sender fromParent:cell];
    }];
}

-(void)animateViewToCart:(UIView *)sender fromParent:(UITableViewCell *)parent{
    [(UIButton *)sender setTitle:@"!" forState:UIControlStateNormal];
    
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
    UIView *view = [item valueForKey:@"view"];
    
    unless(view) {
        return;
    }
    
    UIGraphicsBeginImageContext(sender.bounds.size);
    [sender.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [(UIButton *)sender setTitle:@"+ ADD" forState:UIControlStateNormal];
    CGRect destinationFrame = [parent.contentView convertRect:sender.frame toView:nil];
    UIImageView *animationImageView = [[UIImageView alloc]initWithFrame:destinationFrame];
    animationImageView.image = buttonImage;
    
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:animationImageView];
    CALayer *layer = animationImageView.layer;
    
    POPSpringAnimation  *sizeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(40, 40)];
    
    POPSpringAnimation *rotationAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnim.toValue = @(M_PI_4);
    
    POPSpringAnimation *positionAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnim.toValue = [NSValue valueWithCGPoint:view.frame.origin];
    positionAnim.fromValue = [NSValue valueWithCGPoint:destinationFrame.origin];
    
    sizeAnim.springBounciness = 20;
    sizeAnim.springSpeed = 16;
    
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaAnim.fromValue = @(1.0);
    alphaAnim.toValue = @(0.0);
    
    positionAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self refreshCartBadge];
    };
    
    alphaAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [animationImageView removeFromSuperview];
    };
    
    [layer pop_addAnimation:sizeAnim forKey:@"size"];
    [layer pop_addAnimation:positionAnim forKey:@"position"];
    [layer pop_addAnimation:rotationAnim forKey:@"rotation"];
    [animationImageView pop_addAnimation:alphaAnim forKey:@"fade"];
}

-(void)refreshCartBadge{
    
    FAKFontAwesome *cartIcon = [FAKFontAwesome shoppingCartIconWithSize:20];
    [cartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *rightImage = [cartIcon imageWithSize:CGSizeMake(20, 20)];
    cartIcon.iconFontSize = 15;
    
    UIButton *customButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [customButton addTarget:self action:@selector(goToCart) forControlEvents:UIControlEventTouchUpInside];
    [customButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *rightBarButton = [[BBBadgeBarButtonItem alloc]initWithCustomUIButton:customButton];
    rightBarButton.shouldAnimateBadge = YES;
    rightBarButton.shouldHideBadgeAtZero = YES;
    rightBarButton.badgePadding = 2.5;
    rightBarButton.badgeFont = [UIFont boldSystemFontOfSize:11];
    
    MPECommerceManager *ecommerce = [MPECommerceManager sharedInstance];
    [ecommerce getCartQuantityCallback:^(NSNumber *quantity) {
        rightBarButton.badgeValue = [NSString stringWithFormat:@"%d",[quantity intValue]];
        [self.navigationItem setRightBarButtonItem:rightBarButton];
    }];
}

-(void)goToCart{
    [self performSegueWithIdentifier:@"CartSegue" sender:nil];
}

@end
