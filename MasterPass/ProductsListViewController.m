//
//  ProductsListViewController.m
//  MasterPass
//
//  Created by David Benko on 4/27/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "ProductsListViewController.h"
#import "Product.h"
#import "CartViewController.h"
#import "CartManager.h"
#import "ProductPreviewCell.h"

@interface ProductsListViewController ()
@property (nonatomic, strong) NSMutableArray *productsData;
@property (nonatomic, strong) NSMutableArray *col1Data;
@property (nonatomic, strong) NSMutableArray *col2Data;
@property (nonatomic, weak) IBOutlet UISegmentedControl *productFilter;
@property(nonatomic, weak) IBOutlet KLScrollSelect *productScrollSelect;
@end

@implementation ProductsListViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    // Nav Bar Logo
    UIImage* logoImage = [UIImage imageNamed:@"logo.png"];
    CGSize orig = logoImage.size;
    CGRect frame = CGRectMake(0, 0, 100, orig.height / 1.5);
    UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
    [iv setImage:logoImage];
    self.navigationItem.titleView = iv;
    
    [self refreshCartBadge];
    
    self.productsData = [[NSMutableArray alloc]init];
    self.productScrollSelect.backgroundColor = [UIColor colorWithRed:201./255. green:203./255. blue:214./255. alpha:1.];
    [self.productScrollSelect setAutoScrollEnabled:NO];
    
    [self.productFilter bk_addEventHandler:^(UISegmentedControl * sender) {
        NSInteger index = [sender selectedSegmentIndex];
        
        switch (index) {
            case 0:
                self.productsData = [self fullInventory];
                break;
            case 1:
                self.productsData = [NSMutableArray arrayWithArray:[self filterInventory:[self fullInventory] byLowPrice:0 andHighPrice:50]];
                break;
            case 2:
                self.productsData = [NSMutableArray arrayWithArray:[self filterInventory:[self fullInventory] byLowPrice:50 andHighPrice:100]];
                break;
            case 3:
                self.productsData = [NSMutableArray arrayWithArray:[self filterInventory:[self fullInventory] byLowPrice:100 andHighPrice:99999999999]];
                break;
            default:
                break;
        }
        
        self.productScrollSelect.delegate = self;
        self.productScrollSelect.dataSource = self;
    } forControlEvents:UIControlEventValueChanged];
    
    
    self.productsData = [self fullInventory];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshCartBadge];
}

-(NSMutableArray *)fullInventory{
    
    NSMutableArray *products = [[NSMutableArray alloc]init];
    
    NSDictionary *inventory = @{
                                @"iPad" : @{
                                        @"price":@482.00,
                                        @"imageUrl":@"http://cdn.imore.com/sites/imore.com/files/field/image/2012/11/ipad_mini_hero_black.jpg",
                                        @"desc":@"iPad Air and iPad mini with Retina display available now. Ships free."
                                        },
                                @"Lenovo IdeaPad Flex": @{
                                        @"price":@489.99,
                                        @"imageUrl":@"http://www.lenovo.com/shop/WW/products/splitter/notebooks/ideapad/Y-Series/gallery/IdeaPad-Y500-Laptop-PC-Closeup-Removeable-Drive-9L-940x475.jpg",
                                        @"desc":@"Save up to 40% on IdeaPad Laptops w/ Intel® Core™"
                                        },
                                @"Samsung Galaxy Tab" : @{
                                        @"price":@199.99,
                                        @"imageUrl":@"http://yujinishuge.files.wordpress.com/2010/11/samsung-galaxy-tab-city1.jpg",
                                        @"desc":@"Meet the Samsung Galaxy Tab family including Galaxy Tab 10.1, 8.9 and 7.0 Plus. Sort by size or carrier and find the Samsung Tab Android tablet that's right for you."
                                        },
                                @"Kindle Fire HDX" : @{
                                        @"price":@199.99,
                                        @"imageUrl":@"http://blog.proporta.com/wp-content/uploads/2012/09/kindle-fire1.jpg",
                                        @"desc":@"Perfect-color HDX display, plus powerful quad-core processor for fast, fluid performance and immersive entertainment."
                                        },
                                @"Samsung Gear 2" : @{
                                        @"price":@299.99,
                                        @"imageUrl":@"http://pocketnow.com/wp-content/uploads/2014/03/gear-2-bike.jpg",
                                        @"desc":@"Match the Samsung Gear 2 with your style and mood with more color options to show off your individuality! * Additional straps sold separately."
                                        },
                                @"Canon EOS Rebel T3i" : @{
                                        @"price":@549.00,
                                        @"imageUrl":@"http://i.ytimg.com/vi/3h444PODt2A/0.jpg",
                                        @"desc":@"Photographers looking for an easy-to-use camera that will help them create their next masterpiece need look no further than the Canon EOS Rebel T3i."
                                        },
                                @"HP Chromebook 11" : @{
                                        @"price":@279.99,
                                        @"imageUrl":@"http://www.digitaltrends.com/wp-content/uploads/2013/10/hp-chromebook-11-thumb.jpg",
                                        @"desc":@"Free Shipping On The HP Chromebook. No Wi-Fi Around? No Problem Free 4G"
                                        },
                                @"Apple iPod touch" : @{
                                        @"price":@220.30,
                                        @"imageUrl":@"https://www.apple.com/ipod-touch/features/images/display_hero.jpg",
                                        @"desc":@"iPod touch is ultrathin and colorful, plays music and video, rules games, runs apps, makes video calls, takes amazing photos, and shoots HD video."
                                        },
                                @"PlayStation 4 Console" : @{
                                        @"price":@399.00,
                                        @"imageUrl":@"http://www.digitaltrends.com/wp-content/uploads/2013/10/Sony-Playstation-4-disc.jpg",
                                        @"desc":@"New! PlayStation 4. Free Shipping, Shop & Save Today."
                                        },
                                @"Nokia Lumia 520" : @{
                                        @"price":@65.60,
                                        @"imageUrl":@"http://www.pcpro.co.uk/blogs/wp-content/uploads/2013/02/Nokia-Lumia-520-1-2.jpg",
                                        @"desc":@"Nokia Lumia 520 comes with exclusive digital lenses, a super-sensitive touchscreen, and a 1GHz dual core processor."
                                        },
                                @"Samsung Galaxy S4" : @{
                                        @"price":@49.99,
                                        @"imageUrl":@"http://www.digitaltrends.com/wp-content/uploads/2013/04/samsung-galaxy-s4-polycarbonate-body-macro1.jpg",
                                        @"desc":@"Make your life richer, simpler, and more fun. As a real life companion, the new Samsung GALAXY S4 helps bring us closer and captures those fun moments ..."
                                        },
                                @"Beats by Dre" : @{
                                        @"price":@299.95,
                                        @"imageUrl":@"http://25.media.tumblr.com/tumblr_m9y5jp3Svf1r5eau1o1_500.jpg",
                                        @"desc":@"Browse headphones, earbuds, and other audio devices made with Beats by Dre audio technology and start listening to music the way the artist intended."
                                        },
                                @"LG 84\" 4K Cinema 3D Smart LED TV" : @{
                                        @"price":@16999.00,
                                        @"imageUrl":@"http://www.paulstv.com/images/paulscreative/productdescriptionimages/00_feature_LivRoom.jpg",
                                        @"desc":@"Higher than Full HD with LG UHD 4K!"
                                        },
                                @"Pebble Smartwatch" : @{
                                        @"price":@149.00,
                                        @"imageUrl":@"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRwe1MUKGewYBIjk-lPsQ4v5NVS-jDNH6ZlQZNijYTj1acLM5-d",
                                        @"desc":@"Discover thousands of apps and watchfaces to customize Pebble to fit your life."
                                        }
                                };
    
    
    [inventory each:^(NSString * name, NSDictionary * attrs){
        Product *product = [Product new];
        product.name = name;
        product.price = [attrs objectForKey:@"price"];
        product.imageUrl = [attrs objectForKey:@"imageUrl"];
        product.desc = [attrs objectForKey:@"desc"];
        [products addObject:product];
    }];
    
    return products;
}

-(NSArray *)filterInventory:(NSArray *)inventory byLowPrice:(double)lowPrice andHighPrice:(double)highPrice{
    return [inventory select:^BOOL(Product * object) {
        return ([object.price doubleValue] >= lowPrice && [object.price doubleValue] <= highPrice);
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
        return [[ProductPreviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];;
    }
    
    KLScrollingColumn* column = [[scrollSelect columns] objectAtIndex: indexPath.column];
    ProductPreviewCell * cell;
    
    //registerClass only works on iOS 6 so if the app runs on iOS 5 we shouldn't use this method.
    //On iOS 5 we only initialize a new KLImageCell if the cell is nil
    if ([column respondsToSelector:@selector(registerClass:)]) {
        [column registerClass:[ProductPreviewCell class] forCellReuseIdentifier:identifier];
        cell = [column dequeueReusableCellWithIdentifier:identifier forIndexPath:[indexPath innerIndexPath]];
    } else {
        cell = [column dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ProductPreviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Set Cell Product - all setup is done in cell class
    Product *product = (Product*)[self.productsData objectAtIndex:indexPath.row];
    cell.product = product;
    
    [cell.addToCartButton bk_addEventHandler:^(id sender) {
        [self initiateAddProduct:[self.productsData objectAtIndex:indexPath.row] ToCart:sender];
    } forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (NSInteger)numberOfColumnsInScrollSelect:(KLScrollSelectViewController *)scrollSelect{
    return 2;
}

- (void)scrollSelect:(KLScrollSelect *)tableView didSelectCellAtIndexPath:(KLIndexPath *)indexPath{

}
#pragma mark - animation

- (IBAction) initiateAddProduct:(Product*)product ToCart:(UIView *)sender{
    
    CartManager *manager = [CartManager getInstance];
    [manager.products addObject:product];
    [self animateViewToCart:sender];
}

-(void)animateViewToCart:(UIView *)sender{
    [(UIButton *)sender setTitle:@"!" forState:UIControlStateNormal];
    
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
    UIView *view = [item valueForKey:@"view"];
    
    unless(view) {
        return;
    }
    
    [sender removeFromSuperview];
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:sender];
    
    CALayer *layer = sender.layer;
    
    // First let's remove any existing animations
    [layer pop_removeAllAnimations];
    
    POPSpringAnimation  *sizeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeAnim.toValue = [NSValue valueWithCGSize:CGSizeMake(40, 40)];
    
    POPSpringAnimation *rotationAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnim.toValue = @(M_PI_4);
    
    POPSpringAnimation *positionAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnim.toValue = [NSValue valueWithCGPoint:view.frame.origin];
    
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
        [sender removeFromSuperview];
    };
    
    [layer pop_addAnimation:sizeAnim forKey:@"size"];
    [layer pop_addAnimation:positionAnim forKey:@"position"];
    [layer pop_addAnimation:rotationAnim forKey:@"rotation"];
    [sender pop_addAnimation:alphaAnim forKey:@"fade"];
}

-(void)refreshCartBadge{
    
    NSString *buttonTitle = [NSString stringWithFormat:@"Cart (%lu)",(unsigned long)[CartManager getInstance].products.count];
    
    CGRect frame = CGRectMake(10, 6, 60, 30);
    UIButton *customButton = [[UIButton alloc] initWithFrame:frame];
    [customButton setTitle:buttonTitle forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(goToCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

-(void)goToCart{
    [self performSegueWithIdentifier:@"CartSegue" sender:nil];
}

@end
