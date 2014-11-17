//
//  MPManager.m
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "MPManager.h"

@implementation MPManager

+ (instancetype)sharedInstance{
    static MPManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [MPManager alloc];
        sharedInstance = [sharedInstance init];
    });
    
    return sharedInstance;
}

- (void)checkDelegateSanity{
    NSAssert(self.delegate && [self.delegate respondsToSelector:@selector(serverAddress)],
             @"MPManager needs a valid delegate");
}

- (void)pairInViewController:(UIViewController *)viewController callback:(void (^)(BOOL success, NSError *error))callback{
    [self checkDelegateSanity];
    
    [self requestPairing:^(NSDictionary *pairingDetails, NSError *error) {
        if (error) {
            NSLog(@"Error Requesting Pairing: %@",[error localizedDescription]);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showPairingWindow:pairingDetails inViewController:viewController];
            });
        }
    }];
    
}

- (void)requestPairing:(void (^)(NSDictionary *pairingDetails, NSError *error))callback{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/masterpass/pair",[self.delegate serverAddress]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&jsonError];
            
            if (jsonError) {
                if (callback) {
                    callback(nil, jsonError);
                }
            }
            else {
                NSLog(@"Approved Pairing Request: %@",json);
                if (callback) {
                    callback(json, nil);
                }
            }
            
        }
    }];
}

- (void)showPairingWindow:(NSDictionary *)pairingDetails inViewController:(UIViewController *)viewController{
    MPPairingViewController *pairingViewController = [[MPPairingViewController alloc]init];
    pairingViewController.delegate = self;
    [viewController presentViewController:pairingViewController animated:YES completion:^{
        [pairingViewController startPairWithDetails:pairingDetails];
    }];
}

-(void)pairingView:(MPPairingViewController *)pairingViewController didCompletePairing:(BOOL)success error:(NSError *)error{
    
    [pairingViewController dismissViewControllerAnimated:YES completion:^{
        [self checkDelegateSanity];
        if ([self.delegate respondsToSelector:@selector(pairingView:didCompletePairing:error:)]) {
            [self.delegate pairingDidComplete:success error:error];
        }
    }];
}

@end
