//
//  CameraViewController.m
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraHelper.h"
#import "UIHelper.h"
@interface CameraViewController ()

@end

@implementation CameraViewController{
    CameraHelper *cameraHelper;
    UIButton *selfieButton;
    bool cameraMode;
    bool frontFacingMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    selfieButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selfieButton setTitle:@"Selfie" forState:UIControlStateNormal];
    selfieButton.userInteractionEnabled = YES;
    [selfieButton addTarget:self action:@selector(flipCameraView:) forControlEvents:UIControlEventTouchDown];
   // selfieButton.frame = CGRectMake([UIHelper getScreenWidth]-60, 12, 50, 25);
  
    [selfieButton setTintColor:[UIColor whiteColor]];
    selfieButton.layer.borderWidth=1.0f;
    selfieButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    //[selfieButton setBackgroundImage:[UIImage imageNamed:@"bucket.png"] forState:UIControlStateNormal];
    cameraHelper = [[CameraHelper alloc]init];
    
}

-(void)viewDidAppear:(BOOL)animated{
    frontFacingMode = NO;
}

-(void)flipCameraView:(id)sender{
    frontFacingMode = frontFacingMode ? NO : YES;
    [cameraHelper CameraToggleButtonPressed:frontFacingMode];
}

-(void)addConstraintsToButton:(UIView *)view withButton:(UIButton *) button withPoint:(CGPoint) xy fromLeft:(bool) left fromTop:(bool) top{
    button.translatesAutoresizingMaskIntoConstraints = NO;
    if(left)
    {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeadingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:xy.x]];
        
    }else{
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:xy.x]];
    }
    
    if(top){
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTopMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:xy.y]];
    }
    
    else{
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottomMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:xy.y]];
    }
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
}

-(void)prepareCamera{
    [cameraHelper setView:self.view withRect:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    [cameraHelper initaliseVideo];
        [self.view addSubview:selfieButton];
    [self addConstraintsToButton:self.view withButton:selfieButton withPoint:CGPointMake(10, -50) fromLeft:NO fromTop:YES];
    self.onCameraReady();
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage{
    return [cameraHelper imageByScalingAndCroppingForSize:targetSize img:sourceImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTap{
    if(!cameraMode){
        cameraMode = YES;
        self.onCameraOpen();
    }else{
        [self takePicture];
        self.onCameraClose();
        cameraMode = NO;
    }
    
}

-(void)closeCamera{
    cameraMode = NO;
     self.onCameraClose();
    [cameraHelper stopCameraSession];
}

-(void)takePicture{
    [cameraHelper capImage:self withSuccess:@selector(imageWasTaken:)];
}

-(void)imageWasTaken:(UIImage *)image{
    NSLog(@"tatt bilde");
    self.onImageTaken(image);
}

-(UIView *)getCameraView{
    return [cameraHelper getView];
}

-(AVCaptureVideoPreviewLayer *)getLayer{
    return [cameraHelper getLayer];
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
