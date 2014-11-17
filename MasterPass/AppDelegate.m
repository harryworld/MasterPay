//
//  AppDelegate.m
//  MasterPass
//
//  Created by David Benko on 4/22/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "AppDelegate.h"
#import <APSDK/APObject+Remote.h>
#import <APSDK/AuthManager+Protected.h>

@implementation AppDelegate

static const NSString * server = @"https://mysterious-beyond-8033.herokuapp.com";
static const NSString * version = @"/api/v9/";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
        
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
