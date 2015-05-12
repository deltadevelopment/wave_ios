//
//  CameraViewController.h
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BucketModel.h"
#import "CameraHelper.h"
@interface CameraViewController : UIViewController<UITextFieldDelegate>{
CGSize keyboardSize;
}
@property (nonatomic, copy) void (^onCameraReady)(void);
@property (nonatomic, copy) void (^onCameraOpen)(void);
@property (nonatomic, copy) void (^onCameraClose)(void);
@property (nonatomic, copy) void (^onImageReady)(void);
@property (nonatomic, copy) void (^onImageTaken)(UIImage*(imageTaken),NSString *(title));
@property (nonatomic, copy) void (^onVideoTaken)(NSData*(videoTaken),UIImage*(imageTaken), NSString*(title));
@property (nonatomic, copy) void (^onPictureDiscard)(void);
@property (nonatomic, copy) void (^onPictureUploading)(void);
@property (nonatomic, copy) void (^onCameraCancel)(void);
@property (nonatomic, copy) void (^onVideoRecorded)(void);
@property (nonatomic, copy) void (^onCameraModeChanged)(bool(canChange));
@property (nonatomic, copy) void (^onNotificatonShow)(NSString *(message));
@property (nonatomic, copy) void (^onNetworkError)(UIView*(view));
@property (nonatomic, copy) void (^onNetworkErrorHide)(void);
@property (nonatomic, copy) void (^onProgression)(int(progress));
@property (nonatomic, copy) void (^onMediaPosted)(BucketModel *(bucket));
@property(nonatomic, strong) CameraHelper *cameraHelper;
//@property(nonatomic, strong) CameraHelper2 *cameraHelper;

@property bool hasAddedTitle;
@property bool canCapture;

-(void)onTap:(NSNumber *) mode;
-(void)prepareCamera:(bool)rearCamera withReply:(bool)reply;
-(void)takePicture;
-(void)closeCamera;
-(void)startRecording;
-(void)stopRecording;
@end
