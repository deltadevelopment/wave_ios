//
//  StartViewController.m
//  wave
//
//  Created by Simen Lie on 13/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "StartViewController.h"
#import "UIHelper.h"
@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [UIHelper applyLayoutOnButton:self.loginButton];
    [UIHelper applyLayoutOnButton:self.signupButton];
    [self.loginButton setTitle:NSLocalizedString(@"login_btn_cap", nil) forState:UIControlStateNormal];
    [self.signupButton setTitle:NSLocalizedString(@"signup_btn_cap", nil) forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];
    NSLog(@"init");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
