//
//  MasterPassConnectViewController.m
//  MasterPass
//
//  Created by David Benko on 4/28/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "MasterPassConnectViewController.h"

@interface MasterPassConnectViewController ()
@property(nonatomic, weak) IBOutlet UIWebView *webview;
@end

@implementation MasterPassConnectViewController

#pragma mark - UIViewController methods
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.webview.delegate = self;
    self.webview.userInteractionEnabled = YES;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL fileURLWithPath:self.path]];
    [self.webview loadRequest:request];
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
     * This is a hack to allow the user to tap the webview on the last 
     * page and close it. This functionality will be replaced with real
     * SDK methods, when those are available, which will hopefully
     * be using some sort of Obj-C/Javascript triggering.
     *
     */
    
    NSString *currentUrl = webview.request.mainDocumentURL.absoluteString;
    
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
    }
}
@end
