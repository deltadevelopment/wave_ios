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
#import "BucketTypeModel.h"
#import "GraphicsHelper.h"
#import "CircleIndicatorView.h"
#import "MediaPlayerViewController.h"
#import "ProgressView.h"
#import "BucketController.h"
#import "DataHelper.h"
#import "DropController.h"
#import "MediaModel.h"
#import "CaptionTextField.h"

@interface CameraViewController ()

@end
@implementation CameraViewController{
    
    CircleIndicatorView *circleIndicatorView;
    UIButton *selfieButton;
    UIButton *saveMediaButton;
    ProgressView *saveMediaProgressView;
    ProgressView *loadVideoProgressView;
    bool cameraMode;
    bool frontFacingMode;
    bool imageReadyForUpload;
    UIImage *imgTaken;
    UIButton *cancelButton;
    UIButton *typeButton;
    UIButton *captionButton;
    
    int currentTypeIndex;
     NSMutableArray *bucketTypes;
    UILabel *toolTip;
    int intMode;
    NSTimer *recordTimer;
    UIView *recordingProgressView;
    BOOL isRecording;
    MediaPlayerViewController *mediaPlayer;
    bool mediaIsVideo;
    UIImageView *imageView;
    NSData *lastRecordedVideo;
    bool isReply;
    UITextField *titleTextField;
    BucketController *bucketController;
    DropController *dropController;
    UIView *errorView;
    bool cameraIsInitialized;
    NSData *recordedVideo;
    NSData *recordedVideoCompressed;
    CaptionTextField *captionElement;
    UIView *captionsView;
    bool hasCaption;
    NSMutableArray *captions;
}

@synthesize cameraHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    mediaPlayer = [[MediaPlayerViewController alloc] init];
    mediaPlayer.view.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    [self.view addSubview:mediaPlayer.view];
    mediaPlayer.onVideoFinishedPlaying = ^{
        
    };
    bucketController = [[BucketController alloc] init];
    dropController = [[DropController alloc] init];
    bucketTypes = [[NSMutableArray alloc]init];
    captions = [[NSMutableArray alloc] init];
    selfieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // [selfieButton setTitle:@"Selfie" forState:UIControlStateNormal];
    [selfieButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"profile-icon.png"] withSize:150] forState:UIControlStateNormal];
    
    selfieButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11,11, 11);
    selfieButton.userInteractionEnabled = YES;
    [selfieButton addTarget:self action:@selector(flipCameraView:) forControlEvents:UIControlEventTouchDown];
    // selfieButton.frame = CGRectMake([UIHelper getScreenWidth]-60, 12, 50, 25);
    
    //[selfieButton setTintColor:[UIColor whiteColor]];
    // selfieButton.layer.borderWidth=1.0f;
    //selfieButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    [self initCameraHelper];
    saveMediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveMediaButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"download-icon.png"] withSize:150] forState:UIControlStateNormal];
    saveMediaButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11,11, 11);
    saveMediaButton.userInteractionEnabled = YES;
    saveMediaButton.alpha = 0.0;
    [saveMediaButton addTarget:self action:@selector(saveMediaToDisk:) forControlEvents:UIControlEventTouchDown];
    saveMediaButton.hidden = YES;
    //[selfieButton setBackgroundImage:[UIImage imageNamed:@"bucket.png"] forState:UIControlStateNormal];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toolTip = [[UILabel alloc]init];
    captionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self initBucketTypes];
    [self initProgressView];
    [self initTextField];
    // [self initUI];
   
    //[self initCaptionsView];
}

-(void)initCaptionsView{
    if(captionsView != nil){
        [captionsView removeFromSuperview];
    }
    captionsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    captionsView.backgroundColor = [UIColor clearColor];
}

-(void)viewDidAppear:(BOOL)animated{
    // frontFacingMode = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UI methods

-(void)addShadow{
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]/4)];
    [UIHelper addShadowToView:shadowView];
    [self.view addSubview:shadowView];
}

#pragma Initialisation methods

-(void)initCameraHelper{
    self.cameraHelper = [[CameraHelper alloc]init];
    __weak typeof(self) weakSelf = self;
    
    cameraHelper.onVideoRecorded = ^(NSData *(video)){
        [weakSelf onVideorecorded:video];
    };
    cameraHelper.onVideoPrepareForPlayback = ^{
        
    };
    cameraHelper.onMediaSavedToDisk = ^{
        [weakSelf onMediaSavedToDisk];
    };
    cameraHelper.onMediaSavedToDiskError = ^{
        [weakSelf onMediaSavedToDiskError];
    };
}

-(void)initTextField{
    float width = [UIHelper getScreenWidth] -100;
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64, width, 60)];
    titleTextField.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:19.0f];
    [titleTextField setTextColor:[UIColor whiteColor]];
    titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add a title" attributes:@{                                                                                                                                 NSForegroundColorAttributeName: [[UIColor whiteColor]colorWithAlphaComponent:0.8]                                                                                                                                                                     }];
    titleTextField.delegate = self;
       titleTextField.returnKeyType = UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    titleTextField.hidden = YES;

    
}

-(void)initProgressView{
    float width = [UIHelper getScreenWidth] - 40;
    saveMediaProgressView = [[ProgressView alloc] initWithFrame:CGRectMake(([UIHelper getScreenWidth]/2) - (width/2),
                                                                     ([UIHelper getScreenHeight]/2) - 35,
                                                                     width,
                                                                     70)];
    loadVideoProgressView = [[ProgressView alloc] initWithFrame:CGRectMake(([UIHelper getScreenWidth]/2) - (width/2),
                                                                           ([UIHelper getScreenHeight]/2) - 35,
                                                                           width,
                                                                           70)];
    [loadVideoProgressView turnOffText];
}

-(void)initBucketTypes{
    [bucketTypes addObject:[[BucketTypeModel alloc] initWithProperties:0 withDescription:@"Add a drop" withIconPath:@"events-icon.png"]];
    [bucketTypes addObject:[[BucketTypeModel alloc] initWithProperties:1 withDescription:@"Create a bucket" withIconPath:@"bucket-white.png"]];
    
}

-(void)initUI{
    [self initCancelButton];
    [self initTypeButton];
    [self initCaptionButton];
    [self initToolTip];
    recordingProgressView = [[UIView alloc] initWithFrame:CGRectMake(([UIHelper getScreenWidth]/2) -40, [UIHelper getScreenHeight] - 85, 80, 80)];
    recordingProgressView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:recordingProgressView];
   // [self addConstraintsToButton:self.view withButton:recordingProgressView withPoint:CGPointMake(11, 10) fromLeft:NO];
}

-(void)initCancelButton{
    [UIHelper applyUIOnButton:cancelButton];
    [cancelButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"cross.png"] withSize:150] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [cancelButton addTarget:self action:@selector(tapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    [self addConstraintsToButton:self.view withButton:cancelButton withPoint:CGPointMake(11, 10) fromLeft:NO];
   // cancelButton.hidden = YES;
    cancelButton.alpha = 1.0;
    
}

-(void)initCaptionButton{
    [UIHelper applyUIOnButton:captionButton];
    [captionButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"plus-simple.png"] withSize:150] forState:UIControlStateNormal];
    [captionButton addTarget:self action:@selector(tapCaptionButton) forControlEvents:UIControlEventTouchUpInside];
    [self addConstraintsToButton:self.view withButton:captionButton withPoint:CGPointMake(-4, -64) fromLeft:YES fromTop:YES];
    captionButton.hidden = YES;
    captionButton.alpha = 0.0;
}

-(void)tapCaptionButton{
    CaptionTextField *element = [[CaptionTextField alloc] init];
    [imageView addSubview:element];
    [captions addObject:element];
    captionElement = element;
    hasCaption = YES;
}

-(void)initTypeButton{
    [UIHelper applyUIOnButton:typeButton];
    typeButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [typeButton addTarget:self action:@selector(tapTypeButton) forControlEvents:UIControlEventTouchUpInside];

    [self addConstraintsToButton:self.view withButton:typeButton withPoint:CGPointMake(-4, 10) fromLeft:YES];
    typeButton.hidden = YES;
    typeButton.alpha = 0.0;
}

-(void)initToolTip{
    [UIHelper applyThinLayoutOnLabel:toolTip];

    toolTip.hidden = NO;
    toolTip.alpha = 0.0;
    [self addTooltipConstraint:self.view withLabel:toolTip];
    BucketTypeModel *bucketModel = [bucketTypes objectAtIndex:currentTypeIndex];
    [typeButton setImage:[UIHelper iconImage:[UIImage imageNamed:[bucketModel icon_path]] withSize:150] forState:UIControlStateNormal];
    toolTip.text = [bucketModel type_description];
}

-(void)initToolTipText{
    BucketTypeModel *bucketModel = [bucketTypes objectAtIndex:currentTypeIndex];
    [typeButton setImage:[UIHelper iconImage:[UIImage imageNamed:[bucketModel icon_path]] withSize:150] forState:UIControlStateNormal];
    toolTip.text = [bucketModel type_description];
}


#pragma Gesture methods

-(void)onTap:(NSNumber *) mode{
    intMode = [mode intValue];
    if(intMode == 1){
        cameraMode = YES;
        currentTypeIndex = 0;
        [self initToolTipText];
        titleTextField.hidden = YES;
        self.onCameraModeChanged(NO);
        titleTextField.text = @"";
        self.onCameraOpen();
    }
    else if(intMode == 2){
        if(currentTypeIndex == 1 && titleTextField.text.length == 0){
            [self notifyUser];
        }else{
            [self takePicture];
            titleTextField.hidden = YES;
        }
        
    }
    else if(intMode == 0){
        if(imageReadyForUpload){
            [self prepareForUpload];
        }else{
            //camera is not ready
            
        }
    }
}


-(void)tapCancelButton{
    imgTaken = nil;
    if(imageView != nil){
       imageView.hidden = YES;
    }
    
    if(intMode == 1){
        imageView.hidden = YES;
        self.onCameraCancel();
        [self initCameraHelper];
    }
    else if (intMode == 2){
        [self startCamera];
        for(CaptionTextField *cap in captions){
            [cap removeFromSuperview];
        }
       // [self initCaptionsView];
        if(mediaIsVideo){
            [mediaPlayer stopVideo];
            mediaPlayer.view.hidden = YES;
            //[mediaPlayer.view removeFromSuperview];
            mediaIsVideo = NO;
        }
        if(frontFacingMode){
            //[self prepareCamera:NO];
        }else{
          //  [self prepareCamera:YES];
        }
       titleTextField.text = @"";
        intMode = 1;
        self.onPictureDiscard();
    }
}

-(void)tapTypeButton{
    currentTypeIndex ++;
    if(currentTypeIndex == [bucketTypes count]){
        currentTypeIndex = 0;
    }
    if(currentTypeIndex != 1){
        titleTextField.hidden = YES;
        self.onCameraModeChanged(YES);
    }else{
        titleTextField.hidden = NO;
        self.onCameraModeChanged(NO);
    }
    BucketTypeModel *bucketModel = [bucketTypes objectAtIndex:currentTypeIndex];
    [typeButton setImage:[UIHelper iconImage:[UIImage imageNamed:[bucketModel icon_path]] withSize:150] forState:UIControlStateNormal];
    toolTip.text = [bucketModel type_description];
}


# pragma Camera methods
//Starting the camera first time
-(void)prepareCamera:(bool)rearCamera withReply:(bool)reply{
    isReply = reply;
    imgTaken = nil;
    mediaPlayer.view.hidden = YES;
    frontFacingMode = !rearCamera;
    
    
    //[self.cameraHelper setView:self.view withRect:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    if(!cameraIsInitialized){
        cameraIsInitialized = YES;
        [self addShadow];
        [self.view addSubview:selfieButton];
      
        [self.view addSubview:saveMediaButton];
          [self.view addSubview:captionButton];
        [self.view addSubview:typeButton];
        
        [self.view addSubview:toolTip];
        [self.view addSubview:loadVideoProgressView];
        [self.view addSubview:saveMediaProgressView];
        [self.view addSubview:titleTextField];
        [self initUI];
        //[self showTools];
        [self addConstraintsToButton:self.view withButton:selfieButton withPoint:CGPointMake(0, -64) fromLeft:NO fromTop:YES];
        [self addConstraintsToButton:self.view withButton:saveMediaButton withPoint:CGPointMake(-4, 10) fromLeft:YES fromTop:NO];
        self.onCameraReady();
    }
    if(![cameraHelper isInitialised]){
        self.onCameraModeChanged(YES);
        [cameraHelper initaliseVideo:rearCamera withView:self.view];
    }
    
    else{
        // [cameraHelper initRecording];
    }
    if(!isReply){
          [self showTools];
    }
}

-(void)startCamera{
    [cameraHelper startPreviewLayer];
    saveMediaButton.hidden = YES;
    captionButton.hidden = YES;
    [self showButton:typeButton];
    [self showLabel:toolTip];
    if(currentTypeIndex == 1){
        titleTextField.hidden = NO;
        self.onCameraModeChanged(NO);
    }
    [self showButton:selfieButton];
}

-(void)flipCameraView:(id)sender{
    frontFacingMode = frontFacingMode ? NO : YES;
    [cameraHelper CameraToggleButtonPressed:frontFacingMode];
}

# pragma Notifications methods

-(void)notifyUser{
    self.onNotificatonShow(@"Add a title to your bucket");
}

#pragma Upload medthods

-(void)prepareForUpload{
    recordedVideoCompressed = [cameraHelper getlastRecordedVideoCompressed];
    if(mediaIsVideo){
        [mediaPlayer stopVideo];
    }
    
    [self startCamera];
    if(mediaIsVideo){
        [mediaPlayer stopVideo];
        mediaPlayer.view.hidden = YES;
    }
    intMode = 1;
    [self closeCamera];
    [self initCameraHelper];
    
    imageView.hidden = YES;
    self.onCameraClose();
    cameraMode = NO;
    imageReadyForUpload = NO;
    if(mediaIsVideo){
        mediaIsVideo = NO;
        self.onVideoTaken(recordedVideoCompressed, imgTaken, titleTextField.text);
        [self uploadMedia:recordedVideoCompressed withMediaType:1];
        
    }
    else{
        self.onImageTaken(imgTaken, titleTextField.text);
        CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
        if(hasCaption){
            UIImage *image =[self screenshot:UIDeviceOrientationPortrait isOpaque:NO usePresentationLayer:YES];
            [self uploadMedia:UIImagePNGRepresentation(image) withMediaType:0];

        }else{
            [self uploadMedia:UIImagePNGRepresentation([GraphicsHelper imageByScalingAndCroppingForSize:size img:imgTaken]) withMediaType:0];
        }
    }
    mediaIsVideo = NO;
}

-(void)uploadMedia:(NSData *) media withMediaType:(int) media_type{
    if(isReply){
        //add a drop
        [self addNewDrop:media withBucketId:[DataHelper getCurrentBucketId] withMediaType:media_type];
    }else{
        if(currentTypeIndex == 1){
            //Create a new bucket
            [self createNewBucket:media withMediaType:media_type];
        }else{
            //update personal bucket - add drop to personal bucket
            [self addNewDrop:media withBucketId:[DataHelper getBucketId] withMediaType:media_type];
        }
    }
    for(CaptionTextField *cap in captions){
        [cap removeFromSuperview];
    }
}

-(void)createNewBucket:(NSData *) media withMediaType:(int)media_type{
    __weak typeof(self) weakSelf = self;
    //Creating a new bucket
    BucketModel *bucket = [[BucketModel alloc] init];
    [bucket setTitle:titleTextField.text];
    [bucket setBucket_description:@"my crazy new description"];
    
    //Creating a new Media Model
    MediaModel *mediaModel = [[MediaModel alloc] init:media];
    
    //Creating a new drop
    DropModel *drop = [[DropModel alloc] init];
    [drop setCaption:@"My crazy caption"];
    if(captionElement != nil){
        [drop setCaption:[captionElement getCaptionText]];
    }
    
    [drop setMedia_type:media_type];
    [drop setMediaModel:mediaModel];
    [bucket addDrop:drop];
    
    [bucket saveChanges:^(ResponseModel *response, BucketModel *bucket){
        self.onMediaPosted(bucket);
        titleTextField.text = @"";
    } onError:^(NSError *error){
        [DataHelper storeData:media withMediaType:media_type];
        errorView = [GraphicsHelper getErrorView:[error localizedDescription]
                                      withParent:self
                                 withButtonTitle:@"Prøv igjen"
                       withButtonPressedSelector:@selector(uploadAgain)];
        weakSelf.onNetworkError(errorView);
    
    } onProgress:^(NSNumber *progression){
        weakSelf.onProgression([progression intValue]);
    }];
}

-(void)addNewDrop:(NSData *) media
     withBucketId:(int) bucketId
    withMediaType:(int)media_type
{
    
    DropModel *drop = [[DropModel alloc] init];
    MediaModel *mediaModel = [[MediaModel alloc] init:media];
    drop.caption = @"test caption";
    if(captionElement != nil){
        [drop setCaption:[captionElement getCaptionText]];
    }
    drop.bucket_id = bucketId;
    drop.media_type = media_type;
    drop.mediaModel = mediaModel;
    
    __weak typeof(self) weakSelf = self;
    [drop saveChangesToDrop:^(ResponseModel *response, DropModel *drop){
        drop.media_tmp = media;
        weakSelf.onMediaPostedDrop(drop);
    } onProgress:^(NSNumber *progress){
        weakSelf.onProgression([progress intValue]);
    }
                    onError:^(NSError *error){
                        NSMutableDictionary *dic= [[NSMutableDictionary alloc] initWithDictionary:[error userInfo]];
                        ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                        self.onNotificatonShow([responseModel message]);
                        
                        [DataHelper storeData:media withMediaType:media_type];
                        //[weakSelf addErrorMessage];
                        errorView = [GraphicsHelper getErrorView:[error localizedDescription]
                                                      withParent:self
                                                 withButtonTitle:@"Prøv igjen"
                                       withButtonPressedSelector:@selector(uploadAgain)];
                        weakSelf.onNetworkError(errorView);
                    
                    }];
    
    
    /*
    [dropController addDropToBucket:@"CaptionTest"
                          withMedia:media
                       withBucketId:bucketId
                      withMediaType:media_type
                         onProgress:^(NSNumber *progression){
                             weakSelf.onProgression([progression intValue]);
                         }
                       onCompletion:^(ResponseModel *response){
                           DropModel *drop = [[DropModel alloc] init:[[response data] objectForKey:@"drop"]];
                           drop.media_tmp = media;
                           weakSelf.onMediaPostedDrop(drop);
                           
                           
                       } onError:^(NSError *error){
                           NSMutableDictionary *dic= [[NSMutableDictionary alloc] initWithDictionary:[error userInfo]];
                           ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                           self.onNotificatonShow([responseModel message]);
                           
                           [DataHelper storeData:media withMediaType:media_type];
                           //[weakSelf addErrorMessage];
                           errorView = [GraphicsHelper getErrorView:[error localizedDescription]
                                                         withParent:self
                                                    withButtonTitle:@"Prøv igjen"
                                          withButtonPressedSelector:@selector(uploadAgain)];
                           weakSelf.onNetworkError(errorView);
                       }];
     */
}

-(void)uploadAgain{
    [errorView removeFromSuperview];
    self.onNetworkErrorHide();
    [self uploadMedia:[DataHelper getData] withMediaType:[DataHelper getMediaType]];
}

-(void)closeCamera{
    cameraMode = NO;
    self.onCameraClose();
    [cameraHelper stopCameraSession];
}

#pragma Take picture methods

-(void)takePicture{
   [cameraHelper capImage:self withSuccess:@selector(pictureWasTaken:)];
}

-(void)pictureWasTaken:(UIImage *)image{
    imgTaken = image;
    //[cameraHelper stopCameraSession];

    if(frontFacingMode){
        //Flip image
        imgTaken = [GraphicsHelper mirrorImageWithImage:imgTaken];
    }
    
    if(imageView == nil){
        imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        imageView.userInteractionEnabled = YES;
    }
    else{
        imageView.hidden = NO;
    }
    imageView.image = imgTaken;
    [self.view insertSubview:imageView belowSubview:saveMediaButton];
    //[self.view insertSubview:captionsView aboveSubview:imageView];
    imageReadyForUpload = YES;
    self.onImageReady();
    [self hideTools];
    //[self showEditTools];
}

-(void)showEditTools{
 
}

#pragma Record methods

-(void)startRecording
{
    if(currentTypeIndex == 1 && titleTextField.text.length == 0){
        //Notify user to add a title
        [self notifyUser];
        
    }else {
        [cameraHelper startPreviewLayer];
        [cameraHelper startRecording];
        isRecording = YES;
        circleIndicatorView = [[CircleIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [recordingProgressView addSubview:circleIndicatorView];
        
        [circleIndicatorView setIndicatorWithMaxTime:10];
        [self hideAllTools];
        [self hideButton:selfieButton];
        //Start recording
        
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(decrementSpin) userInfo:nil repeats:YES];
    }
    
    
}

-(void)decrementSpin{
    [circleIndicatorView incrementSpin];
    if(circleIndicatorView.percent >100){
        //STOP RECORDING
        [self stopRecording];
    }
}

-(void)stopRecording
{
    //sjekke her om videoen allerede er stoppet. kan skje hvis tiden går ut å brukeren deretter slipper knappen
    if(isRecording){
        titleTextField.hidden = YES;
        [loadVideoProgressView startProgress];
        
        [cameraHelper stopRecording];
        isRecording = NO;
        [recordTimer invalidate];
        [circleIndicatorView removeFromSuperview];
        circleIndicatorView.percent = 0;
        [self showButton:cancelButton];
    }
    
}

-(void)onVideorecorded:(NSData *) video{
    [loadVideoProgressView stopProgress];
    //mediaPlayer = [[MediaPlayerViewController alloc] init];
    lastRecordedVideo = video;
    intMode = 2;
    mediaIsVideo = YES;
    mediaPlayer.view.hidden = NO;
    imageReadyForUpload = YES;
    
    [mediaPlayer setVideo:video withId:-1];
    [mediaPlayer playVideo];
    self.onVideoRecorded();
    [self showButton:cancelButton];
    [self hideTools];
    imgTaken = [mediaPlayer getVideoThumbnail];

    // [mediaPlayer ]
    
}

#pragma Saved media methods

-(void)saveMediaToDisk:(id)sender{
    [saveMediaProgressView setProgressString:NSLocalizedString(@"progress_txt", nil)];
    [saveMediaProgressView startProgress];
    if(mediaIsVideo){
        [cameraHelper saveVideoToDisk];
       // [cameraHelper addAnimation];
        //[cameraHelper startD:captionsView];
    }
    else{
        /*
        UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]), NO, 0.0);  //retina res
        [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        [captionElement.layer.presentationLayer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        //
         */
        //[cameraHelper saveImageToDisk];
        [cameraHelper saveImageToDisk:[self screenshot:UIDeviceOrientationPortrait isOpaque:NO usePresentationLayer:NO]];
    
        
    }
    
}

- (UIImage *)screenshot:(UIDeviceOrientation)orientation isOpaque:(BOOL)isOpaque usePresentationLayer:(BOOL)usePresentationLayer
{
    CGSize size;
    
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        size = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    } else {
        size = CGSizeMake(imageView.frame.size.height, imageView.frame.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0);
    
    if (usePresentationLayer) {
        [imageView.layer.presentationLayer renderInContext:UIGraphicsGetCurrentContext()];
    } else {
        [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


-(void)onMediaSavedToDisk{
    [saveMediaProgressView stopProgress];
    [saveMediaProgressView setProgressString:NSLocalizedString(@"progress_txt_suc", nil)];
}

-(void)onMediaSavedToDiskError{
    [saveMediaProgressView setProgressString:NSLocalizedString(@"progress_txt_err", nil)];
}

#pragma Animations

-(void)showTools{
    typeButton.hidden = isReply ? YES : NO;
    toolTip.hidden = isReply ? YES : NO;
    selfieButton.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         typeButton.alpha = 0.9;
                         toolTip.alpha = 0.9;
                         selfieButton.alpha = 0.9;
                         saveMediaButton.alpha = 0.0;
                            captionButton.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         saveMediaButton.hidden = YES;
                         captionButton.hidden = YES;

                     }];
}

-(void)hideTools{
    saveMediaButton.hidden = NO;
    captionButton.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         typeButton.alpha = 0.0;
                         toolTip.alpha = 0.0;
                         saveMediaButton.alpha = 0.9;
                         captionButton.alpha = 0.9;
                         
                     }
                     completion:^(BOOL finished){
                         typeButton.hidden = YES;
                         toolTip.hidden = YES;
                     }];
}

-(void)hideAllTools{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         typeButton.alpha = 0.0;
                         toolTip.alpha = 0.0;
                         cancelButton.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         typeButton.hidden = YES;
                         toolTip.hidden = YES;
                         cancelButton.hidden = YES;
                     }];
}

-(void)showButton:(UIButton *) button{
    button.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         button.alpha = 0.9;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)hideButton:(UIButton *) button{
    button.hidden = YES;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         button.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)showLabel:(UILabel *) label{
    label.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         label.alpha = 0.9;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}








#pragma Keyboard events

-(void)keyboardWillHide {
    if(titleTextField.text.length > 0){
        self.onCameraModeChanged(YES);
    }else{
        self.onCameraModeChanged(NO);
    }
    //self.replyFieldConstraint.constant = replyPosition;
    //self.replyFieldConstraintSimple.constant = replyPosition;
}

-(void)keyboardWillChange:(NSNotification *)note {
    
    
}

-(void)keyboardWillShow:(NSNotification *)note {
    NSDictionary* info = [note userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    //self.replyFieldConstraintSimple.constant = replyPosition + keyboardSize.height;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)hideKeyboard{
    if([titleTextField isFirstResponder]){
        titleTextField.text = @"";
        [titleTextField resignFirstResponder];
    }else{
      
    }
}

#pragma Constraints

-(void)addConstraintsToButton:(UIView *)view withButton:(UIButton *) button withPoint:(CGPoint) xy fromLeft:(bool) left fromTop:(bool) top{
    button.translatesAutoresizingMaskIntoConstraints = NO;
    if(left)
    {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeadingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:xy.x]];
        
    }else{
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:xy.x]];
    }
    
    if(top){
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTopMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:xy.y]];
    }
    
    else{
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottomMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:xy.y]];
    }
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
}

-(void)addTooltipConstraint:(UIView *)view withLabel:(UILabel *) label{
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:label
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:label
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:80.0]];
}

-(void)addConstraintsToButton:(UIView *)view withButton:(UIView *) button withPoint:(CGPoint) xy fromLeft:(bool) left{
    button.translatesAutoresizingMaskIntoConstraints = NO;
    if(left)
    {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeadingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:xy.x]];
        
    }else{
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:xy.x]];
    }
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:button
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:xy.y]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
}

-(void)viewDidDisappear:(BOOL)animated{
    if([cameraHelper sessionIsRunning]){
        [cameraHelper stopCameraSession];
    }
}

@end
