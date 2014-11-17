//
//  MPPairingViewController.h
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPPairingViewController;

@protocol MPPairingViewControllerDelegate <NSObject>
@required
-(void)pairingView:(MPPairingViewController *)pairingViewController didCompletePairing:(BOOL)success error:(NSError *)error;

@end // end of delegate protocol

@interface MPPairingViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) id<MPPairingViewControllerDelegate> delegate;

- (void)startPairWithDetails:(NSDictionary *)pairingDetails;
@end
