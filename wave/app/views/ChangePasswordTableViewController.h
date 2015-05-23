//
//  ChangePasswordTableViewController.h
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperSettingsTableViewController.h"
@interface ChangePasswordTableViewController : SuperSettingsTableViewController<UITextFieldDelegate>
- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *repeatedPasswordField;


@end
