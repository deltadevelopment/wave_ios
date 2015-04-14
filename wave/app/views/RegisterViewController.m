//
//  RegisterViewController.m
//  wave
//
//  Created by Simen Lie on 13/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RegisterViewController.h"
#import "ColorHelper.h"
#import "UIHelper.h"
#import "ApplicationController.h"
#import "RegisterController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController{
    TextFieldWrapper *usernameWrapper;
    TextFieldWrapper *emailWrapper;
    TextFieldWrapper *passwordWrapper;
    UIActivityIndicatorView *activityIndicator;
    RegisterController *registerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    registerController =[[RegisterController alloc] init];
    verticalSpaceConstraintButton = self.verticalSpaceButtonConstraint;
    usernameWrapper = [[TextFieldWrapper alloc] init:self.usernameTextField withView:self.usernameTextFieldView];
    emailWrapper = [[TextFieldWrapper alloc] init:self.emailTextField withView:self.emailTextFieldView];
    passwordWrapper = [[TextFieldWrapper alloc] init:self.passwordTextField withView:self.passwordTextFieldView];
    
    self.emailTextField.placeholder = NSLocalizedString(@"email_pla", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"password_pla", nil);
    self.usernameTextField.placeholder = NSLocalizedString(@"username_pla", nil);
    [self.registerButton setTitle:NSLocalizedString(@"register_txt", nil) forState:UIControlStateNormal];
    [UIHelper applyLayoutOnButton:self.registerButton];
 
    self.registerButton.hidden = YES;
  
    [self setTextFieldStyle:self.usernameTextField];
    [self setTextFieldStyle:self.emailTextField];
    [self setTextFieldStyle:self.passwordTextField];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.emailTextField.delegate = self;
    
    [self.usernameTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.emailTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    
    [self setPlaceholderFont:self.usernameTextField];
    [self setPlaceholderFont:self.passwordTextField];
    [self setPlaceholderFont:self.emailTextField];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"register_txt", nil);
    // Do any additional setup after loading the view.
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChange:(UITextField *) textField{
    [usernameWrapper removeErrorAndText];
    [emailWrapper removeErrorAndText];
    [passwordWrapper removeErrorAndText];
    [self showRegister];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.usernameTextField becomeFirstResponder];
}
-(void)showRegister{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;
    if(username.length > 0 && password.length > 0 && email.length > 0){
        self.registerButton.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.registerButton.alpha = 1;
        }];
    }
    else if(username.length == 0 || password.length == 0 || email.length == 0){
        self.registerButton.hidden = YES;
        self.registerButton.alpha =0;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == self.usernameTextField){
        [self.usernameTextField resignFirstResponder];
        [self.emailTextField becomeFirstResponder];
        return YES;
    }
    else if(textField == self.emailTextField){
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    else if(textField == self.passwordTextField){
        [self registerAction:nil];
        [self.passwordTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)registerWasSuccessful:(NSData *) data{
    NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    [self.regIndicator stopAnimating];
    /*
    [loginController login:self.usernameTextField.text
                      pass:self.passwordTextField.text
                withObject:self
               withSuccess:@selector(loginWasSuccessful:)
                 withError:@selector(loginWasNotSuccessful:)];
     */
    
}

-(void)loginWasSuccessful:(NSData *) data{
    /*
    [self.regIndicator stopAnimating];
    [loginController storeCredentials:data];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedViewController *viewController = (FeedViewController *)[storyboard instantiateViewControllerWithIdentifier:@"feed2"];
    [self presentViewController:viewController animated:YES completion:nil];
     */
}

-(void)loginWasNotSuccessful:(NSError *) error{
    [self.regIndicator stopAnimating];
    [self errorAnimation];
    ApplicationController *appCntrl = [[ApplicationController alloc]init];
    [appCntrl getHttpRequest:@"string" onCompletion:^(NSURLResponse *resp,NSData *data,NSError *error){
        
    }];
}


- (IBAction)registerAction:(id)sender {
    [self startIndicatorSpinning];
    usernameWrapper.constraint = self.usernameTextFieldViewHeight;
    emailWrapper.constraint = self.emailTextFieldViewHeight;
    passwordWrapper.constraint = self.passwordTestFieldViewHeight;
    
    [registerController registerUser:self.usernameTextField.text
                                pass:self.passwordTextField.text
                               email:self.emailTextField.text
                        onCompletion:^(UserModel *user, ResponseModel *response){
                            [self stopIndicatorSpinning];
                            if(response.success){
                                //login
                            }else{
                                NSString *usernameError = [[response.error objectForKey:@"username"] objectAtIndex:0];
                                NSString *emailError = [[response.error objectForKey:@"email"] objectAtIndex:0];
                                NSString *passwordError = [[response.error objectForKey:@"password"] objectAtIndex:0];
                                usernameError != nil ? [usernameWrapper showError:usernameError] : nil;
                                emailError != nil ? [emailWrapper showError:emailError] : nil;
                                passwordError != nil ? [passwordWrapper showError:passwordError] : nil;
                            }
                            
                        }];
    /*
     [registerController registerUser:self.usernameTextField.text
     pass:self.passwordTextField.text
     email:self.emailTextField.text
     withObject:self
     withSuccess:@selector(registerWasSuccessful:)
     withError:@selector(registerWasNotSuccessful:)];
     */
/*
    [usernameWrapper showError:@"Brukernavnet er for kort"];
    [passwordWrapper showError:@"passordet er altfor dårlig altså"];
    [emailWrapper showError:@"emailen er i bruk"];
 */
    //[self startIndicatorSpinning];
    //[self stopIndicatorSpinning];
}

-(void)startIndicatorSpinning{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.registerButton addSubview:activityIndicator];
    [self.registerButton setTitle:@"" forState:UIControlStateNormal];
    activityIndicator.center = CGPointMake(self.registerButton.frame.size.width / 2, self.registerButton.frame.size.height / 2);
    [activityIndicator startAnimating];
}

-(void)stopIndicatorSpinning{
    [activityIndicator stopAnimating];
    [self.registerButton setTitle:NSLocalizedString(@"register_txt", nil) forState:UIControlStateNormal];
}
@end
