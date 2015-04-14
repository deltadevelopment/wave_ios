//
//  TestSuperViewController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "TestSuperViewController.h"

@interface TestSuperViewController ()

@end

@implementation TestSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                              target:self
                                                                              action:@selector(menuItemSelected)];
    [self.navigationItem setLeftBarButtonItem:self.menuItem];
}
-(void)addViewController:(SlideMenuViewController *) viewController{
    self.superController = viewController;
}

-(void)menuItemSelected
{
    [self.superController showDrawer];
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
