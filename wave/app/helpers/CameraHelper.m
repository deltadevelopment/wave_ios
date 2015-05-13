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
#import <ImageIO/ImageIO.h>
//#import "VideoController.h"
@implementation CameraHelper
@synthesize PreviewLayer;
@synthesize stillImageOutput;
@synthesize videoConnection;
AVCaptureSession *CaptureSession;


-(id)init{
  //  self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
   // videoController =[[VideoController alloc]init];
    self = [super init];
    return self;
}


-(AVCaptureVideoPreviewLayer *)getLayer{
    return PreviewLayer;
};
/*
-(UIView*)getView{
    return view;
}
-(void)setView:(UIView *)videoView withRect:(CGRect) rect{
 
    if(CGRectIsEmpty(rect)){
        rect = videoView.bounds;
        rect.size.height = 500;
        
    }
    videoView.bounds = rect;
 
    view = videoView;
}
 */
- (void) capImage:(NSObject *) object withSuccess:(SEL) success {
    //method to capture image from AVCaptureSession video feed
  AVCaptureConnection *videoConnection2 = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput]connections]) {
        NSLog(@"hit");
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection2 = connection;
                NSLog(@"hit2");
                break;
            }
        }
        
        if (videoConnection2) {
            break;
        }
    }
    
    //[self.CaptureSession stopRunning];
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
   PreviewLayer.connection.enabled = NO;
    [stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection2
     completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (imageSampleBuffer != NULL) {
            self.imgTaken = [UIImage imageWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer]];
            //[object performSelector:success withObject:imgTaken];
            [object performSelectorOnMainThread:success withObject:self.imgTaken waitUntilDone:YES];
            //UIImageWriteToSavedPhotosAlbum(imgTaken, nil, nil, nil);
            NSLog(@"done");
           // [self stopCameraSession];
            NSLog(@"STOPPING SESSION");
            
            imageSampleBuffer = NULL;
        }
        else{
            NSLog(@"test");
        }
        
    }];
}

-(void)startPreviewLayer{
PreviewLayer.connection.enabled = YES;
}

-(void)test{
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageCapturedFromCamera) name:@"FTW_imageCaptured" object:nil];
    
}
-(void)imageCapturedFromCamera{
    NSLog(@"har-______________");
}


-(void) captureNow:(NSObject *) object withSuccess:(SEL) success {
 
    
    NSLog(@"about to request a capture from: %@", self.stillImageOutput);
 
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:[self.stillImageOutput.connections lastObject] completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        CMSampleBufferInvalidate(imageSampleBuffer);
        CFRelease(imageSampleBuffer);
        imageSampleBuffer = NULL;
     // [self stopCameraSession];
          [object performSelectorOnMainThread:success withObject:image waitUntilDone:YES];
    }];
}

-(void)stopCameraSession{
    dispatch_queue_t serialQueue = dispatch_queue_create("queue", NULL);
    dispatch_async(serialQueue, ^{
          [self.movieFileOutput stopRecording];
        [CaptureSession stopRunning];

        for(AVCaptureInput *input1 in CaptureSession.inputs) {
            [CaptureSession removeInput:input1];
              NSLog(@"removing input");
        }
        
        for(AVCaptureOutput *output1 in CaptureSession.outputs) {
            [CaptureSession removeOutput:output1];
            NSLog(@"removing output");
        }
        [PreviewLayer removeFromSuperlayer];
        [self.CameraView removeFromSuperview];
      

        
        CaptureSession=nil;
        self.outputSettings=nil;
        self.VideoDevice=nil;
        self.VideoInputDevice=nil;
        PreviewLayer=nil;
        stillImageOutput = nil;
        PreviewLayer = nil;
        self.stillImageOutput=nil;
        self.CameraView=nil;
        self.movieFileOutput = nil;
        self.imgTaken = nil;
        NSLog(@"stopped");
    });

   
}

-(void)initaliseVideo:(bool)rearCamera withView:(UIView *) view{
    CaptureSession = [[AVCaptureSession alloc] init];
    [self test];
    self.VideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.isInita = YES;
    if (self.VideoDevice)
    {
        NSError *error;
       // VideoInputDevice = [[AVCaptureDeviceInput alloc] initWithDevice:[weakSelf CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        self.VideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:self.VideoDevice error:&error];
        if (!error)
        {
            if ([CaptureSession canAddInput:self.VideoInputDevice])
                [CaptureSession addInput:self.VideoInputDevice];
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
    self.audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    self.audioInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioCaptureDevice error:&error];
    if (self.audioInput)
    {
        [CaptureSession addInput:self.audioInput];
    }
    
 
    
    //----- ADD OUTPUTS -----
    NSLog(@"Adding video preview layer");
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc]initWithSession:CaptureSession]];
    [PreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //ADD MOVIE FILE OUTPUT
    NSLog(@"Adding movie file output");
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    Float64 TotalSeconds = 60;			//Total seconds
    int32_t preferredTimeScale = 30;	//Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
    self.movieFileOutput.maxRecordedDuration = maxDuration;
    self.movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;
    
    //<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
  
    if ([CaptureSession canAddOutput:self.movieFileOutput]){
     [CaptureSession addOutput:self.movieFileOutput];

    }
    
    //[self addImageOutput];
    [self addImgOut];
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
    
    if ([CaptureSession canSetSessionPreset:AVCaptureSessionPreset640x480])		//Check size based configs are supported before setting them
        [CaptureSession setSessionPreset:AVCaptureSessionPresetiFrame960x540];
    
    
    
    
    
    
    //----- DISPLAY THE PREVIEW LAYER -----
    //Display it full screen under out view controller existing controls
    NSLog(@"Display the preview layer");
    CGRect layerRect = [[view layer] bounds];
    [PreviewLayer setBounds:layerRect];
    [PreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                           CGRectGetMidY(layerRect))];
    //[[[weakSelf view] layer] addSublayer:[[weakSelf CaptureManager] previewLayer]];
    //We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
   self.CameraView = [[UIView alloc] init];
    //[view addSubview:CameraView];
   // [view.layer insertSublayer:CameraView.layer atIndex:0];
    //[view.layer addSublayer:self.CameraView.layer];
    [view.layer insertSublayer:self.CameraView.layer atIndex:0];
    //[view sendSubviewToBack:CameraView];
    
    [[self.CameraView layer] addSublayer:PreviewLayer];
    self.CaptureSession2 = CaptureSession;
    //----- START THE CAPTURE SESSION RUNNING -----
    dispatch_queue_t serialQueue = dispatch_queue_create("queue", NULL);
    dispatch_async(serialQueue, ^{
        [CaptureSession startRunning];
        if(!rearCamera){
           // [self CameraToggleButtonPressed:YES];
        }
    });
}

-(void)initRecording{
        [CaptureSession removeOutput:self.movieFileOutput];
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    Float64 TotalSeconds = 60;			//Total seconds
    int32_t preferredTimeScale = 30;	//Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
    self.movieFileOutput.maxRecordedDuration = maxDuration;
    self.movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;
    

    
    if ([CaptureSession canAddOutput:self.movieFileOutput]){
        [CaptureSession addOutput:self.movieFileOutput];
        
    }
}




- (AVCaptureDevice *)frontCamera {
    if(self.frontFacingDevice == nil){
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == AVCaptureDevicePositionFront) {
                self.frontFacingDevice = device;
                return self.frontFacingDevice;
            }
        }
        return nil;
    }
    return self.frontFacingDevice;
  
}

-(void)addImageOutput{
    NSLog(@"HER NÅ");
        if(stillImageOutput !=nil){
            [self.CaptureSession2 removeOutput:stillImageOutput];
        }
        stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        self.outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [stillImageOutput setOutputSettings:self.outputSettings];

        [self.CaptureSession2 addOutput:stillImageOutput];
    
}

-(void)addImgOut{

        [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        [[self stillImageOutput] setOutputSettings:outputSettings];
        
        AVCaptureConnection *videoConnection = nil;
        for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
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
        
        [CaptureSession addOutput:[self stillImageOutput]];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"orienting right");
    return (interfaceOrientation == UIDeviceOrientationLandscapeLeft);
}


//********** CAMERA SET OUTPUT PROPERTIES **********
- (void) CameraSetOutputProperties
{
    NSLog(@"setting ot_________");
    //SET THE CONNECTION PROPERTIES (output properties)
    AVCaptureConnection *CaptureConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
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
    
    __weak typeof(self) weakSelf = self;
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)		//Only do if device has multiple cameras
    {
        NSLog(@"Toggle camera");
        NSError *error;
        //AVCaptureDeviceInput *videoInput = [weakSelf videoInput];
        AVCaptureDeviceInput *NewVideoInput;
        self.position = [[self.VideoInputDevice device] position];
        self.position = isFrontCamera ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
        
        if (self.position == AVCaptureDevicePositionBack)
        {
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[weakSelf CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        }
        else if (self.position == AVCaptureDevicePositionFront)
        {
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[weakSelf CameraWithPosition:AVCaptureDevicePositionBack] error:&error];
            
        }
        
        if (NewVideoInput != nil)
        {
            [CaptureSession beginConfiguration];		//We can now change the inputs and output configuration.  Use commitConfiguration to end
            [CaptureSession removeInput:self.VideoInputDevice];
            if ([CaptureSession canAddInput:NewVideoInput])
            {
                [CaptureSession addInput:NewVideoInput];
                self.VideoInputDevice = NewVideoInput;
            }
            else
            {
                [CaptureSession addInput:self.VideoInputDevice];
            }
            
            //Set the connection properties again
            [weakSelf CameraSetOutputProperties];
            
            
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
        [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:weakSelf];
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
    __weak typeof(self) weakSelf = self;
    weakSelf.isCompressed = NO;
    weakSelf.lastRecordedVideoCompressed = nil;
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
        weakSelf.onVideoPrepareForPlayback();
           __weak typeof(weakSelf) weakweakSelf = weakSelf;
        NSString *path = [outputFileURL path];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
     
         NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"outpute.mov"];
             NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        [weakSelf convertVideoToLowQuailtyWithInputURL:outputFileURL outputURL:outputURL handler:^(AVAssetExportSession *exportSession)
         {
             NSLog(@"her");
             if (exportSession.status == AVAssetExportSessionStatusCompleted)
             {
                 weakweakSelf.lastRecordedVideoCompressed = [[NSFileManager defaultManager] contentsAtPath:[outputURL path]];
                 [weakSelf performSelectorOnMainThread:@selector(compressionDone) withObject:nil waitUntilDone:NO];
                 printf("completed\n");
                 
             }
             else
             {
                 NSLog(@"%@",[exportSession.error debugDescription]);
             }
         }];
        self.lastRecordedVideo = data;
        //weakSelf.onVideoRecorded(lastRecordedVideo);
      //  lastRecordedVideo = data;
        self.lastRecordedVideoURL = outputFileURL;
        //weakSelf.onVideoRecorded(lastRecordedVideo);
        //[videoController sendVideoToServer:data withSelector:mediaSuccessSelector withObject:mediaSuccessObject withArg:nil];
       //CaptureSession = nil;
        //self.movieFileOutput = nil;
        //self.VideoInputDevice = nil;
        //[library release];
        NSLog(@"ferdig å recorde film");
        
    }
}

-(void)compressionDone{
    __weak typeof(self) weakSelf = self;
    weakSelf.onVideoRecorded([weakSelf getlastRecordedVideoCompressed]);
    weakSelf.isCompressed = YES;
}

-(NSData*)getlastRecordedVideoCompressed{
    __weak typeof(self) weakSelf = self;
    return weakSelf.lastRecordedVideoCompressed;
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
    __weak typeof(self) weakSelf = self;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[self.imgTaken CGImage] orientation:(ALAssetOrientation)[self.imgTaken imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            weakSelf.onMediaSavedToDiskError();
        } else {
            weakSelf.onMediaSavedToDisk();
        }
    }];
}

-(void)saveVideoToDisk{
    __weak typeof(self) weakSelf = self;
    //KODE FOR Å LAGRE TIL DISK
    if(self.lastRecordedVideoURL != nil){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:self.lastRecordedVideoURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:self.lastRecordedVideoURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     weakSelf.onMediaSavedToDiskError();
                 }
                 else{
                     weakSelf.onMediaSavedToDisk();
                 }
             }];
        }
    }
  
}


-(NSData*)getLastRecordedVideo{
    return self.lastRecordedVideo;
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
    NSLog(@"record: %@", self.recording ? @"YES" : @"NO");
    if (!self.recording)
    {
        self.recording = YES;
        __weak typeof(self) weakSelf = self;
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
        [self.movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:weakSelf];
        //[outputURL release];
    }
}

-(void)stopRecording{
    if(self.recording)
    {
        self.recording = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           // [self.CameraView removeFromSuperview];
            PreviewLayer.connection.enabled = NO;
            [self.movieFileOutput stopRecording];
            //[CaptureSession stopRunning];
        });
      
    }
}

-(bool)sessionIsRunning{
    return CaptureSession.isRunning;
}

- (void)captureStillImage
{
    __weak typeof(self) weakSelf = self;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", [self stillImageOutput]);
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                             CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                             if (exifAttachments) {
                                                                 NSLog(@"attachements: %@", exifAttachments);
                                                             } else {
                                                                 NSLog(@"no attachments");
                                                             }
                                                             //NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                            // UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                             NSLog(@"har bilde");
                                                             //[weakSelf stopCameraSession];
                                                             //[[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
                                                         }];
}



@end
