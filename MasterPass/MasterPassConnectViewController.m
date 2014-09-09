//
//  MasterPassConnectViewController.m
//  MasterPass
//
//  Created by David Benko on 4/28/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "MasterPassConnectViewController.h"
#import "CardManager.h"

@interface MasterPassConnectViewController ()
@property(nonatomic, weak) IBOutlet UIWebView *webview;
@end

@implementation MasterPassConnectViewController

#pragma mark - UIViewController methods
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.webview.delegate = self;
    
    NSString *file = self.checkoutAuth ? @"mp_password" : @"mp_wallet";
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:file ofType:@"html" inDirectory:@"public"]];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

-(IBAction)done{
    [self dismissViewControllerAnimated:YES completion:^{
        NSNotification* notification = [NSNotification notificationWithName:@"ConnectedMasterPass" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        CardManager *manager = [CardManager getInstance];
        manager.wantsDelayedPair = YES;
    }];
}
-(IBAction)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webview{
    
    /*
     * We have successfully paired!
     * Add code to confirm pairing here
     */
    
    CardManager *manager = [CardManager getInstance];
    
    NSString *command = [NSString stringWithFormat:@"updatePage({\"express\":%@,\"checkout\":%@,\"profile\":%@,\"paired\":%@});",stringForBool(manager.isExpressEnabled),stringForBool(self.checkoutAuth),stringForBool(self.profileAuth),stringForBool(manager.isLinkedToMasterPass)];
    
    NSLog(@"%@",command);
    
    [webview stringByEvaluatingJavaScriptFromString:command];
    
}

NSString* stringForBool(BOOL option){
    return option ? @"true" : @"false";
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.scheme isEqualToString:@"masterpass"]){
        if ([request.URL.host isEqualToString:@"pair"]) {
            [self pair];
        }
        else if([request.URL.host isEqualToString:@"checkout"]){
            [self authorizeCheckout];
        }
        
        return NO;
    }
    return YES;
}

-(void)pair{
    [self done];
}
-(void)authorizeCheckout{
    [self done];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfirmOrder" object:nil];
}
@end
