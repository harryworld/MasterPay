//
//  LogInViewController.m
//  MasterPass
//
//  Created by David Benko on 5/13/14.
//  Copyright (c) 2014 David Benko. All rights reserved.
//

#import "LogInViewController.h"
#import "ProductsListViewController.h"
#import "DrawerViewController.h"
#import "ICSDrawerController/ICSDrawerController.h"
#import "AppDelegate.h"
#import <M13Checkbox/M13Checkbox.h>
#import <BButton/BButton.h>
#import "BaseNavigationController.h"
#import <APSDK/User+Remote.h>
#import <APSDK/APObject+Remote.h>
#import <APSDK/AuthManager+Protected.h>
#import "UserRegistrationViewController.h"

@interface LogInViewController ()
@property(nonatomic, weak)IBOutlet UIView *container;
@property(nonatomic, weak)IBOutlet UIView *usernameContainer;
@property(nonatomic, weak)IBOutlet UIView *passwordContainer;
@property(nonatomic, weak)IBOutlet UIView *fbLink;
@property(nonatomic, weak)IBOutlet UIView *twLink;
@property(nonatomic, weak)IBOutlet UILabel *rememberLabel;
@property(nonatomic, weak)IBOutlet UIButton *registerLabel;
@property(nonatomic, weak)IBOutlet UIImageView *usernameImage;
@property(nonatomic, weak)IBOutlet UIImageView *passwordImage;
@property(nonatomic, weak)IBOutlet UIImageView *fbImage;
@property(nonatomic, weak)IBOutlet UIImageView *twImage;
@property(nonatomic, weak)IBOutlet UITextField *usernameField;
@property(nonatomic, weak)IBOutlet UITextField *passwordField;
@property(nonatomic, strong) M13Checkbox *rememberPassword;
@property(nonatomic, weak)IBOutlet BButton *signInButton;
@end
@implementation LogInViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor deepBlueColor]];
    [self.fbLink setBackgroundColor:[UIColor facebookBlue]];
    [self.twLink setBackgroundColor:[UIColor twitterBlue]];
    [self.container.layer setCornerRadius:4];
    [self.rememberLabel setTextColor:[UIColor superGreyColor]];
    [self.registerLabel setTitleColor:[UIColor fireOrangeColor] forState:UIControlStateNormal];
    
    [self.usernameContainer setBackgroundColor:[UIColor whiteColor]];
    [self.usernameContainer.layer setCornerRadius:4];
    [self.usernameContainer.layer setBorderColor:[[UIColor fireOrangeColor] CGColor]];
    [self.usernameContainer.layer setBorderWidth:1];
    [self.passwordContainer setBackgroundColor:[UIColor whiteColor]];
    [self.passwordContainer.layer setCornerRadius:4];
    [self.passwordContainer.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.passwordContainer.layer setBorderWidth:1];
    
    
    self.usernameField.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    
    FAKFontAwesome *usernameIcon = [FAKFontAwesome userIconWithSize:20];
    [usernameIcon addAttribute:NSForegroundColorAttributeName value:[UIColor fireOrangeColor]];
    self.usernameImage.image = [usernameIcon imageWithSize:CGSizeMake(20, 20)];
    
    FAKFontAwesome *passwordIcon = [FAKFontAwesome keyIconWithSize:20];
    [passwordIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    self.passwordImage.image = [passwordIcon imageWithSize:CGSizeMake(20, 20)];
    
    
    FAKFontAwesome *facebookIcon = [FAKFontAwesome facebookIconWithSize:20];
    [facebookIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    self.fbImage.image = [facebookIcon imageWithSize:CGSizeMake(20, 20)];
    
    FAKFontAwesome *twitterIcon = [FAKFontAwesome twitterIconWithSize:20];
    [twitterIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    self.twImage.image = [twitterIcon imageWithSize:CGSizeMake(20, 20)];
    
    [self.fbLink bk_whenTapped:^{
        [self socialLoginAlert];
    }];
    
    [self.twLink bk_whenTapped:^{
        [self socialLoginAlert];
    }];
    
    self.rememberPassword = [[M13Checkbox alloc]init];
    self.rememberPassword.checkState = M13CheckboxStateChecked;
    [self.rememberPassword setFrame:CGRectMake(30, 150, 10, 10)];
    self.rememberPassword.checkColor = [UIColor blackColor];
    self.rememberPassword.strokeColor = [UIColor superGreyColor];
    [self.container addSubview:self.rememberPassword];
    
    [self.signInButton bk_addEventHandler:^(id sender) {
        [self authenticate];
    } forControlEvents:UIControlEventTouchUpInside];
}

-(void)authenticate{
    // Demo Code
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([self.rememberPassword checkState] == M13CheckboxStateChecked) {
        [prefs setObject:self.usernameField.text forKey:@"username"];
    }
    else {
        [prefs removeObjectForKey:@"username"];
    }
    [prefs synchronize];
    [self login];
}

-(void)socialLoginAlert{
    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Social Login" andMessage:@"You can add code here to authenticate via social networks"];
    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alert show];
}

-(IBAction)registerUser{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle: nil];
    
    UserRegistrationViewController *registerView = [storyboard instantiateViewControllerWithIdentifier:@"RegisterView"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:registerView];
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(IBAction)login{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *user = [User new];
    user.email = self.usernameField.text;
    user.password = self.passwordField.text;
    [[AuthManager defaultManager] signInAs:user async:^(APObject<Authorizable> *object, NSError *error) {
        if (error) {
            SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Error" andMessage:[error localizedDescription]];
            [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
            alert.transitionStyle = SIAlertViewTransitionStyleBounce;
            [alert show];
        }
        else {
            MPManager *manager = [MPManager sharedInstance];
            if ([manager isAppPaired]) {
                [manager precheckoutDataCallback:^(NSArray *cards, NSArray *addresses, NSDictionary *contactInfo, NSDictionary *walletInfo, NSError *error) {
                    // Hack to force pairing status reload.
                    // This can be replaced once there is a
                    // public pairing status check against MasterPass
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self setupDrawerAndShop];
                }];
            }
        }
    }];
}

-(IBAction)setupDrawerAndShop{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle: nil];
    
    BaseNavigationController *products = [storyboard instantiateViewControllerWithIdentifier:@"ProductsList"];
    
    DrawerViewController *drawer = [[DrawerViewController alloc] init];
    
    ICSDrawerController *drawerController = [[ICSDrawerController alloc] initWithLeftViewController:drawer
                                                                               centerViewController:products];
    
    
    
    // Animate root view change
    [UIView
     transitionWithView:ad.window
     duration:0.25
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         ad.window.rootViewController = drawerController;
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
}
@end
