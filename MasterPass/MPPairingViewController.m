//
//  MPPairingViewController.m
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "MPPairingViewController.h"

@interface MPPairingViewController ()
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) NSDictionary *pairingDetails;
@end

@implementation MPPairingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webview = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
}

- (void)startPairWithDetails:(NSDictionary *)pairingDetails{
    self.pairingDetails = pairingDetails;
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"mppairing_base" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSURL *currentUrl = webView.request.URL;
    NSString *currentUrlString = [NSString stringWithFormat:@"%@://%@%@",currentUrl.scheme,currentUrl.host,currentUrl.path];
    
    if ([currentUrlString isEqualToString:[self.pairingDetails objectForKey:@"callback_url"]]) {
        
        NSMutableDictionary *queryStrings = [[NSMutableDictionary alloc] init];
        for (NSString *qs in [webView.request.URL.query componentsSeparatedByString:@"&"]) {
            // Get the parameter name
            NSString *key = [[qs componentsSeparatedByString:@"="] objectAtIndex:0];
            // Get the parameter value
            NSString *value = [[qs componentsSeparatedByString:@"="] objectAtIndex:1];
            value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            queryStrings[key] = value;
        }
        
        BOOL success = [queryStrings objectForKey:@"mpsuccess"];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pairingView:didCompletePairing:error:)]) {
            [self.delegate pairingView:self didCompletePairing:YES error:nil];
        }
        return;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.pairingDetails
                                                       options:0
                                                         error:&error];
    
    if (error) {
        NSLog(@"JSON Parse Error: %@", [error localizedDescription]);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *command = [NSString stringWithFormat:@"requestTokenSuccess(%@);", jsonString];
        [webView stringByEvaluatingJavaScriptFromString:command];
    }
}

@end
