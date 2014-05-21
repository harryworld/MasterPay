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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
@end
