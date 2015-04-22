//
//  InfoViewController.m
//  wave
//
//  Created by Simen Lie on 22/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "InfoViewController.h"
#import "UIHelper.h"
@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBlur:self.xLineView withRect:CGRectMake(0, 0, [UIHelper getScreenWidth] -36, 30)];
    [self addBlur:self.yLineView withRect:CGRectMake(0, 0, 30, [UIHelper getScreenHeight])];
    self.view.backgroundColor = [UIColor clearColor];
    //[self addBlur];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBlur:(UIView *) view withRect:(CGRect) frame{
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    view.alpha = 0.0;
    view.hidden = YES;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView  *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = frame;
    // blurEffectView.alpha = 0.9;
    //[view addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)addBlur{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView  *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    // blurEffectView.alpha = 0.9;
    [self.view addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
