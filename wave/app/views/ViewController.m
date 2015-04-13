//
//  ViewController.m
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ViewController.h"
#import "AvailabilityViewController.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AvailabilityViewController *vc = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    [self attachViews:vc withY:nil];
    
    
    //[self.testButton2 setTitle:NSLocalizedString(@"it_worked", nil) forState:UIControlStateNormal];
    
    [self.view insertSubview:self.camView atIndex:0];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareCamera{
    [self.camView insertSubview:self.camera.view atIndex:0];
}

-(void)onCameraOpen{
    [UIView animateWithDuration:2.3f
                     animations:^{
                         self.bottomConstraint.constant = 0;
                         [self.camView setNeedsDisplay];
                         [self.camView updateConstraints];
                         [self.camView setNeedsLayout];
                         [self.view updateConstraints];
                         [self.view setNeedsDisplay];
                         [self.view setNeedsLayout];
                         
                     }
                     completion:^(BOOL finished){
                         [super onCameraOpen];
                     }];
}

-(void)onCameraClose{
    [UIView animateWithDuration:2.3f
                     animations:^{
                         self.bottomConstraint.constant = 355;
                         [self.camView setNeedsDisplay];
                         [self.camView updateConstraints];
                         [self.view updateConstraints];
                         [self.view setNeedsDisplay];
                         
                     }
                     completion:^(BOOL finished){
                         [super onCameraClose];
                     }];
}
/*
-(void)onImageTaken:(UIImage *)image{
    NSLog(@"tatt");
    [self.camView setBackgroundColor:[UIColor grayColor]];
    [self.camView setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [self.camView setNeedsLayout];
    [self.camView setNeedsDisplay];
}

*/

@end
