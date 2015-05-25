//
//  AbstractFeedViewController.m
//  wave
//
//  Created by Simen Lie on 17/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "AbstractFeedViewController.h"

@interface AbstractFeedViewController ()

@end

@implementation AbstractFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)onCancelTap{}
-(void)onCameraOpen{}
-(void)onCameraReady{}
-(void)onFocusGained{}
-(void)prepareCamera:(UIView *)view{}
-(void)oncameraClose{}
-(void)onImageTaken:(UIImage *)image withText:(NSString *)text{};
-(void)onVideoTaken:(NSData *)video withImage:(UIImage *)image withtext:(NSString *)text{}

-(void)scrollUp{}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)increazeProgress:(int)progress
{

}

-(void)onMediaPosted:(BucketModel *)bucket{}
-(void)onMediaPostedDrop:(DropModel *)drop{}
-(void)setViewMode:(int)mode{}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
