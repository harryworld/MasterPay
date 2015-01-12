//
//  MPPairingViewController.h
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPManager.h"
@class MPLightboxViewController;

typedef NS_ENUM(NSInteger, MPLightBoxType) {
    MPLightBoxTypeConnect,
    MPLightBoxTypeCheckout,
    MPLightBoxTypePreCheckout
};

@protocol MPLightboxViewControllerDelegate <NSObject>
@required
-(void)pairingView:(MPLightboxViewController *)pairingViewController didCompletePairing:(BOOL)success error:(NSError *)error;

-(void)lightBox:(MPLightboxViewController *)lightBoxViewController didCompletePreCheckout:(BOOL)success data:(NSDictionary *)data error:(NSError *)error;

-(void)lightBox:(MPLightboxViewController *)pairingViewController didCompleteCheckout:(BOOL)success error:(NSError *)error;

@end // end of delegate protocol

@interface MPLightboxViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) id<MPLightboxViewControllerDelegate> delegate;

- (void)initiateLightBoxOfType:(MPLightBoxType)type WithOptions:(NSDictionary *)options;
@end
