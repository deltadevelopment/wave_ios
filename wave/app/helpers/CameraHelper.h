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

@interface CameraHelper : NSObject<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) NSData *lastRecordedVideoCompressed;
@property (nonatomic) bool isCompressed;
@property (nonatomic, copy) void (^onVideoRecorded)(NSData*(video));
@property (nonatomic, copy) void (^onVideoPrepareForPlayback)(void);
@property (nonatomic, copy) void (^onMediaSavedToDisk)(void);
@property (nonatomic, copy) void (^onMediaSavedToDiskError)(void);

@property (nonatomic) bool recording;
@property (nonatomic, strong) AVCaptureDevice *VideoDevice;
@property (nonatomic) AVCaptureDevicePosition position;
@property (nonatomic, strong) UIView *CameraView;

@property (nonatomic, strong)NSData *lastRecordedVideo;

@property (nonatomic, strong)NSURL *lastRecordedVideoURL;
@property (nonatomic, retain)AVCaptureVideoPreviewLayer *PreviewLayer;
@property (nonatomic, retain)AVCaptureSession *CaptureSession;

@property (nonatomic, strong)AVCaptureDevice *frontFacingDevice;
@property (nonatomic, strong)NSDictionary *outputSettings;
@property (nonatomic) bool square;

@property (nonatomic, strong)AVCaptureStillImageOutput * stillImageOutput;

@property (nonatomic, strong)UIImage *imgTaken;


@property (nonatomic) bool frontFacing;
@property (nonatomic, retain) AVCaptureConnection *videoConnection;

@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) AVCaptureDeviceInput *VideoInputDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *FrontFacingInputDevice;

@property (nonatomic, strong) AVCaptureDevice *audioCaptureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;


-(void)stopCameraSession;
//-(void) capImage:(NSObject *) object withSuccess:(SEL) success;
-(void) captureNow:(NSObject *) object withSuccess:(SEL) success;
-(NSData*)getLastRecordedVideo;
-(void)initaliseVideo:(bool)rearCamera withView:(UIView *) view;
- (void)CameraToggleButtonPressed:(bool)isFrontCamera;
-(void)startRecording;

-(void)stopRecording;

-(NSData*)getlastRecordedVideoCompressed;
-(void)saveImageToDisk;

-(void)saveVideoToDisk;

@end
