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
    CameraHelper *camera;
    bool cameraMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    camera = [[CameraHelper alloc]init];
  // [self.view setBackgroundColor:[UIColor redColor]];
   // [self prepareCamera];
}

-(void)prepareCamera{
    [camera setView:self.view withRect:CGRectZero];
    [camera initaliseVideo];
    self.onCameraReady();
  
    
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage{
    return [camera imageByScalingAndCroppingForSize:targetSize img:sourceImage];
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

-(void)takePicture{
    [camera capImage:self withSuccess:@selector(imageWasTaken:)];
}

-(void)imageWasTaken:(UIImage *)image{
    NSLog(@"tatt bilde");
    self.onImageTaken(image);
}

-(UIView *)getCameraView{
    return [camera getView];
}

-(AVCaptureVideoPreviewLayer *)getLayer{
    return [camera getLayer];
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
