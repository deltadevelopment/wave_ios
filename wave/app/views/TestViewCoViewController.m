//
//  TestViewCoViewController.m
//  wave
//
//  Created by Simen Lie on 13.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "TestViewCoViewController.h"
#import "AvailabilityViewController.h"
@interface TestViewCoViewController ()

@end

@implementation TestViewCoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AvailabilityViewController *viewControllerX = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    [self attachViews:viewControllerX withY:nil];
    // Do any additional setup after loading the view.
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
