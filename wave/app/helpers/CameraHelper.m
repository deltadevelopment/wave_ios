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
#import "CaptionTextField.h"
//#import "VideoController.h"
@implementation CameraHelper{
    NSString *videoURL;
    NSURL *VideoURLWithCaption;
    bool savingtoDisk;
}
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
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection2 = connection;
                break;
            }
        }
        
        if (videoConnection2) {
            break;
        }
    }
    
    //[self.CaptureSession stopRunning];
    
   PreviewLayer.connection.enabled = NO;
    [stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection2
     completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (imageSampleBuffer != NULL) {
            self.imgTaken = [UIImage imageWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer]];
            //[object performSelector:success withObject:imgTaken];
            [object performSelectorOnMainThread:success withObject:self.imgTaken waitUntilDone:YES];
            //UIImageWriteToSavedPhotosAlbum(imgTaken, nil, nil, nil);
           // [self stopCameraSession];
            
            imageSampleBuffer = NULL;
        }
        else{
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
  
}


-(void) captureNow:(NSObject *) object withSuccess:(SEL) success {
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
    
        }
        
        for(AVCaptureOutput *output1 in CaptureSession.outputs) {
            [CaptureSession removeOutput:output1];

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
    });

   
}

-(void)initaliseVideo:(bool)rearCamera withView:(UIView *) view{
    CaptureSession = [[AVCaptureSession alloc] init];
    [self test];
    self.VideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.isInitialised = YES;
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
        
        AVCaptureConnection *localVideoConnection = nil;
        for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
            for (AVCaptureInputPort *port in [connection inputPorts]) {
                if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                    localVideoConnection = connection;
                    break;
                }
            }
            if (localVideoConnection) {
                break; 
            }
        }
        
        [CaptureSession addOutput:[self stillImageOutput]];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationLandscapeLeft);
}


//********** CAMERA SET OUTPUT PROPERTIES **********
- (void) CameraSetOutputProperties
{
    //SET THE CONNECTION PROPERTIES (output properties)
    AVCaptureConnection *CaptureConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    CaptureConnection.videoMirrored = YES;
    [CaptureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    //Set landscape (if required)
    if ([CaptureConnection isVideoOrientationSupported])
    {
        //AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationLandscapeRight;		//<<<<<SET VIDEO ORIENTATION IF LANDSCAPE
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
    videoURL = [outputFileURL path];
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
     
         NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"outpute.mp4"];
             NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        [weakSelf convertVideoToLowQuailtyWithInputURL:outputFileURL outputURL:outputURL handler:^(AVAssetExportSession *exportSession)
         {
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
    exportSession.outputFileType = AVFileTypeMPEG4;
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

-(void)saveImageToDisk:(UIImage *) image{
    __weak typeof(self) weakSelf = self;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
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
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mp4"];
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
/*
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


*/

-(void)startD:(UIView *) view toDisk:(bool) isToDisk withURL:(NSURL *) url{
    NSString *filePath = [url path];
    self.videoAsset =[[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filePath]  options:nil];
    [self videoOutput:view toDisk:isToDisk];
}


- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size withView:(UIView *) view
{
    view.frame = CGRectMake(0, 0, size.width, size.height);
    view.layer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(90);
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:view.layer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:view.layer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

- (void)videoOutput:(UIView *) view toDisk:(bool) isToDisk
{
    // 1 - Early exit if there's no video file selected
    if (!self.videoAsset) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Load a Video Asset First"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3 - Video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
  
    
    
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration) ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];

    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:self.videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize withView:view];
    if(isToDisk){
        [self saveVideoWithCaptionToDisk:mainCompositionInst withMixComp:mixComposition];
    }else{
        [self saveVideWithCaptionToTemp:mainCompositionInst withMixComp:mixComposition];
    }
   
}

-(void)saveVideoWithCaptionToDisk:(AVMutableVideoComposition *) mainCompositionInst withMixComp:(AVMutableComposition *)mixComposition{
    // 4 - Get path
    savingtoDisk = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mp4",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    VideoURLWithCaption = url;
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
}

-(void)saveVideWithCaptionToTemp:(AVMutableVideoComposition *) mainCompositionInst withMixComp:(AVMutableComposition *)mixComposition{
    // 4 - Get path
    savingtoDisk = NO;
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), [NSString stringWithFormat:@"output-%d.mov", arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:outputPath];
    VideoURLWithCaption = url;
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
}


-(NSData *)getVideoWithCaption{
    NSLog(@"NIL?");
    NSString *path = [VideoURLWithCaption path];
    NSLog(@"path is %@", path);
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    return data;
}

- (void)exportDidFinish:(AVAssetExportSession*)session {
    __weak typeof(self) weakSelf = self;
    NSLog(@"Saving file");
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        /*
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                         */
                        NSLog(@"ERROR");
                        weakSelf.onMediaSavedToDiskError();
                    } else {
                          NSLog(@"Not error");
                        /*
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                         */
                        if(!savingtoDisk){
                            NSLog(@"SAVED");
                            weakSelf.onMediaRenderCompleted();
                        }else{
                            weakSelf.onMediaSavedToDisk();
                        }
                        
                    }
                });
            }];
        }
    }
    
    

    
    
    
}


@end
