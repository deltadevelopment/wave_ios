//
//  LoginViewController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginViewController.h"
#import "UIHelper.h"
#import "LoginController.h"
#import "UserModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController{
    TextFieldWrapper *usernameWrapper;
    TextFieldWrapper *passwordWrapper;
    UIActivityIndicatorView *activityIndicator;
    LoginController *loginController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loginController = [[LoginController alloc]init];
     self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"login_txt", nil);
    NSLog(@"%@", [[UIDevice currentDevice] name]);
    NSString *name = [[UIDevice currentDevice] name];
    if(![name isEqualToString:@"Simen sin iPhone"]){
        self.usernameTextField.text = @"christiandalsvaag";
        self.passwordTextField.text = @"christiandalsvaag";
    }else{
        self.usernameTextField.text = @"simenlie";
        self.passwordTextField.text = @"simenlie";
    }
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
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
    [self showLogin];

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
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField becomeFirstResponder];
    [self.view endEditing:YES];
    [self startIndicatorSpinning];
    usernameWrapper.constraint = self.usernameTextFieldViewHeight;
    passwordWrapper.constraint = self.passwordTextFieldViewHeight;
    [loginController login:self.usernameTextField.text pass:self.passwordTextField.text onCompletion:^(UserModel *user, ResponseModel *response){
        [self stopIndicatorSpinning];
        loginController.isLoggingIn = NO;
        if(response.success){
            //login
            response.success ? [self showMainView] : nil;
        }else{
            /*
            NSString *usernameError = [[response.error objectForKey:@"username"] objectAtIndex:0];
            NSString *passwordError = [[response.error objectForKey:@"password"] objectAtIndex:0];
            usernameError != nil ? [usernameWrapper showError:usernameError] : nil;
            passwordError != nil ? [passwordWrapper showError:passwordError] : nil;
            */
            //[self errorAnimation];
            notificationHelper =[[NotificationHelper alloc] initNotification];
            [notificationHelper setNotificationMessage:response.message];
            [notificationHelper addNotificationToView:self.navigationController.view];
        }
        
    } onError:^(NSError * error){
        NSLog(@"ERROR");
        NSLog(@"the dic is %@", [error userInfo]);
        loginController.isLoggingIn = NO;
        ResponseModel *responseModel = [[ResponseModel alloc] init:[NSMutableDictionary dictionaryWithDictionary:error.userInfo]];
        NSLog(@"the dic is %@", responseModel.message);
        notificationHelper =[[NotificationHelper alloc] initNotification];
        [notificationHelper setNotificationMessage:responseModel.message];
        [notificationHelper addNotificationToView:self.navigationController.view];
        [self stopIndicatorSpinning];
      self.loginButton.hidden = YES;

    }];
    
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
