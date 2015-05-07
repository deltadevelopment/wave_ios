//
//  CameraHelper.h
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface CameraHelper : NSObject{
    AVCaptureStillImageOutput * stillImageOutput;
    AVCaptureVideoDataOutput * videoImageOutput;
    UIImage *imgTaken;
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    bool frontFacing;
    UIView *view;
    
    //Video
    AVCaptureSession *CaptureSession;
    AVCaptureMovieFileOutput *MovieFileOutput;
    AVCaptureDeviceInput *VideoInputDevice;
    SEL mediaSuccessSelector;
    NSObject *mediaSuccessObject;
    
    
}
-(void)stopCameraSession;
-(AVCaptureVideoPreviewLayer *)getLayer;
-(void)setSquare:(bool) theSquare;
-(void)cancelSession;
- (void) capImage:(NSObject *) object withSuccess:(SEL) success;
-(NSData*)getLastRecordedVideo;
-(void)setMediaDoneSelector:(SEL) successSelector
                 withObject:(NSObject*) object;
@property (retain) AVCaptureVideoPreviewLayer *PreviewLayer;
- (void)StartStopRecording;
-(void)initaliseVideo:(bool)rearCamera;
- (void)CameraToggleButtonPressed:(bool)isFrontCamera;
-(void)setView:(UIView *)videoView withRect:(CGRect) rect;
-(UIView*)getView;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage;
@end
