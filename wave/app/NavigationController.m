//
//  NavigationController.m
//  wave
//
//  Created by Simen Lie on 30.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "NavigationController.h"
#import "ColorHelper.h"
@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationBar setTintColor:[ColorHelper purpleColor]];
    [self.navigationBar setBackgroundColor:[ColorHelper purpleColor]];
    // Do any additional setup after loading the view.
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationBar.barTintColor = [ColorHelper purpleColor];
        self.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationBar.tintColor = [ColorHelper purpleColor];
    }
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
