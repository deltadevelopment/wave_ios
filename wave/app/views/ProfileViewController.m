//
//  ProfileViewController.m
//  wave
//
//  Created by Simen Lie on 22.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfileViewController.h"
#import "AuthHelper.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    AuthHelper *authHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.tableView = [[UITableView alloc] initWithFrame:CGRECtma]
    // Do any additional setup after loading the view.
}

-(void)initialize{
   // http://w4ve.herokuapp.com/user/2/buckets
    authHelper = [[AuthHelper alloc] init];
    NSString *url = [NSString stringWithFormat:@"user/%@/buckets", [authHelper getUserId]];
    self.feedModel = [[FeedModel alloc] initWithURL:url];
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
