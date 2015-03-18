//
//  MPManager.h
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLightboxViewController.h"
#import "MPCreditCard.h"
#import "MPAddress.h"

@protocol MPManagerDelegate <NSObject>
@required

/**
 * Provides the server address (url) at which the MasterPass services reside
 *
 * @return the server address at which the MasterPass service resides
 */
- (NSString *)serverAddress;

/**
 * Provides the logic from the host app to determine if the current
 * user is paired. Usually this incorporates some logic to determine
 * if a user has a long access token, which is stored server-side.
 *
 * @return the current pairing status
 */
- (BOOL)isAppPaired;

/**
 * Returns an array of supported data types (card, address, profile, etc)
 * for this app
 *
 * @return the supported data types
 */
- (NSArray *)supportedDataTypes;

/**
 * Returns an array of supported card types (MasterCard, Visa, Discover, etc)
 * for this app
 *
 * @return the supported card types
 */
- (NSArray *)supportedCardTypes;

@optional

/**
 * Method that executes when pairing completes
 *
 * @param success the status of the pairing
 * @param error any errors that occurred during pairing
 */
-(void)pairingDidComplete:(BOOL)success error:(NSError *)error;

/**
 * Method that executes when checkout completes
 *
 * @param success the status of the checkout
 * @param error any errors that occurred during checkout
 */
- (void)checkoutDidComplete:(BOOL)success error:(NSError *)error;

/**
 * Method that executes when precheckout completes
 *
 * @param success the status of the checkout
 * @param data the precheckout data
 * @param error any errors that occurred during checkout
 */
- (void)preCheckoutDidComplete:(BOOL)success data:(NSDictionary *)data error:(NSError *)error;

/**
 * Method that executes when pair & checkout completes
 *
 * @param success the status of the checkout
 * @param error any errors that occurred during checkout
 */
- (void)pairCheckoutDidComplete:(BOOL)success error:(NSError *)error;

/**
 * Method that executes when manual checkout completes
 *
 * @param success the status of the checkout
 * @param error any errors that occurred during checkout
 */
- (void)manualCheckoutDidComplete:(BOOL)success error:(NSError *)error;

/**
 * Method to force the reset of a user token
 * This is usually acheived by forceably removing the 
 * long access token from the user object
 */
- (void)resetUserPairing;


- (BOOL)expressCheckoutEnabled;

@end

@interface MPManager : NSObject

FOUNDATION_EXPORT NSString *const DataTypeCard;         // Constant for Card Datatype. Used for initializing some MP services.
FOUNDATION_EXPORT NSString *const DataTypeAddress;      // Constant for Address Datatype. Used for initializing some MP services.
FOUNDATION_EXPORT NSString *const DataTypeProfile;      // Constant for Profile Datatype. Used for initializing some MP services.

FOUNDATION_EXPORT NSString *const CardTypeAmex;         // Constant for American Express Card Support
FOUNDATION_EXPORT NSString *const CardTypeMasterCard;   // Constant for MasterCard Card Support
FOUNDATION_EXPORT NSString *const CardTypeDiscover;     // Constant for Discover Card Support
FOUNDATION_EXPORT NSString *const CardTypeVisa;         // Constant for Visa Card Support
FOUNDATION_EXPORT NSString *const CardTypeMaestro;      // Constant for Maestro Card Support

FOUNDATION_EXPORT NSString *const MPErrorNotPaired;

@property (nonatomic, weak) id<MPManagerDelegate> delegate;


#pragma mark - Init

/**
 * Initializes (for returns the shared instance of) the manager to interact with
 * the MasterPass services
 *
 * @return MPManager instance
 */
+ (instancetype)sharedInstance;

#pragma mark - Pairing

/**
 * Opens the pairing modal over a viewcontroller.
 *
 * @param viewController The viewcontroller to show the pairing modal over
 */
- (void)pairInViewController:(UIViewController *)viewController;

/**
 * The current pairing status as defined by the delegate.
 * This is just a convience method for [self.delegate isAppPaired]
 *
 * @return the current pairing status
 */
- (BOOL)isAppPaired;

#pragma mark - Return Checkout

/**
 * Retrieves the precheckout data from the MasterPass service
 *
 * @param callback The block to execute with the precheckout data
 */
- (void)precheckoutDataCallback:(void (^)(NSArray *cards,
                                              NSArray *addresses,
                                              NSDictionary *contactInfo,
                                              NSDictionary *walletInfo,
                                              NSError *error)
                                     )callback;

- (void)returnCheckoutForOrder:(NSString *)orderNumber
                   walletInfo:(NSDictionary *)walletInfo
                         card:(MPCreditCard *)card
              shippingAddress:(MPAddress *)shippingAddress
         showInViewController:(UIViewController*)viewController;

#pragma mark - Pair Checkout

-(void)pairCheckoutForOrder:(NSString *)orderNumber
       showInViewController:(UIViewController*)viewController;

- (void)completePairCheckoutForOrder:(NSString *)orderNumber
                        transaction:(NSString *)transactionId
             preCheckoutTransaction:(NSString *)precheckoutTransactionId;

#pragma mark - Express Checkout

-(BOOL)expressCheckoutEnabled;

-(void)expressCheckoutForOrder:(NSString *)orderNumber walletInfo:(NSDictionary *)walletInfo card:(MPCreditCard *)card shippingAddress:(MPAddress *)shippingAddress callback:(void (^)(BOOL success, NSDictionary *response, NSError *error))callback;

#pragma mark - Manual Checkout

- (void)completeManualCheckoutForOrder:(NSString *)orderNumber;

@end
