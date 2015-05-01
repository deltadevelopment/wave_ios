//
//  PeekViewController.m
//  wave
//
//  Created by Simen Lie on 27.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "PeekViewController.h"
#import "UIHelper.h"
@interface PeekViewController ()

@end

@implementation PeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.location.text = @"Kristiansand";
    self.displayName.text = @"Anna Holm";
    self.profilePicture.layer.cornerRadius = 50;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    self.availability.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor redColor];
    self.availability.clipsToBounds = YES;
    self.subscribeButton.alpha = 0.0;
    [UIHelper applyThinLayoutOnLabel:self.displayName withSize:24.0];
    [UIHelper applyThinLayoutOnLabel:self.location withSize:17.0];
    
    [[self.subscribeButton layer] setBorderWidth:1.0f];
    [[self.subscribeButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.subscribeButton.layer.cornerRadius = 10;
    self.subscribeButton.clipsToBounds = YES;
    [self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
    self.subscribeVerticalconstraint.constant += 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
