//
//  ProfileViewController.m
//  wave
//
//  Created by Simen Lie on 22.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfileViewController.h"
#import "AuthHelper.h"
#import "PeekViewController.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    AuthHelper *authHelper;
    PeekViewController *peekViewController;
    ActivityViewController *activityController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.tableView = [[UITableView alloc] initWithFrame:CGRECtma]
    // Do any additional setup after loading the view.
 /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    peekViewController = (PeekViewController *)[storyboard instantiateViewControllerWithIdentifier:@"peekView"];
    activityController = [self.storyboard instantiateViewControllerWithIdentifier:@"activity"];
    [activityController setViewMode:1];
    [activityController setIsDeviceUser:YES];
    peekViewController.view.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);

    [peekViewController setActivityViewController:activityController]
        [peekViewController addBackgroundView];
    //[self.view addSubview:peekViewController.view];
    //[self.view insertSubview:peekViewController.view aboveSubview:blurEffectView];
    // peekViewController.view.backgroundColor = [UIColor clearColor];
    //[peekViewController updatePeekView:[bucket user]];
    
    
    //contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:peekViewController.view];
  */
}


-(void)initialize{
   // http://w4ve.herokuapp.com/user/2/buckets
    authHelper = [[AuthHelper alloc] init];
    NSString *url = [NSString stringWithFormat:@"user/%@/buckets", [authHelper getUserId]];
    //self.feedModel = [[FeedModel alloc] initWithURL:url];
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
