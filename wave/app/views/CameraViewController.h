//
//  CameraViewController.h
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface CameraViewController : UIViewController
@property (nonatomic, copy) void (^onCameraReady)(void);
@property (nonatomic, copy) void (^onCameraOpen)(void);
@property (nonatomic, copy) void (^onCameraClose)(void);
@property (nonatomic, copy) void (^onImageReady)(void);
@property (nonatomic, copy) void (^onImageTaken)(UIImage*(imageTaken));

@property (nonatomic, copy) void (^onCameraCancel)(void);

-(void)onTap:(NSNumber *) mode;
-(UIView *)getCameraView;
-(AVCaptureVideoPreviewLayer *)getLayer;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage;
-(void)prepareCamera;
-(void)takePicture;
-(void)closeCamera;
@end
