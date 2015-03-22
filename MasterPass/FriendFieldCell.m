//
//  FriendFieldCell.m
//  MasterPass
//
//  Created by Harry Ng on 21/3/15.
//  Copyright (c) 2015 David Benko. All rights reserved.
//

#import "FriendFieldCell.h"

@implementation FriendFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
        
        self.contentView.backgroundColor = [UIColor superLightGreyColor];
        self.textLabel.textColor = [UIColor steelColor];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectZero];
        self.textField.textColor = [UIColor steelColor];
        self.textField.font = [UIFont systemFontOfSize:13];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.textField];
        [self.textField makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.contentView);
            make.width.equalTo(@250);
            make.right.equalTo(self.contentView).with.offset(-padding.right);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.sendButton.frame = CGRectMake(200.0, 20.0, 80.0, 40.0);
        self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.sendButton addTarget:self action:@selector(sendMoney:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.sendButton];
    };
    return self;
}

- (IBAction)sendMoney:(id)sender
{
    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"Message" andMessage:@"You are transferring $100 to Harry"];
    [alert addButtonWithTitle:@"Cancel" type:SIAlertViewButtonTypeCancel handler:nil];
    [alert addButtonWithTitle:@"Confirm" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alert) {
        [self loadData];
        
        NSLog(@"Confirm");
    }];
    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alert show];
}

- (void)loadData
{
    NSString *serverAddress = [NSString stringWithFormat:@"http://desolate-river-6178.herokuapp.com"];
    NSString *fromNumber = @"5184680430000014";
    NSString *toNumber = @"5184680430000006";
    NSString *amount = @"100";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/moneysend/transfer/%@/%@/%@", serverAddress, fromNumber, toNumber, amount]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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
                dispatch_async (dispatch_get_main_queue(), ^{
                    NSString *value = [json objectForKey:@"value"];
                    
                    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"Success" andMessage:[NSString stringWithFormat:@"Transfer done to Harry: $%@", value]];
                    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
                    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
                    [alert show];
                });
            }
            
        }
    }];
}

@end
