//
//  RepowerViewController.m
//  MasterPass
//
//  Created by Harry Ng on 21/3/15.
//  Copyright (c) 2015 David Benko. All rights reserved.
//

#import "RepowerViewController.h"

@interface RepowerViewController ()

@end

@implementation RepowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)submitButtonClicked:(id)sender
{
    [self loadData];
}

- (void)loadData
{
    [self.amountToBeAdded resignFirstResponder];
    [self.codeToBeUsed resignFirstResponder];
    
    self.balance.text = self.amountToBeAdded.text;
    
    NSString *serverAddress = [NSString stringWithFormat:@"http://desolate-river-6178.herokuapp.com"];
    
    NSString *amount = self.amountToBeAdded.text;
    if ([amount isEqualToString:@""]) {
        amount = @"500";
    }
    self.amountToBeAdded.text = @"";
    
    NSString *cardNumber = self.codeToBeUsed.text;
    if ([cardNumber isEqualToString:@""]) {
        cardNumber = @"5204740009900014";
    }
    self.codeToBeUsed.text = @"";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/repower/%@/%@", serverAddress, amount, cardNumber]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            NSLog(@"error: %@", error);
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&jsonError];
            if (jsonError) {
                NSLog(@"error: %@", jsonError);
            }
            else {
                self.balance.text = [json objectForKey:@"value"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
           }
            
        }
    }];
}

@end
