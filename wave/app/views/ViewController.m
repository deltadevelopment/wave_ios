//
//  ViewController.m
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ViewController.h"
#import "AvailabilityViewController.h"
#import "AuthHelper.h"
#import "StartViewController.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AvailabilityViewController *vc = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    [self attachViews:vc withY:nil];
    
    
    //[self.testButton2 setTitle:NSLocalizedString(@"it_worked", nil) forState:UIControlStateNormal];
    [self.camView removeFromSuperview];
    [self.view layoutIfNeeded];
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
        
        dispatch_async(main_queue, ^{
            
            [self.view insertSubview:self.camView atIndex:0];
            
        });
    });
   // [self.camView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    NSLog(@"hey");
   // [self.view insertSubview:self.camView atIndex:0];
   
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

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        // logout
        AuthHelper *authHelper = [[AuthHelper alloc]init];
        [authHelper resetCredentials];
        [self showStartView];
        
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

-(void)showStartView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StartViewController *viewController = (StartViewController *)[storyboard instantiateViewControllerWithIdentifier:@"startNav"];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
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
