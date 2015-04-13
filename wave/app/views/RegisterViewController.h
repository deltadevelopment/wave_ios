//
//  RegisterViewController.h
//  wave
//
//  Created by Simen Lie on 13/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperLoginViewController.h"
@interface RegisterViewController : SuperLoginViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *usernameError;
@property (weak, nonatomic) IBOutlet UILabel *passwordError;
@property (weak, nonatomic) IBOutlet UILabel *emailError;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *regIndicator;
@property (weak, nonatomic) IBOutlet UIView *usernameTextFieldView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameTextFieldViewHeight;
@property (weak, nonatomic) IBOutlet UIView *emailTextFieldView;
@property (weak, nonatomic) IBOutlet UIView *passwordTextFieldView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTestFieldViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailTestFieldViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailTextFieldViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceButtonConstraint;


- (IBAction)registerAction:(id)sender;

@end
