//
//  AppDelegate.m
//  MasterPass
//
//  Created by David Benko on 4/22/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <APSDK/APObject+Remote.h>
#import <APSDK/AuthManager+Protected.h>
#import <APSDK/User.h>
#import <APSDK/APObject+Local.h>

@implementation AppDelegate
static NSString * const sampleUrl = @"https://sample.com";  // Don't change this
static NSString * const server = @"https://morning-beyond-8791.herokuapp.com";     // Change this to your server endpoint
static NSString * const version = @"/api/v3/";              // Change this to match your api version

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSAssert(![server isEqualToString:sampleUrl],
             @"Replace server URL with correct server endpoint");
    
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor deepBlueColor]];
    
    if ([UINavigationBar instancesRespondToSelector:@selector(setBarTintColor:)]) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor deepBlueColor]];
    }
    if ([UINavigationBar instancesRespondToSelector:@selector(setTintColor:)]) {
            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    if ([UINavigationBar instancesRespondToSelector:@selector(setTitleTextAttributes:)]) {
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    [[SIAlertView appearance] setMessageFont:[UIFont systemFontOfSize:13]];
    [[SIAlertView appearance] setCornerRadius:4];
    [[SIAlertView appearance] setShadowRadius:20];
    [[SIAlertView appearance] setCancelButtonColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setButtonFont:[UIFont boldSystemFontOfSize:18]];
    [[SIAlertView appearance]setCancelButtonImage:[UIColor imageWithColor:[UIColor brightOrangeColor] andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    
    
    [APObject setBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",server,version]]];
    
    AuthManager *auth = [AuthManager new];
    
    [auth setSignInURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/auth/password/callback",server]]];
    [auth setSignOutURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/auth/signout",server]]];
    
    [AuthManager setDefaultManager:auth];
    
    [[MPManager sharedInstance] setDelegate:self];
    
    return YES;
}

#pragma mark - Masterpass
- (NSString *)serverAddress{
    return server;
}

- (void)pairingDidComplete:(BOOL)success error:(NSError *)error{
    NSLog(@"Pairing Did Complete: %d",success);
    
    if (success) {
        User *user = (User *)[[AuthManager defaultManager] currentCredentials];
        user.isPaired = @1;
        [user saveLocal];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ConnectedMasterPass" object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MasterPassConnectionCancelled" object:nil];
    }
}

-(void)checkoutDidComplete:(BOOL)success error:(NSError *)error{
    NSLog(@"Checkout Did Complete: %d",success);
    
    if (success) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MasterPassCheckoutComplete" object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MasterPassCheckoutCancelled" object:nil];
    }
}

-(void)preCheckoutDidComplete:(BOOL)success data:(NSDictionary *)data error:(NSError *)error{
    NSLog(@"PreCheckout Did Complete: %d",success);
    
    if (success) {
        User *user = (User *)[[AuthManager defaultManager] currentCredentials];
        user.isPaired = @1;
        [user saveLocal];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MasterPassPreCheckoutComplete" object:nil userInfo:data];
    }
    else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MasterPassPreCheckoutCancelled" object:nil userInfo:data];
    }
}

- (void)pairCheckoutDidComplete:(BOOL)success error:(NSError *)error{
    NSLog(@"Pair Checkout Did Complete: %d",success);
    
    if (success) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MasterPassCheckoutComplete" object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MasterPassCheckoutCancelled" object:nil];
    }
}

- ( BOOL)isAppPaired{
    return [((User *)[[AuthManager defaultManager]currentCredentials]).isPaired boolValue];
}

- (void)resetUserPairing{
    User *currentUser = ((User *)[[AuthManager defaultManager]currentCredentials]);
    currentUser.isPaired = @0;
    [currentUser saveLocal];
}

- (NSArray *)supportedDataTypes{
    return @[DataTypeCard,DataTypeAddress,DataTypeProfile];
}

- (NSArray *)supportedCardTypes{
    return @[CardTypeAmex,CardTypeDiscover,CardTypeMasterCard,CardTypeMaestro];
}

@end
