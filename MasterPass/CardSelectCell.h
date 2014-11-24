//
//  CardSelectCell.h
//  MasterPass
//
//  Created by David Benko on 5/15/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SwipeView/SwipeView.h>
@interface CardSelectCell : UITableViewCell <SwipeViewDataSource,SwipeViewDelegate>
@property(nonatomic, strong)SwipeView *cardSwipeView;
@property(nonatomic, assign)BOOL showsMPPair;

-(void)refreshCurrentCardUI:(SwipeView *)swipeView;

-(void)setCards:(NSArray *)cards showManualEntry:(BOOL)manualEntry;
-(void)setMasterPassImage:(NSString *)mpImageUrl andBrandImage:(NSString *)brandImageUrl;

@end
