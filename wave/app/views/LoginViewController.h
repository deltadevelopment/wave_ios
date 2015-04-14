//
//  LoginViewController.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperLoginViewController.h"
@interface LoginViewController : SuperLoginViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *usernameTextFieldView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameTextFieldViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonVerticalSpace;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordTextFieldView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldViewHeight;

@end
