//
//  MPManager.m
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "MPManager.h"

@interface MPManager () <MPLightboxViewControllerDelegate>

@end

@implementation MPManager

NSString *const DataTypeCard = @"CARD";
NSString *const DataTypeAddress = @"ADDRESS";
NSString *const DataTypeProfile = @"PROFILE";

NSString *const CardTypeAmex = @"amex";
NSString *const CardTypeMasterCard = @"master";
NSString *const CardTypeDiscover = @"discover";
NSString *const CardTypeVisa = @"visa";
NSString *const CardTypeMaestro = @"maestro";

NSString *const MPVersion = @"v6";

NSString *const MPErrorDomain = @"MasterPassErrorDomain";
NSString *const MPErrorNotPaired = @"No long access token found associated with user (user not paired with Masterpass)";
NSInteger const MPErrorCodeBadRequest = 400;

#pragma mark - Init

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
    NSAssert(self.delegate &&
             [self.delegate respondsToSelector:@selector(serverAddress)] &&
             [self.delegate respondsToSelector:@selector(isAppPaired)] &&
             [self.delegate respondsToSelector:@selector(supportedDataTypes)] &&
             [self.delegate respondsToSelector:@selector(supportedCardTypes)],
             @"MPManager needs a valid delegate");
}

#pragma mark - Pairing

- (void)pairInViewController:(UIViewController *)viewController{
    [self checkDelegateSanity];
    
    [self requestPairing:^(NSDictionary *pairingDetails, NSError *error) {
        if (error) {
            NSLog(@"Error Requesting Pairing: %@",[error localizedDescription]);
            [self checkDelegateSanity];
            if ([self.delegate respondsToSelector:@selector(pairingView:didCompletePairing:error:)]) {
                [self.delegate pairingDidComplete:NO error:error];
            }
        }
        else {
            
            NSDictionary *lightBoxParams = @{@"requestedDataTypes":[self.delegate supportedDataTypes],
                                             @"pairingRequestToken":pairingDetails[@"pairing_request_token"],
                                             @"callbackUrl":pairingDetails[@"callback_url"],
                                             @"merchantCheckoutId":pairingDetails[@"merchant_checkout_id"],
                                             @"requestPairing":@1,
                                             @"version":MPVersion};
            
            if ([self.delegate respondsToSelector:@selector(expressCheckoutEnabled)]) {
                if ([self.delegate expressCheckoutEnabled]) {
                    NSMutableDictionary *mutableParams = [lightBoxParams mutableCopy];
                    [mutableParams setObject:@1 forKey:@"requestExpressCheckout"];
                    lightBoxParams = mutableParams;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLightboxWindowOfType:MPLightBoxTypeConnect options:lightBoxParams inViewController:viewController];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil, error);
                });
            }
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&jsonError];            
            if (jsonError) {
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(nil, jsonError);
                    });
                }
            }
            else {
                NSLog(@"Approved Pairing Request: %@",json);
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(json, nil);
                    });
                }
            }
            
        }
    }];
}

- (void)showLightboxWindowOfType:(MPLightBoxType)type options:(NSDictionary *)options inViewController:(UIViewController *)viewController{
    MPLightboxViewController *lightboxViewController = [[MPLightboxViewController alloc]init];
    lightboxViewController.delegate = self;
    [viewController presentViewController:lightboxViewController animated:YES completion:^{
        [lightboxViewController initiateLightBoxOfType:type WithOptions:options];
    }];
}

- (void)pairingView:(MPLightboxViewController *)pairingViewController didCompletePairing:(BOOL)success error:(NSError *)error{
    [pairingViewController dismissViewControllerAnimated:YES completion:^{
        [self checkDelegateSanity];
        if ([self.delegate respondsToSelector:@selector(pairingDidComplete:error:)]) {
            [self.delegate pairingDidComplete:success error:error];
        }
    }];
}

- (BOOL)isAppPaired{
    [self checkDelegateSanity];
    return [self.delegate isAppPaired];
}

#pragma mark - Checkout

- (void)precheckoutDataCallback:(void (^)(NSArray *cards, NSArray *addresses, NSDictionary *contactInfo, NSDictionary *walletInfo, NSError *error))callback{
    
    NSAssert([self isAppPaired], @"User must be paired with MasterPass before calling precheckout");
    
    [self checkDelegateSanity];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/masterpass/precheckout",[self.delegate serverAddress]]];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"requested_data_types":[self.delegate supportedDataTypes]} options:0 error:&jsonError];
    
    if (jsonError) {
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil,nil,nil,nil,jsonError);
            });
        }
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil,nil,nil,nil,error);
                });
            }
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
            if (jsonError) {
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(nil,nil,nil,nil,jsonError);
                    });
                }
            }
            else {
                NSLog(@"Recieved Precheckout Data: %@",json);
                
                if ([json[@"status"] isEqualToString:@"error"]) {
                    
                    if ([json[@"errors"] isEqualToString:MPErrorNotPaired]) {
                        
                        // User is not paired. They may have disconnected
                        // via the MasterPass console.
                        // We will optionally reset that pairing status here
                        
                        if ([self.delegate respondsToSelector:@selector(resetUserPairing)]) {
                            [self.delegate resetUserPairing];
                        }
                    }
                    
                    
                    if (callback) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(nil,nil,nil, nil, [NSError errorWithDomain:MPErrorDomain code:MPErrorCodeBadRequest userInfo:@{NSLocalizedDescriptionKey:json[@"errors"]}]);
                        });
                    }
                    return;
                }
                
                NSArray *cardData = (NSArray *)[json objectForKey:@"cards"];
                NSMutableArray *cards = [[NSMutableArray alloc]init];
                for (NSDictionary *card in cardData) {
                    [cards addObject:[[MPCreditCard alloc]initWithDictionary:card]];
                }
                
                NSArray *addressData = (NSArray *)[json objectForKey:@"shipping_addresses"];
                NSMutableArray *addresses = [[NSMutableArray alloc]init];
                for (NSDictionary *address in addressData) {
                    [addresses addObject:[[MPAddress alloc]initWithDictionary:address]];
                }
                
                NSDictionary *contact = (NSDictionary *)[json objectForKey:@"contact"];
                NSDictionary *wallet = (NSDictionary *)[json objectForKey:@"wallet_info"];
                
                
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(cards, addresses, contact, wallet, nil);
                    });
                }
            }
            
        }
    }];
}

- (void)requestReturnCheckoutForOrder:(NSString *)orderNumber callback:(void (^)(NSDictionary *pairingDetails, NSError *error))callback{
    
    NSAssert([self isAppPaired], @"User must be paired with MasterPass before calling return checkout");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/masterpass/return_checkout",[self.delegate serverAddress]]];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"order_header_id":orderNumber} options:0 error:&jsonError];
    
    if (jsonError) {
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil,jsonError);
            });
        }
        return;
    }
    
    NSLog(@"%@",[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil,error);
                });
            }
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            if (jsonError) {
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(nil,jsonError);
                    });
                }
            }
            else {
                NSLog(@"Approved Return Checkout Request: %@",json);
                if ([json hasKey:@"status"] && ![json[@"status"] isEqualToString:@"success"]) {
                    if (callback) {
                        NSError *err = [NSError errorWithDomain:MPErrorDomain code:783 userInfo:@{NSLocalizedDescriptionKey:json[@"errors"]}];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(nil, err);
                        });
                    }
                }
                else {
                    if (callback) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(json, nil);
                        });
                    }
                }
            }
            
        }
        
    }];
    
}

-(void)returnCheckoutForOrder:(NSString *)orderNumber walletInfo:(NSDictionary *)walletInfo card:(MPCreditCard *)card shippingAddress:(MPAddress *)shippingAddress showInViewController:(UIViewController*)viewController{
    [self requestReturnCheckoutForOrder:orderNumber callback:^(NSDictionary *pairingDetails, NSError *error) {
        if (error) {
            NSLog(@"Error Requesting Return Checkout: %@",[error localizedDescription]);
            [self checkDelegateSanity];
            if ([self.delegate respondsToSelector:@selector(pairingView:didCompletePairing:error:)]) {
                [self.delegate pairingDidComplete:NO error:error];
            }
        }
        else {

            NSDictionary *lightBoxParams = @{@"requestToken":pairingDetails[@"checkout_request_token"],
                                             @"merchantCheckoutId":pairingDetails[@"merchant_checkout_id"],
                                             @"cardId":card.cardId,
                                             @"callbackUrl":pairingDetails[@"callback_url"],
                                             @"shippingId":shippingAddress.addressId,
                                             @"precheckoutTransactionId":walletInfo[@"precheckout_transaction_id"],
                                             @"walletName":walletInfo[@"wallet_name"],
                                             @"consumerWalletId":walletInfo[@"consumer_wallet_id"],
                                             @"version":MPVersion};
            
            NSLog(@"Params %@",lightBoxParams);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLightboxWindowOfType:MPLightBoxTypeCheckout options:lightBoxParams inViewController:viewController];
            });
        }
    }];
}

-(BOOL)expressCheckoutEnabled {
    if ([self.delegate respondsToSelector:@selector(expressCheckoutEnabled)]) {
        return [self.delegate expressCheckoutEnabled];
    }
    else return false;
}

-(void)expressCheckoutForOrder:(NSString *)orderNumber walletInfo:(NSDictionary *)walletInfo card:(MPCreditCard *)card shippingAddress:(MPAddress *)shippingAddress callback:(void (^)(BOOL success, NSDictionary *response, NSError *error))callback{
    
    NSAssert([self isAppPaired], @"User must be paired with MasterPass before calling return checkout");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/masterpass/express_checkout",[self.delegate serverAddress]]];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{
                                                                 @"order_header_id":orderNumber,
                                                                 @"precheckout_transaction_id":walletInfo[@"precheckout_transaction_id"],
                                                                 @"card_id":card.cardId,
                                                                 @"shipping_id":shippingAddress.addressId
                                                                 }
                                                       options:0 error:&jsonError];
    
    if (jsonError) {
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(false,nil,jsonError);
            });
        }
        return;
    }
    
    NSLog(@"%@",[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(false,nil,error);
                });
            }
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            if (jsonError) {
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(false, nil,jsonError);
                    });
                }
            }
            else {
                NSLog(@"Approved Express Checkout: %@",json);
                if ([json hasKey:@"status"] && ![json[@"status"] isEqualToString:@"success"]) {
                    if (callback) {
                        NSError *err = [NSError errorWithDomain:MPErrorDomain code:783 userInfo:@{NSLocalizedDescriptionKey:json[@"errors"]}];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(false, json, err);
                        });
                    }
                }
                else {
                    if (callback) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(true, json, nil);
                        });
                    }
                }
            }
            
        }
        
    }];

}

-(void)lightBox:(MPLightboxViewController *)pairingViewController didCompleteCheckout:(BOOL)success error:(NSError *)error{
    [pairingViewController dismissViewControllerAnimated:YES completion:^{
        [self checkDelegateSanity];
        if ([self.delegate respondsToSelector:@selector(checkoutDidComplete:error:)]) {
            [self.delegate checkoutDidComplete:success error:error];
        }
    }];
}

#pragma mark - Pair and Checkout

-(void)pairCheckoutForOrder:(NSString *)orderNumber
       showInViewController:(UIViewController*)viewController{
    [self requestPairCheckoutForOrder:orderNumber callback:^(NSDictionary *pairingDetails, NSError *error) {
        if (error) {
            NSLog(@"Error Requesting Pair Checkout: %@",[error localizedDescription]);
            [self checkDelegateSanity];
            if ([self.delegate respondsToSelector:@selector(pairingView:didCompletePairing:error:)]) {
                [self.delegate pairingDidComplete:NO error:error];
            }
        }
        else {
            NSDictionary *lightBoxParams = @{@"requestToken":pairingDetails[@"checkout_request_token"],
                                             @"merchantCheckoutId":pairingDetails[@"merchant_checkout_id"],
                                             @"requestedDataTypes":[self.delegate supportedDataTypes],
                                             @"callbackUrl":pairingDetails[@"callback_url"],
                                             @"pairingRequestToken":pairingDetails[@"pairing_request_token"],
                                             @"allowedCardTypes":[self.delegate supportedCardTypes],
                                             @"requestPairing":@1,
                                             @"version":MPVersion};
            
            if ([self.delegate respondsToSelector:@selector(expressCheckoutEnabled)]) {
                if ([self.delegate expressCheckoutEnabled]) {
                    NSMutableDictionary *mutableParams = [lightBoxParams mutableCopy];
                    [mutableParams setObject:@1 forKey:@"requestExpressCheckout"];
                    lightBoxParams = mutableParams;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLightboxWindowOfType:MPLightBoxTypePreCheckout options:lightBoxParams inViewController:viewController];
            });
        }
    }];
}

- (void)requestPairCheckoutForOrder:(NSString *)orderNumber callback:(void (^)(NSDictionary *pairingDetails, NSError *error))callback{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/masterpass/pair_and_checkout",[self.delegate serverAddress]]];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"order_header_id":orderNumber} options:0 error:&jsonError];
    
    if (jsonError) {
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil,jsonError);
            });
        }
        return;
    }
    
    NSLog(@"%@",[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil,error);
                });
            }
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            if (jsonError) {
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(nil,jsonError);
                    });
                }
            }
            else {
                NSLog(@"Approved Pair Checkout Request: %@",json);
                
                if ([json hasKey:@"status"] && ![json[@"status"] isEqualToString:@"success"]) {
                    if (callback) {
                        NSError *err = [NSError errorWithDomain:MPErrorDomain code:783 userInfo:@{NSLocalizedDescriptionKey:json[@"errors"]}];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(nil, err);
                        });
                    }
                }
                else {
                    if (callback) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(json, nil);
                        });
                    }
                }
            }
            
        }
        
    }];
    
}

-(void)completePairCheckoutForOrder:(NSString *)orderNumber
                        transaction:(NSString *)transactionId
             preCheckoutTransaction:(NSString *)precheckoutTransactionId{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/masterpass/complete_checkout",[self.delegate serverAddress]]];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"order_header_id":orderNumber,
                                                                 @"transaction_id":transactionId,
                                                                 @"pre_checkout_transaction_id":precheckoutTransactionId} options:0 error:&jsonError];
    
    if (jsonError) {
        NSLog(@"JSON Error: %@",[jsonError localizedDescription]);
        return;
    }
    
    NSLog(@"%@",[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
            
            if (jsonError) {
                NSLog(@"JSON Error: %@",[jsonError localizedDescription]);
            }
            else {
                //TODO FIX THIS
                if ([json hasKey:@"status"] && ![json[@"status"] isEqualToString:@"success"]) {
                    NSLog(@"Completed Checkout Successfully");
                    NSLog(@"%@",json);
                    if (self.delegate && [self.delegate respondsToSelector:@selector(pairCheckoutDidComplete:error:)]) {
                        [self.delegate pairCheckoutDidComplete:FALSE error:error];
                    }
                }
                else {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(pairCheckoutDidComplete:error:)]) {
                        [self.delegate pairCheckoutDidComplete:TRUE error:nil];
                    }
                }
            }
        }
    }];
}

-(void)lightBox:(MPLightboxViewController *)lightBoxViewController didCompletePreCheckout:(BOOL)success data:(NSDictionary *)data error:(NSError *)error{
    [lightBoxViewController dismissViewControllerAnimated:YES completion:^{
        [self checkDelegateSanity];
        if ([self.delegate respondsToSelector:@selector(preCheckoutDidComplete:data:error:)]) {
            [self.delegate preCheckoutDidComplete:success data:data error:error];
        }
    }];
}

#pragma mark - Manual Checkout

- (void)completeManualCheckoutForOrder:(NSString *)orderNumber{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/masterpass/non_masterpass_checkout",[self.delegate serverAddress]]];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"order_header_id":orderNumber} options:0 error:&jsonError];
    
    if (jsonError) {
        NSLog(@"JSON Error: %@",[jsonError localizedDescription]);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            if (jsonError) {
                NSLog(@"JSON Error: %@",[jsonError localizedDescription]);
            }
            else {
                if ([json[@"status"] isEqualToString:@"success"]) {
                    NSLog(@"Completed Manual Checkout Successfully");
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(manualCheckoutDidComplete:error:)]) {
                        [self.delegate manualCheckoutDidComplete:TRUE error:nil];
                    }
                }
                else {
                    NSLog(@"%@",json);
                    if (self.delegate && [self.delegate respondsToSelector:@selector(manualCheckoutDidComplete:error:)]) {
                        [self.delegate manualCheckoutDidComplete:FALSE error:error];
                    }
                }
            }
        }
    }];
}

@end
