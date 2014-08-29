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
    
    NSString *command = [NSString stringWithFormat:@"updateLinks({\"express\":%@,\"checkout\":%@});",manager.isExpressEnabled ? @"true" : @"false",self.checkoutAuth ? @"true" : @"false"];
    
    NSLog(@"%@",command);
    
    [webview stringByEvaluatingJavaScriptFromString:command];
    
    /*NSString *currentUrl = webview.request.mainDocumentURL.absoluteString;
    
    NSArray *docs = @[@"mp3",@"mp4-express",@"mp5-express-checkout",@"mp4-checkout"]; // these are the end pages
    NSMutableArray *paths = [[NSMutableArray alloc]init];
    
    [docs each:^(NSString * doc) {
        [paths addObject:[[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:doc ofType:@"html"]] absoluteString]];
    }];
    
    if ([paths includes:currentUrl]) {
        // We are on an end page
        UIView *tapView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:tapView];
        [tapView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [tapView bk_whenTapped:^{
            [self done];
        }];
    }*/
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
