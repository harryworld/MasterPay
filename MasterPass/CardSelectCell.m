//
//  CardSelectCell.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "CardSelectCell.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "MPManager.h"

@interface CardSelectCell ()
@property (nonatomic, strong) UIImageView *masterPassImage;
@property (nonatomic, strong) UIImageView *providerImage;
@property (nonatomic, strong) UILabel *cardNumber;
@property (nonatomic, strong) UILabel *expDate;
@property (nonatomic, strong) NSArray *cards;
@property (nonatomic, assign) BOOL manualEntryAllowed;
@end

@implementation CardSelectCell

#pragma mark - View Setup

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor superGreyColor];
        
        _showsMPPair = YES;
        
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
        
        CGFloat bottomOffset = 5;
        
        UIView *providerImageContainer = [[UIView alloc]initWithFrame:CGRectZero];
        providerImageContainer.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:providerImageContainer];
        [providerImageContainer makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@150);
            make.height.equalTo(@35);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).with.offset(-bottomOffset);
        }];
        MPManager *manager = [MPManager sharedInstance];
        if ([manager isAppPaired]) {
            self.masterPassImage = [[UIImageView alloc]initWithFrame:CGRectZero];
            self.masterPassImage.image = [UIImage imageNamed:@"masterpass-small-logo.png"];
            [providerImageContainer addSubview:self.masterPassImage];
            [self.masterPassImage makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@30);
                make.width.equalTo(@45);
                make.centerY.equalTo(providerImageContainer);
                make.left.equalTo(providerImageContainer).with.offset(bottomOffset);
            }];
            
            self.providerImage = [[UIImageView alloc]initWithFrame:CGRectZero];
            self.providerImage.backgroundColor = [UIColor clearColor];
            [providerImageContainer addSubview:self.providerImage];
            [self.providerImage makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@30);
                make.width.equalTo(@80);
                make.centerY.equalTo(providerImageContainer);
                make.right.equalTo(providerImageContainer).with.offset(-bottomOffset);
            }];
        }
        else {
            self.masterPassImage = [[UIImageView alloc]initWithFrame:CGRectZero];
            [providerImageContainer addSubview:self.masterPassImage];
            [self.masterPassImage makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@30);
                make.width.equalTo(@45);
                make.center.equalTo(providerImageContainer);
            }];

        }
        
        [self refreshCurrentCardUI:self.cardSwipeView];
        
    };
    return self;
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
    
    if ([cardType isEqualToString:CardTypeAmex]) {
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

-(void)setShowsMPPair:(BOOL)showsMPPair{
    if (showsMPPair != _showsMPPair) {
        _showsMPPair = showsMPPair;
        [self refreshCurrentCardUI:self.cardSwipeView];
    }
}

#pragma mark - SwipeView methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    MPManager *manager = [MPManager sharedInstance];
    if ([manager isAppPaired]) {
        //return the total number of items in the carousel
        return [self.cards count] + (self.manualEntryAllowed ? 1 : 0);
    }
    /*else if (self.showsMPPair && !cm.wantsDelayedPair){ //TODO
        return 2;
    }else if(cm.wantsDelayedPair){
        return 1;
    }*/
    else {
        return 1;
    }
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
        cardNumber.hidden = NO;
        cardNumber.text = [NSString stringWithFormat:@" XXXX XXXX XXXX %@",currentCard.lastFour];
        cardHolder.text = currentCard.cardHolderName;
        expDate.hidden = NO;
        if (currentCard.expiryMonth && currentCard.expiryYear) {
            expDate.text = [NSString stringWithFormat:@"%@/%@",currentCard.expiryMonth,currentCard.expiryYear];
        }
        else {
            expDate.text = nil;
        }
        cardHolder.hidden = NO;
    }
    
    // TODO this is for pair + checkout
    
    else if((![manager isAppPaired]) && (index == 0) && self.showsMPPair) {
        
        // hard coded due to additional requirements
        
        cardImage.image = [UIImage imageNamed:@"black_cc_mc.png"];
        cardNumber.hidden = NO;
        cardNumber.text = [NSString stringWithFormat:@" XXXX XXXX XXXX %@",@"8733"];
        expDate.hidden = NO;
        expDate.text = @"03/17";
        cardHolder.hidden = NO;
    }
    
    // manual entry TODO
    else {
        cardImage.image = [UIImage imageNamed:@"blue_cc.png"];
        cardNumber.hidden = NO;
        expDate.hidden = NO;
        cardHolder.hidden = NO;
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
        self.expDate.hidden = NO;
        self.expDate.text = [NSString stringWithFormat:@"Expires: %@/%@",currentCard.expiryMonth, currentCard.expiryYear];
        self.cardNumber.hidden = NO;
        self.cardNumber.text = [NSString stringWithFormat:@"Card ending in %@",currentCard.lastFour];
        self.providerImage.hidden = NO;
        
        //if ([currentCard.isMasterPass boolValue]) { // TODO ?
        if (true){
            self.masterPassImage.alpha = 1;
        }
        else {
            self.masterPassImage.alpha = 0.3;
        }
        // Selected card
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckoutCardSelected" object:nil userInfo:@{@"card":[[self cards] objectAtIndex:swipeView.currentPage],@"index":[NSNumber numberWithInteger:swipeView.currentPage]}];
    }
    
    // TODO pair + checkout
    
    else if((![manager isAppPaired]) && (swipeView.currentPage == 0) && self.showsMPPair){
        self.expDate.hidden = YES;
        self.expDate.text = nil;
        self.cardNumber.hidden = NO;
        self.cardNumber.text = @"MasterPass Wallet";
        self.providerImage.hidden = YES;
        self.masterPassImage.alpha = 1;
        
        // pairing
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckoutPairSelected" object:nil];
    }
    
    // Manual entry TODO
    
    else {
        self.expDate.hidden = YES;
        self.expDate.text = nil;
        self.cardNumber.hidden = NO;
        self.cardNumber.text = @"New Credit Card";
        self.providerImage.hidden = YES;
        self.masterPassImage.alpha = 0;
        
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
