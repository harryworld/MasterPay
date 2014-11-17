//
//  MPManager.h
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPairingViewController.h"

@protocol MPManagerDelegate <NSObject>
@required
-(NSString *)serverAddress;

@optional
-(void)pairingDidComplete:(BOOL)success error:(NSError *)error;

@end // end of delegate protocol

@interface MPManager : NSObject <MPPairingViewControllerDelegate>

@property (nonatomic, strong) id<MPManagerDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)pairInViewController:(UIViewController *)viewController callback:(void (^)(BOOL success, NSError *error))callback;
@end
