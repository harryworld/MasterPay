//
//  CardSelectCell.m
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "CardSelectCell.h"
#import "CardManager.h"
#import "Card.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface CardSelectCell ()
@property (nonatomic, strong) UIImageView *masterPassImage;
@property (nonatomic, strong) UIImageView *providerImage;
@property (nonatomic, strong) UILabel *cardNumber;
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
        
        CGFloat bottomOffset = -10;
        
        UIView *providerImageContainer = [[UIView alloc]initWithFrame:CGRectZero];
        providerImageContainer.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:providerImageContainer];
        [providerImageContainer makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@150);
            make.height.equalTo(@40);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).with.offset(bottomOffset);
        }];
        
        self.masterPassImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.masterPassImage.image = [UIImage imageNamed:@"masterpass-small-logo.png"];
        [providerImageContainer addSubview:self.masterPassImage];
        [self.masterPassImage makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@45);
            make.centerY.equalTo(providerImageContainer);
            make.left.equalTo(providerImageContainer).with.offset(5);
        }];
        
        self.providerImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.providerImage.backgroundColor = [UIColor clearColor];
        [providerImageContainer addSubview:self.providerImage];
        [self.providerImage makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@80);
            make.centerY.equalTo(providerImageContainer);
            make.right.equalTo(providerImageContainer).with.offset(-5);
        }];
        
        
        self.cardNumber = [[UILabel alloc]initWithFrame:CGRectZero];
        self.cardNumber.font = [UIFont systemFontOfSize:11.5];
        self.cardNumber.backgroundColor = [UIColor superGreyColor];
        self.cardNumber.tag = 2;
        self.cardNumber.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.cardNumber];
        [self.cardNumber makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@22);
            make.width.equalTo(@150);
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).with.offset(35);
        }];
        
        [self refreshCurrentCardUI:self.cardSwipeView];
        
    };
    return self;
}

#pragma mark - SwipeView methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    CardManager *cm = [CardManager getInstance];
    if (cm.isLinkedToMasterPass) {
        //return the total number of items in the carousel
        CardManager *cm = [CardManager getInstance];
        return [[cm cards] count] + 1;
    }
    else {
        return 2;
    }
}

-(CGSize)swipeViewItemSize:(SwipeView *)swipeView{
    return CGSizeMake(200, swipeView.bounds.size.height);
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    CardManager *cm = [CardManager getInstance];
    Card *currentCard = nil;
    
    if (index < [[cm cards]count]  && cm.isLinkedToMasterPass) {
        currentCard = [[cm cards] objectAtIndex:index];
    }

    UIImageView *cardImage = nil;
    UILabel *expDate = nil;
    
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
        [view addSubview:cardImage];
        [cardImage makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@85);
            make.width.equalTo(@150);
            make.centerX.equalTo(view);
            make.centerY.equalTo(view).with.offset(-padding);
        }];
        
        
        expDate = [[UILabel alloc]initWithFrame:CGRectZero];
        expDate.font = [UIFont boldSystemFontOfSize:13];
        expDate.backgroundColor = [UIColor brightOrangeColor];
        [expDate.layer setCornerRadius:6];
        expDate.tag = 3;
        [cardImage addSubview:expDate];
        [expDate makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.width.equalTo(@40);
            make.left.equalTo(cardImage).with.offset(5);
            make.bottom.equalTo(cardImage).with.offset(-1);
        }];
    }
    else
    {
        //get a reference to the label in the recycled view
        cardImage = (UIImageView *)[view viewWithTag:1];
        expDate = (UILabel *)[view viewWithTag:3];
    }
    
    if (currentCard) {
        expDate.hidden = NO;
        cardImage.image = [UIImage imageNamed:currentCard.iconName];
        cardImage.backgroundColor = [UIColor superGreyColor];
        expDate.text = currentCard.expDate;
    }
    else if((!cm.isLinkedToMasterPass) && (index == 0)) {
        expDate.hidden = YES;
        cardImage.image = [UIImage imageNamed:@"masterpass-small-logo.png"];
        cardImage.backgroundColor = [UIColor superGreyColor];
        expDate.text = nil;
    }
    else {
        expDate.hidden = YES;
        cardImage.image = nil;
        cardImage.image = [UIImage imageNamed:@"orange_cc.png"];
        cardImage.backgroundColor = [UIColor superGreyColor];
        expDate.text = nil;
    }

    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    [self refreshCurrentCardUI:swipeView];
}

#pragma mark - Refresh UI

-(void)refreshCurrentCardUI:(SwipeView *)swipeView{
    CardManager *cm = [CardManager getInstance];
    Card *currentCard = nil;
    if (swipeView.currentPage < [[cm cards]count] && cm.isLinkedToMasterPass) {
        currentCard = [[cm cards] objectAtIndex:swipeView.currentPage];
    }
    
    if (currentCard) {
        self.cardNumber.hidden = NO;
        self.cardNumber.text = [NSString stringWithFormat:@"Card ending in %@",currentCard.lastFour];
        
        if ([currentCard.isMasterPass boolValue]) {
            self.masterPassImage.alpha = 1;
        }
        else {
            self.masterPassImage.alpha = 0.3;
        }
        
        if (currentCard.imageUrl) {
            [self.providerImage setImage:[UIImage imageNamed:@"bank-logo.png"]];
            self.providerImage.hidden = NO;
        }
        else {
            self.providerImage.hidden = YES;
        }
    }
    else {
        self.cardNumber.hidden = NO;
        self.cardNumber.text = @"Enter Credit Card Details";
        self.providerImage.hidden = YES;
        self.masterPassImage.alpha = 0;
    }
    
    if (currentCard) {
        // Selected card
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckoutCardSelected" object:nil userInfo:@{@"card":[[cm cards] objectAtIndex:swipeView.currentPage],@"index":[NSNumber numberWithInteger:swipeView.currentPage]}];
    }
    else if((!cm.isLinkedToMasterPass) && (swipeView.currentPage == 0)){
        // pairing
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckoutPairSelected" object:nil];
    }
    else {
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
