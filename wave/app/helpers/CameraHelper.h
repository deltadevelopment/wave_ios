//
//  CameraHelper.h
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>
#import <ImageIO/ImageIO.h>


@interface CameraHelper : NSObject<AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) NSData *lastRecordedVideoCompressed;
@property (nonatomic) bool isCompressed;
@property (nonatomic, copy) void (^onVideoRecorded)(NSData*(video));
@property (nonatomic, copy) void (^onVideoPrepareForPlayback)(void);
@property (nonatomic, copy) void (^onMediaSavedToDisk)(void);
@property (nonatomic, copy) void (^onMediaSavedToDiskError)(void);

@property (nonatomic, copy) void (^onMediaRenderCompleted)(void);

@property (nonatomic) bool recording;
@property (nonatomic, strong) AVCaptureDevice *VideoDevice;
@property (nonatomic) AVCaptureDevicePosition position;
@property (nonatomic, strong) UIView *CameraView;

@property (nonatomic, strong)NSData *lastRecordedVideo;

@property (nonatomic, strong)NSURL *lastRecordedVideoURL;
@property (nonatomic, retain)AVCaptureVideoPreviewLayer *PreviewLayer;


@property (nonatomic, strong)AVCaptureDevice *frontFacingDevice;
@property (nonatomic, strong)NSDictionary *outputSettings;
@property (nonatomic) bool square;

@property (nonatomic, strong) AVCaptureSession *CaptureSession2;

@property (nonatomic) bool isInitialised;

@property (nonatomic, strong)UIImage *imgTaken;


@property (nonatomic) bool frontFacing;
@property (nonatomic, retain) AVCaptureConnection *videoConnection;

@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) AVCaptureDeviceInput *VideoInputDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *FrontFacingInputDevice;

@property (nonatomic, strong) AVCaptureDevice *audioCaptureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) AVAsset *videoAsset;
-(void)initaliseLightVideo:(bool)rearCamera withView:(UIView *) view;

-(void)stopCameraSession;
//-(void) capImage:(NSObject *) object withSuccess:(SEL) success;
- (void) capImage:(NSObject *) object withSuccess:(SEL) success;
-(NSData*)getLastRecordedVideo;
-(void)initaliseVideo:(bool)rearCamera withView:(UIView *) view;
- (void)CameraToggleButtonPressed:(bool)isFrontCamera;
-(void)startRecording;
-(void)startPreviewLayer;
-(void)stopRecording;
-(void)addImageOutput;
-(NSData*)getlastRecordedVideoCompressed;
-(void)saveImageToDisk;
-(void)saveImageToDisk:(UIImage *) image;
-(void)initRecording;
-(bool)sessionIsRunning;
-(void)saveVideoToDisk;
-(void)startD:(UIView *) view toDisk:(bool) isToDisk withURL:(NSURL *) url;
-(NSData *)getVideoWithCaption;
@end
