//
//  CardSelectCell.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "CardSelectCell.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "MPManager.h"

@interface CardSelectCell ()
@property (nonatomic, strong) UIImageView *masterPassImage;
@property (nonatomic, strong) UIImageView *providerImage;
@property (nonatomic, strong) UILabel *cardNumber;
@property (nonatomic, strong) UILabel *expDate;
@property (nonatomic, weak) NSArray *cards;
@property (nonatomic, assign) BOOL manualEntryAllowed;
@property (nonatomic, strong) UIView *providerImageContainer;
@end

@implementation CardSelectCell

#pragma mark - View Setup

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor superGreyColor];
                
        self.cardSwipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        self.cardSwipeView.alignment = SwipeViewAlignmentCenter;
        self.cardSwipeView.dataSource = self;
        self.cardSwipeView.delegate = self;
        
        [self.contentView addSubview:self.cardSwipeView];
        
        [self.cardSwipeView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.center.equalTo(self.contentView);
        }];
        
        CGFloat padding = 5;
        
        UILabel *paymentMethodLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        paymentMethodLabel.text = @"Select Payment Method";
        paymentMethodLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:paymentMethodLabel];
        
        [paymentMethodLabel makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@250);
            make.height.equalTo(@25);
            make.top.equalTo(self.contentView).with.offset(padding);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
        }];

        
        [self refreshCurrentCardUI:self.cardSwipeView];
        
    };
    return self;
}

-(void)reloadMPImageUI{
    
    if (self.providerImageContainer) {
        
        [self.masterPassImage removeFromSuperview];
        self.masterPassImage = nil;
        
        [self.providerImage removeFromSuperview];
        self.providerImage = nil;
        
        [self.providerImageContainer removeFromSuperview];
        self.providerImageContainer = nil;
    }
    
    CGFloat bottomOffset = 5;
    
    self.providerImageContainer = [[UIView alloc]initWithFrame:CGRectZero];
    self.providerImageContainer.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.providerImageContainer];
    [self.providerImageContainer makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@35);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-bottomOffset);
    }];
    
    if (self.returnCheckout) {
        self.masterPassImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.masterPassImage.image = [UIImage imageNamed:@"masterpass-small-logo.png"];
        [self.providerImageContainer addSubview:self.masterPassImage];
        [self.masterPassImage makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@45);
            make.centerY.equalTo(self.providerImageContainer);
            make.left.equalTo(self.providerImageContainer).with.offset(bottomOffset);
        }];
        
        self.providerImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.providerImage.backgroundColor = [UIColor clearColor];
        [self.providerImageContainer addSubview:self.providerImage];
        [self.providerImage makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@80);
            make.centerY.equalTo(self.providerImageContainer);
            make.right.equalTo(self.providerImageContainer).with.offset(-bottomOffset);
        }];
    }
    else {
        self.masterPassImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.providerImageContainer addSubview:self.masterPassImage];
        [self.masterPassImage setImage:[UIImage imageNamed:@"masterpass-small-logo"]];
        [self.masterPassImage makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@45);
            make.center.equalTo(self.providerImageContainer);
        }];
    }
    
    MPCreditCard *currentCard = nil;
    MPManager *manager = [MPManager sharedInstance];
    
    if (self.cardSwipeView.currentPage < [self.cards count] && [manager isAppPaired]) {
        currentCard = [[self cards] objectAtIndex:self.cardSwipeView.currentPage];
    }
    
    if (!currentCard) {
        self.masterPassImage.hidden = YES;
        self.providerImage.hidden = YES;
    }
    
}

-(UIImage *)cardImageForCardType:(NSString *)cardType lastFour:(NSString *)lastFour{
    
    // We can't just do a random card because when the view
    // in the slider is recycled and/or reloaded we will
    // get a new image.
    
    // So we are going to use the last four as a 'seed' and
    // decide which image to use based on whether it is odd
    // or even. That way, we get the same image each time.
    
    NSArray *availableImages;
    int index = [lastFour intValue] % 2;
    
    if ([cardType isEqualToString:CardTypeAmex])  {
        availableImages = @[@"amex_black.png",@"amex_blue.png"];
    }
    else if ([cardType isEqualToString:CardTypeDiscover]){
        availableImages = @[@"discover_grey.png",@"discover_orange.png"];
    }
    else if ([cardType isEqualToString:CardTypeMasterCard]){
        availableImages = @[@"mastercard_blue.png",@"mastercard_green.png"];
    }
    else if([cardType isEqualToString:CardTypeVisa]){
        availableImages = @[@"visa_blue.png",@"visa_red.png"];
    }
    else if ([cardType isEqualToString:CardTypeMaestro]){
        availableImages = @[@"maestro_blue.png",@"maestro_yellow.png"];
    }
    else {
        // Some Generic Card
        index = [lastFour intValue] % 3; // three images
        availableImages = @[@"generic_card_blue.png",
                            @"generic_card_green.png",
                            @"generic_card_orange.png"];
    }
    
    return [UIImage imageNamed:availableImages[index]];
}

-(void)setMasterPassImage:(NSString *)mpImageUrl andBrandImage:(NSString *)brandImageUrl{
    [self.masterPassImage setImageWithURL:[NSURL URLWithString:mpImageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.providerImage setImageWithURL:[NSURL URLWithString:brandImageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

-(void)setCards:(NSArray *)cards showManualEntry:(BOOL)manualEntry{
    self.cards = cards;
    self.manualEntryAllowed = manualEntry;
    [self.cardSwipeView reloadData];
}

#pragma mark - SwipeView methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
   return [self.cards count] + (self.manualEntryAllowed ? 1 : 0);
}

-(CGSize)swipeViewItemSize:(SwipeView *)swipeView{
    return CGSizeMake(200, swipeView.bounds.size.height);
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    MPManager *manager = [MPManager sharedInstance];
    MPCreditCard *currentCard = nil;
    
    if (index < [self.cards count]  && [manager isAppPaired]) {
        currentCard = [self.cards objectAtIndex:index];
    }

    UIImageView *cardImage = nil;
    UILabel *expDate = nil;
    UILabel *cardNumber = nil;
    UILabel *cardHolder = nil;
    
    static CGFloat cardImageWidth = 150;
    static CGFloat cardImageHeight = 85;
    static CGFloat padding = 20;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        
        CGRect viewFrame = swipeView.bounds;
        view = [[UIView alloc] initWithFrame:viewFrame];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = [UIColor superGreyColor];
        
        cardImage = [[UIImageView alloc] initWithFrame:CGRectMake((view.bounds.size.width /2) - (cardImageWidth / 2), (view.bounds.size.height /2) - (cardImageHeight / 2) - padding, cardImageWidth, cardImageHeight)];
        [cardImage.layer setCornerRadius:4];
        cardImage.tag = 1;
        cardImage.backgroundColor = [UIColor superGreyColor];
        [view addSubview:cardImage];
        [cardImage makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@76.5);
            make.width.equalTo(@135);
            make.center.equalTo(view);
        }];
        
        cardNumber = [[UILabel alloc]initWithFrame:CGRectZero];
        cardNumber.font = [UIFont boldSystemFontOfSize:10];
        cardNumber.textColor = [UIColor whiteColor];
        cardNumber.backgroundColor = [UIColor clearColor];
        cardNumber.tag = 2;
        [cardImage addSubview:cardNumber];
        [cardNumber makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.width.equalTo(cardImage);
            make.left.equalTo(cardImage).with.offset(12);
            make.centerY.equalTo(cardImage).with.offset(5);
        }];
        
        expDate = [[UILabel alloc]initWithFrame:CGRectZero];
        expDate.font = [UIFont boldSystemFontOfSize:9];
        expDate.tag = 3;
        expDate.textColor = [UIColor whiteColor];
        expDate.backgroundColor = [UIColor clearColor];
        [cardImage addSubview:expDate];
        [expDate makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            make.width.equalTo(@40);
            make.left.equalTo(cardImage).with.offset(12);
            make.bottom.equalTo(cardImage).with.offset(-3);
        }];
        
        cardHolder = [[UILabel alloc]initWithFrame:CGRectZero];
        cardHolder.font = [UIFont boldSystemFontOfSize:9];
        cardHolder.text = @"";
        cardHolder.tag = 4;
        cardHolder.textColor = [UIColor whiteColor];
        cardHolder.backgroundColor = [UIColor clearColor];
        [cardImage addSubview:cardHolder];
        [cardHolder makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            make.width.equalTo(@60);
            make.left.equalTo(cardImage).with.offset(12);
            make.bottom.equalTo(expDate.top).with.offset(5);
        }];
    }
    else
    {
        //get a reference to the label in the recycled view
        cardImage = (UIImageView *)[view viewWithTag:1];
        cardNumber = (UILabel *)[view viewWithTag:2];
        expDate = (UILabel *)[view viewWithTag:3];
        cardHolder = (UILabel *)[view viewWithTag:4];
    }
    
    if (currentCard) {
        cardImage.image = [self cardImageForCardType:currentCard.brandId lastFour:currentCard.lastFour];
        cardNumber.text = [NSString stringWithFormat:@" XXXX XXXX XXXX %@",currentCard.lastFour];
        cardHolder.text = currentCard.cardHolderName;
        if (currentCard.expiryMonth && currentCard.expiryYear) {
            expDate.text = [NSString stringWithFormat:@"%@/%@",currentCard.expiryMonth,currentCard.expiryYear];
        }
        else {
            expDate.text = nil;
        }
        cardHolder.hidden = NO;
    }
    // Manual Entry Card
    else {
        cardImage.image = [UIImage imageNamed:@"blue_cc.png"];
        cardNumber.text = @" 0000 0000 0000 0000";
        expDate.text = @"00/00";
        cardHolder.text = @"NAME";
    }

    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    [self refreshCurrentCardUI:swipeView];
}

#pragma mark - Refresh UI

-(void)refreshCurrentCardUI:(SwipeView *)swipeView{
    MPCreditCard *currentCard = nil;
    MPManager *manager = [MPManager sharedInstance];
    
    if (swipeView.currentPage < [self.cards count] && [manager isAppPaired]) {
        currentCard = [[self cards] objectAtIndex:swipeView.currentPage];
    }
    
    if (currentCard) {
        self.expDate.text = [NSString stringWithFormat:@"Expires: %@/%@",currentCard.expiryMonth, currentCard.expiryYear];
        self.cardNumber.text = [NSString stringWithFormat:@"Card ending in %@",currentCard.lastFour];
        
        // Selected card
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckoutCardSelected" object:nil userInfo:@{@"card":[[self cards] objectAtIndex:swipeView.currentPage],@"index":[NSNumber numberWithInteger:swipeView.currentPage]}];
    }
    else {
        self.expDate.text = nil;
        self.cardNumber.text = @"New Credit Card";
        
        // add new card
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckoutNewCardSelected" object:nil];
    }
}

#pragma mark - Memory Management
- (void)dealloc
{
    _cardSwipeView.delegate = nil;
    _cardSwipeView.dataSource = nil;
}

@end
