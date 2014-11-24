//
//  MPPairingViewController.m
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "MPLightboxViewController.h"

@interface MPLightboxViewController ()
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, assign) MPLightBoxType type;
@end

@implementation MPLightboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webview = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
}

- (void)initiateLightBoxOfType:(MPLightBoxType)type WithOptions:(NSDictionary *)options{
    self.options = options;
    self.type = type;
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"mp_lightbox_base" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:htmlString baseURL:nil];
}

-(void) checkIfLoadDone:(UIWebView *) webView {
    if (webView.loading) { return; }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.options
                                                       options:0
                                                         error:&error];
    
    if (error) {
        NSLog(@"JSON Parse Error: %@", [error localizedDescription]);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        int type = self.type;
        if (self.type == MPLightBoxTypePreCheckout) {
            type = 1; // Hacks for now TODO
        }
        
        NSString *command = [NSString stringWithFormat:@"initiateLightbox(%d, %@);", type, jsonString];
        
        NSLog(@"%@",command);
        
        [webView stringByEvaluatingJavaScriptFromString:command];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *currentUrl = request.URL;
    NSString *currentUrlString = [NSString stringWithFormat:@"%@://%@%@",currentUrl.scheme,currentUrl.host,currentUrl.path];
    
    if ([currentUrlString isEqualToString:[self.options objectForKey:@"callbackUrl"]]) {
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
                    NSLog(@"Error: %@",[jsonError localizedDescription]);
                }
                else {
                    NSLog(@"Callback Success: %@",json);
                    
                    BOOL success = [json[@"status"] isEqualToString:@"success"];
                    if (self.type == MPLightBoxTypeConnect) {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(pairingView:didCompletePairing:error:)]) {
                            [self.delegate pairingView:self didCompletePairing:success error:error];
                        }
                    }
                    else if (self.type == MPLightBoxTypeCheckout) {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(lightBox:didCompleteCheckout:error:)]) {
                            [self.delegate lightBox:self didCompleteCheckout:success error:error];
                        }
                    }
                    else if (self.type == MPLightBoxTypePreCheckout){
                        if (self.delegate && [self.delegate respondsToSelector:@selector(lightBox:didCompletePreCheckout:data:error:)]) {
                            [self.delegate lightBox:self didCompletePreCheckout:success data:json error:error];
                        }
                    }
                }
                
            }
            
        }];
        
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self performSelector:@selector(checkIfLoadDone:)
               withObject:webView
               afterDelay:0.5];
}

@end
