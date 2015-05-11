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
@property (nonatomic, copy) void (^onVideoTaken)(NSData*(videoTaken),UIImage*(imageTaken));
@property (nonatomic, copy) void (^onPictureDiscard)(void);
@property (nonatomic, copy) void (^onPictureUploading)(void);
@property (nonatomic, copy) void (^onCameraCancel)(void);
@property (nonatomic, copy) void (^onVideoRecorded)(void);

-(void)onTap:(NSNumber *) mode;
-(UIView *)getCameraView;
-(AVCaptureVideoPreviewLayer *)getLayer;
-(void)prepareCamera:(bool)rearCamera withReply:(bool)reply;
-(void)takePicture;
-(void)closeCamera;
-(void)startRecording;
-(void)stopRecording;
@end
