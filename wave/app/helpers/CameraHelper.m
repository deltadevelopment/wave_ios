//
//  CameraHelper.m
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CameraHelper.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
//#import "VideoController.h"
@implementation CameraHelper
AVCaptureMovieFileOutput *movieFileOutput;
bool recording;
AVCaptureDevice *VideoDevice;
AVCaptureDevicePosition position;
UIView *CameraView;
//VideoController *videoController;
NSData *lastRecordedVideo;
//NSData *lastRecordedVideoCompressed;
NSURL *lastRecordedVideoURL;

AVCaptureDevice *frontFacingDevice;
bool square;

-(id)init{
    movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
   // videoController =[[VideoController alloc]init];
    return self;
}

-(UIView*)getView{
    return view;
}
-(AVCaptureVideoPreviewLayer *)getLayer{
    return self.PreviewLayer;
};

-(void)setView:(UIView *)videoView withRect:(CGRect) rect{
    /*
    if(CGRectIsEmpty(rect)){
        rect = videoView.bounds;
        rect.size.height = 500;
        
    }
    videoView.bounds = rect;
     */
    view = videoView;
}

- (void) capImage:(NSObject *) object withSuccess:(SEL) success {
    //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            imgTaken = [UIImage imageWithData:imageData];
            [object performSelector:success withObject:imgTaken];
            
            //UIImageWriteToSavedPhotosAlbum(imgTaken, nil, nil, nil);
            [self stopCameraSession];
        }
        
    }];
}

-(void)stopCameraSession{
    [CameraView removeFromSuperview];
    [captureVideoPreviewLayer removeFromSuperlayer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [CaptureSession stopRunning];
        CaptureSession = nil;
        MovieFileOutput = nil;
        VideoInputDevice = nil;
        VideoDevice = nil;
    });
}

-(void)cancelSession{
    [CaptureSession stopRunning];
    [CameraView removeFromSuperview];
    [captureVideoPreviewLayer removeFromSuperlayer];
}

-(void)setSquare:(bool) theSquare
{
    square = theSquare;
}
-(void)initaliseVideo:(bool)rearCamera{
    NSLog(@"-------_________SETTER KAMERA");
    NSLog(@"Setting up capture session");
    CaptureSession = [[AVCaptureSession alloc] init];
   // CaptureSession.sessionPreset = AVCaptureSessionPresetLow;
    //----- ADD INPUTS -----
    NSLog(@"Adding video input");
    
    //ADD VIDEO INPUT
    
  
    
        VideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    
    if (VideoDevice)
    {
        NSError *error;
       // VideoInputDevice = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        VideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:VideoDevice error:&error];
        if (!error)
        {
            if ([CaptureSession canAddInput:VideoInputDevice])
                [CaptureSession addInput:VideoInputDevice];
            else
                NSLog(@"Couldn't add video input");
        }
        else
        {
            NSLog(@"Couldn't create video input");
        }
    }
    else
    {
        NSLog(@"Couldn't create video capture device");
    }
    
    //ADD AUDIO INPUT
    NSLog(@"Adding audio input");
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput)
    {
        [CaptureSession addInput:audioInput];
    }
    
    
    //----- ADD OUTPUTS -----
    
    //ADD VIDEO PREVIEW LAYER
    NSLog(@"Adding video preview layer");
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:CaptureSession]];
    
    //_PreviewLayer.orientation = AVCaptureVideoOrientationPortrait;		//<<SET ORIENTATION.  You can deliberatly set this wrong to flip the image and may actually need to set it wrong to get the right image
    //_PreviewLayer.orientation = AVCaptureVideoOrientationPortrait;
    
    [[self PreviewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //ADD MOVIE FILE OUTPUT
    NSLog(@"Adding movie file output");
    MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    Float64 TotalSeconds = 60;			//Total seconds
    int32_t preferredTimeScale = 30;	//Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
    MovieFileOutput.maxRecordedDuration = maxDuration;
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;
    
    //<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
    
    if ([CaptureSession canAddOutput:MovieFileOutput])
        [CaptureSession addOutput:MovieFileOutput];
    
    [self addImageOutput];
    //(We call a method as it also has to be done after changing camera)
    
    //----- SET THE IMAGE QUALITY / RESOLUTION -----
    //Options:
    //	AVCaptureSessionPresetHigh - Highest recording quality (varies per device)
    //	AVCaptureSessionPresetMedium - Suitable for WiFi sharing (actual values may change)
    //	AVCaptureSessionPresetLow - Suitable for 3G sharing (actual values may change)
    //	AVCaptureSessionPreset640x480 - 640x480 VGA (check its supported before setting it)
    //	AVCaptureSessionPreset1280x720 - 1280x720 720p HD (check its supported before setting it)
    //	AVCaptureSessionPresetPhoto - Full photo resolution (not supported for video output)
    NSLog(@"Setting image quality");
    [CaptureSession setSessionPreset:AVCaptureSessionPresetMedium];
    
    if(!square){
        if ([CaptureSession canSetSessionPreset:AVCaptureSessionPreset640x480])		//Check size based configs are supported before setting them
            [CaptureSession setSessionPreset:AVCaptureSessionPresetiFrame960x540];
        
    }else{
            [CaptureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    
    
    
    //----- DISPLAY THE PREVIEW LAYER -----
    //Display it full screen under out view controller existing controls
    NSLog(@"Display the preview layer");
    CGRect layerRect = [[view layer] bounds];
    [_PreviewLayer setBounds:layerRect];
    [_PreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                           CGRectGetMidY(layerRect))];
    //[[[self view] layer] addSublayer:[[self CaptureManager] previewLayer]];
    //We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
    CameraView = [[UIView alloc] init];
    //[view addSubview:CameraView];
   // [view.layer insertSublayer:CameraView.layer atIndex:0];
    [view.layer addSublayer:CameraView.layer];
    //[view sendSubviewToBack:CameraView];
    
    [[CameraView layer] addSublayer:_PreviewLayer];
    
    //----- START THE CAPTURE SESSION RUNNING -----
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [CaptureSession startRunning];
        if(!rearCamera){
            [self CameraToggleButtonPressed:YES];
        }
    });
}


- (AVCaptureDevice *)frontCamera {
    if(frontFacingDevice == nil){
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == AVCaptureDevicePositionFront) {
                frontFacingDevice = device;
                return frontFacingDevice;
            }
        }
        return nil;
    }
    return frontFacingDevice;
  
}

-(void)addImageOutput{
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [CaptureSession addOutput:stillImageOutput];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"orienting right");
    return (interfaceOrientation == UIDeviceOrientationLandscapeLeft);
}


//********** CAMERA SET OUTPUT PROPERTIES **********
- (void) CameraSetOutputProperties
{
    //SET THE CONNECTION PROPERTIES (output properties)
    AVCaptureConnection *CaptureConnection = [MovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    CaptureConnection.videoMirrored = YES;
    [CaptureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    //Set landscape (if required)
    if ([CaptureConnection isVideoOrientationSupported])
    {
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationLandscapeRight;		//<<<<<SET VIDEO ORIENTATION IF LANDSCAPE
        //[CaptureConnection setVideoOrientation:orientation];
    }
    
    //Set frame rate (if requried)
    /*
     CMTimeShow(CaptureConnection.videoMinFrameDuration);
     CMTimeShow(CaptureConnection.videoMaxFrameDuration);
     
     if (CaptureConnection.supportsVideoMinFrameDuration)
     CaptureConnection.videoMinFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
     if (CaptureConnection.supportsVideoMaxFrameDuration)
     CaptureConnection.videoMaxFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
     
     CMTimeShow(CaptureConnection.videoMinFrameDuration);
     CMTimeShow(CaptureConnection.videoMaxFrameDuration);
     */
    /*
     
     CMTimeShow([VideoDevice activeVideoMinFrameDuration]);
     CMTimeShow([VideoDevice activeVideoMaxFrameDuration]);
     
     
     [VideoDevice setActiveVideoMaxFrameDuration:CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND)];
     [VideoDevice setActiveVideoMinFrameDuration:CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND)];
     
     CMTimeShow([VideoDevice activeVideoMinFrameDuration]);
     CMTimeShow([VideoDevice activeVideoMaxFrameDuration]);
     */
    
}

//********** GET CAMERA IN SPECIFIED POSITION IF IT EXISTS **********
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position
{
    NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *Device in Devices)
    {
        if ([Device position] == Position)
        {
            return Device;
        }
    }
    return nil;
}
//********** CAMERA TOGGLE **********
- (void)CameraToggleButtonPressed:(bool)isFrontCamera
{
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)		//Only do if device has multiple cameras
    {
        NSLog(@"Toggle camera");
        NSError *error;
        //AVCaptureDeviceInput *videoInput = [self videoInput];
        AVCaptureDeviceInput *NewVideoInput;
        position = [[VideoInputDevice device] position];
        position = isFrontCamera ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
        
        if (position == AVCaptureDevicePositionBack)
        {
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        }
        else if (position == AVCaptureDevicePositionFront)
        {
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionBack] error:&error];
            
        }
        
        if (NewVideoInput != nil)
        {
            [CaptureSession beginConfiguration];		//We can now change the inputs and output configuration.  Use commitConfiguration to end
            [CaptureSession removeInput:VideoInputDevice];
            if ([CaptureSession canAddInput:NewVideoInput])
            {
                [CaptureSession addInput:NewVideoInput];
                VideoInputDevice = NewVideoInput;
            }
            else
            {
                [CaptureSession addInput:VideoInputDevice];
            }
            
            //Set the connection properties again
            [self CameraSetOutputProperties];
            
            
            [CaptureSession commitConfiguration];
        }
    }
}




//********** START STOP RECORDING BUTTON **********
/*
- (void)StartStopRecording
{
    if (!recording)
    {
        //----- START RECORDING -----
        NSLog(@"START RECORDING");
        recording = YES;
        
        //Create temporary URL to record to
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath])
        {
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
            {
                //Error - handle if requried
            }
        }
        //[outputPath release];
        //Start recording
        [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        //[outputURL release];
    }
    else
    {
        //----- STOP RECORDING -----
        NSLog(@"STOP RECORDING");
        recording = NO;
        [CameraView removeFromSuperview];
        [MovieFileOutput stopRecording];
        [CaptureSession stopRunning];
    }
}
*/
//********** DID FINISH RECORDING TO OUTPUT FILE AT URL **********
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error
{
    self.isCompressed = NO;
    self.lastRecordedVideoCompressed = nil;
    NSLog(@"Local path: %@", [outputFileURL path]);
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully)
    {
        //----- RECORDED SUCESSFULLY -----
        /*
         //KODE FOR Å LAGRE TIL DISK
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     
                 }
             }];
        }
         */
        self.onVideoPrepareForPlayback();
           __weak typeof(self) weakSelf = self;
        NSString *path = [outputFileURL path];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
     
         NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"outpute.mov"];
             NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        [self convertVideoToLowQuailtyWithInputURL:outputFileURL outputURL:outputURL handler:^(AVAssetExportSession *exportSession)
         {
             NSLog(@"her");
             if (exportSession.status == AVAssetExportSessionStatusCompleted)
             {
                 weakSelf.lastRecordedVideoCompressed = [[NSFileManager defaultManager] contentsAtPath:[outputURL path]];
                 [self performSelectorOnMainThread:@selector(compressionDone) withObject:nil waitUntilDone:NO];
                 printf("completed\n");
                 
             }
             else
             {
                 NSLog(@"%@",[exportSession.error debugDescription]);
             }
         }];
        lastRecordedVideo = data;
        //self.onVideoRecorded(lastRecordedVideo);
      //  lastRecordedVideo = data;
        lastRecordedVideoURL = outputFileURL;
        //self.onVideoRecorded(lastRecordedVideo);
        //[videoController sendVideoToServer:data withSelector:mediaSuccessSelector withObject:mediaSuccessObject withArg:nil];
        CaptureSession = nil;
        MovieFileOutput = nil;
        VideoInputDevice = nil;
        //[library release];
        NSLog(@"ferdig å recorde film");
        
    }
}

-(void)compressionDone{
    self.onVideoRecorded([self getlastRecordedVideoCompressed]);
    self.isCompressed = YES;
}

-(NSData*)getlastRecordedVideoCompressed{
    return self.lastRecordedVideoCompressed;
}

- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPreset640x480];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
              handler(exportSession);
         });
     }];
    
}

-(void)saveImageToDisk{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[imgTaken CGImage] orientation:(ALAssetOrientation)[imgTaken imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            self.onMediaSavedToDiskError();
        } else {
            self.onMediaSavedToDisk();
        }
    }];
}

-(void)saveVideoToDisk{
    //KODE FOR Å LAGRE TIL DISK
    if(lastRecordedVideoURL != nil){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:lastRecordedVideoURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:lastRecordedVideoURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     self.onMediaSavedToDiskError();
                 }
                 else{
                     self.onMediaSavedToDisk();
                 }
             }];
        }
    }
  
}


-(NSData*)getLastRecordedVideo{
    return lastRecordedVideo;
}

-(void)setMediaDoneSelector:(SEL) successSelector
                 withObject:(NSObject*) object
{
    mediaSuccessSelector = successSelector;
    mediaSuccessObject = object;
}


//********** VIEW DID UNLOAD **********
/*
 - (void)viewDidUnload
 {
 [super viewDidUnload];
 
 [CaptureSession release];
 CaptureSession = nil;
 [MovieFileOutput release];
 MovieFileOutput = nil;
 [VideoInputDevice release];
 VideoInputDevice = nil;
 }
 */

#pragma New Camera structure
-(void)startRecording{
    if (!recording)
    {
        recording = YES;
        
        //Create temporary URL to record to
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath])
        {
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
            {
                //Error - handle if requried
            }
        }
        //[outputPath release];
        //Start recording
        [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        //[outputURL release];
    }
}

-(void)stopRecording{
    if(recording)
    {
        recording = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [CameraView removeFromSuperview];
            [MovieFileOutput stopRecording];
            [CaptureSession stopRunning];
        });
      
    }
}



@end
