//
//  RepowerViewController.h
//  MasterPass
//
//  Created by Harry Ng on 21/3/15.
//  Copyright (c) 2015 David Benko. All rights reserved.
//

#import "BaseViewController.h"

@interface RepowerViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UITextField *amountToBeAdded;
@property (weak, nonatomic) IBOutlet UITextField *codeToBeUsed;

- (IBAction)submitButtonClicked:(id)sender;

@end
