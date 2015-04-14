//
//  LoginViewController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginViewController.h"
#import "UIHelper.h"
@interface LoginViewController ()

@end

@implementation LoginViewController{
    TextFieldWrapper *usernameWrapper;
    TextFieldWrapper *passwordWrapper;
    UIActivityIndicatorView *activityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"login_txt", nil);
    NSLog([[UIDevice currentDevice] name]);
    NSString *name = [[UIDevice currentDevice] name];
    if(![name isEqualToString:@"Simen sin iPhone"]){
        self.usernameTextField.text = @"christiandalsvaag";
        self.passwordTextField.text = @"christiandalsvaag";
    }
    
    [UIHelper applyLayoutOnButton:self.loginButton];
    
    verticalSpaceConstraintButton = self.loginButtonVerticalSpace;
    
    usernameWrapper = [[TextFieldWrapper alloc] init:self.usernameTextField withView:self.usernameTextFieldView];
    passwordWrapper = [[TextFieldWrapper alloc] init:self.passwordTextField withView:self.passwordTextFieldView];


    //loginController = [[LoginController alloc] init];
    self.passwordTextField.placeholder = NSLocalizedString(@"password_pla", nil);
    self.usernameTextField.placeholder = NSLocalizedString(@"username_pla", nil);
       [self.loginButton setTitle:NSLocalizedString(@"login_txt", nil) forState:UIControlStateNormal];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    [self setTextFieldStyle:self.usernameTextField];
    [self setTextFieldStyle:self.passwordTextField];
    
   self.loginButton.hidden = YES;
    
    [self.usernameTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self
                              action:@selector(textFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
    [self setPlaceholderFont:self.usernameTextField];
    [self setPlaceholderFont:self.passwordTextField];
    //[self showLogin];

}
-(void)viewDidAppear:(BOOL)animated{
    [self.usernameTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.usernameTextField){
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    else if(textField == self.passwordTextField){
        [self loginAction:nil];
        [self.passwordTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textFieldDidChange:(UITextField *) textField{
    [self showLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLogin{
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    if(username.length > 0 && password.length > 0){
        self.loginButton.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.loginButton.alpha = 1;
        }];
    }
    else if(username.length == 0 || password.length == 0){
        self.loginButton.hidden = YES;
        self.loginButton.alpha =0;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginAction:(id)sender {
    usernameWrapper.constraint = self.usernameTextFieldViewHeight;
    passwordWrapper.constraint = self.passwordTextFieldViewHeight;
    [usernameWrapper showError:@"test"];
    [passwordWrapper showError:@"test2"];
}

-(void)startIndicatorSpinning{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.loginButton addSubview:activityIndicator];
    [self.loginButton setTitle:@"" forState:UIControlStateNormal];
    activityIndicator.center = CGPointMake(self.loginButton.frame.size.width / 2, self.loginButton.frame.size.height / 2);
    [activityIndicator startAnimating];
}

-(void)stopIndicatorSpinning{
    [activityIndicator stopAnimating];
    [self.loginButton setTitle:NSLocalizedString(@"login_txt", nil) forState:UIControlStateNormal];
}
@end
