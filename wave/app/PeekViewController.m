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
    
    [UIHelper applyThinLayoutOnLabel:self.displayName withSize:24.0];
    [UIHelper applyThinLayoutOnLabel:self.location withSize:17.0];
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
