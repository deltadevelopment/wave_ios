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
@interface CameraViewController ()

@end

@implementation CameraViewController{
    CameraHelper *cameraHelper;
    CircleIndicatorView *circleIndicatorView;
    UIButton *selfieButton;
    UIButton *saveMediaButton;
    ProgressView *saveMediaProgressView;
    bool cameraMode;
    bool frontFacingMode;
    bool imageReadyForUpload;
    UIImage *imgTaken;
    UIButton *cancelButton;
    UIButton *typeButton;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mediaPlayer = [[MediaPlayerViewController alloc] init];
    mediaPlayer.onVideoFinishedPlaying = ^{
        
    };

    bucketTypes = [[NSMutableArray alloc]init];
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
    
    saveMediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveMediaButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"download-icon.png"] withSize:150] forState:UIControlStateNormal];
    saveMediaButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11,11, 11);
    saveMediaButton.userInteractionEnabled = YES;
    saveMediaButton.alpha = 0.0;
    [saveMediaButton addTarget:self action:@selector(saveMediaToDisk:) forControlEvents:UIControlEventTouchDown];
    saveMediaButton.hidden = YES;
    //[selfieButton setBackgroundImage:[UIImage imageNamed:@"bucket.png"] forState:UIControlStateNormal];
    cameraHelper = [[CameraHelper alloc]init];
    __weak typeof(self) weakSelf = self;

        cameraHelper.onVideoRecorded = ^(NSData *(video)){
            [weakSelf onVideorecorded:video];
        };
    cameraHelper.onMediaSavedToDisk = ^{
        [weakSelf onMediaSavedToDisk];
    };
    cameraHelper.onMediaSavedToDiskError = ^{
        [weakSelf onMediaSavedToDiskError];
    };
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toolTip = [[UILabel alloc]init];
    
    [self initBucketTypes];
    [self initProgressView];
    // [self initUI];
}

-(void)initProgressView{
    float width = [UIHelper getScreenWidth] - 40;
    saveMediaProgressView = [[ProgressView alloc] initWithFrame:CGRectMake(([UIHelper getScreenWidth]/2) - (width/2),
                                                                     ([UIHelper getScreenHeight]/2) - 35,
                                                                     width,
                                                                     70)];
}

-(void)onVideorecorded:(NSData *) video{
    lastRecordedVideo = video;
    intMode = 2;
    mediaIsVideo = YES;
    mediaPlayer.view.hidden = NO;
    imageReadyForUpload = YES;
    mediaPlayer.view.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    [self.view insertSubview:mediaPlayer.view belowSubview:saveMediaButton];
    [mediaPlayer setVideo:video withId:-1];
    [mediaPlayer playVideo];
    self.onVideoRecorded();
    [self showButton:cancelButton];
    [self hideTools];
    imgTaken = [mediaPlayer getVideoThumbnail];
   // [mediaPlayer ]
}


-(void)initBucketTypes{
    [bucketTypes addObject:[[BucketTypeModel alloc] initWithProperties:0 withDescription:@"Create new shared bucket" withIconPath:@"bucket-white.png"]];
    [bucketTypes addObject:[[BucketTypeModel alloc] initWithProperties:1 withDescription:@"Update your personal bucket" withIconPath:@"events-icon.png"]];
}

-(void)initUI{
    [self initCancelButton];
    [self initTypeButton];
    [self initToolTip];
    recordingProgressView = [[UIView alloc] initWithFrame:CGRectMake(([UIHelper getScreenWidth]/2) -40, [UIHelper getScreenHeight] - 85, 80, 80)];
    recordingProgressView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:recordingProgressView];
   // [self addConstraintsToButton:self.view withButton:recordingProgressView withPoint:CGPointMake(11, 10) fromLeft:NO];
}

-(void)initCancelButton{
    [self applyUIOnButton:cancelButton];
    [cancelButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"cross.png"] withSize:150] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [cancelButton addTarget:self action:@selector(tapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    [self addConstraintsToButton:self.view withButton:cancelButton withPoint:CGPointMake(11, 10) fromLeft:NO];
   // cancelButton.hidden = YES;
    cancelButton.alpha = 1.0;
    
}
-(void)initTypeButton{
    [self applyUIOnButton:typeButton];
    typeButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [typeButton addTarget:self action:@selector(tapTypeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:typeButton];
    [self addConstraintsToButton:self.view withButton:typeButton withPoint:CGPointMake(-4, 10) fromLeft:YES];
    typeButton.hidden = YES;
    typeButton.alpha = 0.0;
}

-(void)initToolTip{
    [UIHelper applyThinLayoutOnLabel:toolTip];
    [self.view addSubview:toolTip];
    toolTip.hidden = NO;
    toolTip.alpha = 0.0;
    [self addTooltipConstraint:self.view withLabel:toolTip];
    BucketTypeModel *bucketModel = [bucketTypes objectAtIndex:currentTypeIndex];
    [typeButton setImage:[UIHelper iconImage:[UIImage imageNamed:[bucketModel icon_path]] withSize:150] forState:UIControlStateNormal];
    toolTip.text = [bucketModel type_description];
}

-(void)tapCancelButton{
    imgTaken = nil;
    [imageView removeFromSuperview];
    if(intMode == 1){
        self.onCameraCancel();
    }
    else if (intMode == 2){
        if(mediaIsVideo){
            NSLog(@"HERE");
            [mediaPlayer stopVideo];
            mediaPlayer.view.hidden = YES;
            //[mediaPlayer.view removeFromSuperview];
            mediaIsVideo = NO;
        }
        if(frontFacingMode){
            [self prepareCamera:NO];
        }else{
            [self prepareCamera:YES];
        }
       
        intMode = 1;
        self.onPictureDiscard();
    }
}

-(void)tapTypeButton{
    currentTypeIndex ++;
    if(currentTypeIndex == [bucketTypes count]){
        currentTypeIndex = 0;
    }
    BucketTypeModel *bucketModel = [bucketTypes objectAtIndex:currentTypeIndex];
    [typeButton setImage:[UIHelper iconImage:[UIImage imageNamed:[bucketModel icon_path]] withSize:150] forState:UIControlStateNormal];
    toolTip.text = [bucketModel type_description];
}

-(void)applyUIOnButton:(UIButton *) button{
    button.layer.cornerRadius = 25;
    [button setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
}

-(void)viewDidAppear:(BOOL)animated{
   // frontFacingMode = NO;
}

-(void)flipCameraView:(id)sender{
    frontFacingMode = frontFacingMode ? NO : YES;
    [cameraHelper CameraToggleButtonPressed:frontFacingMode];
}

-(void)saveMediaToDisk:(id)sender{
    [saveMediaProgressView setProgressString:NSLocalizedString(@"progress_txt", nil)];
    [saveMediaProgressView startProgress];
    if(mediaIsVideo){
        [cameraHelper saveVideoToDisk];
        
    }
    else{
        [cameraHelper saveImageToDisk];
    }
    
}


-(void)onMediaSavedToDisk{
    [saveMediaProgressView stopProgress];
    [saveMediaProgressView setProgressString:NSLocalizedString(@"progress_txt_suc", nil)];
    [self animateProgressOut];
}

-(void)animateProgressOut{
    [UIView animateWithDuration:0.8f
                          delay:0.4f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         saveMediaProgressView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         saveMediaProgressView.hidden = YES;
                     }];
}

-(void)onMediaSavedToDiskError{
    [saveMediaProgressView setProgressString:NSLocalizedString(@"progress_txt_err", nil)];
    [self animateProgressOut];
}

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

-(void)prepareCamera:(bool)rearCamera{
    imgTaken = nil;
    mediaPlayer.view.hidden = YES;
    frontFacingMode = !rearCamera;
    [cameraHelper setView:self.view withRect:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    [cameraHelper initaliseVideo:rearCamera];

    [self.view addSubview:selfieButton];
    [self.view addSubview:saveMediaButton];
    [self.view addSubview:saveMediaProgressView];
    [self initUI];
    [self showTools];
    [self addConstraintsToButton:self.view withButton:selfieButton withPoint:CGPointMake(0, -64) fromLeft:NO fromTop:YES];
    [self addConstraintsToButton:self.view withButton:saveMediaButton withPoint:CGPointMake(-4, 10) fromLeft:YES fromTop:NO];
    self.onCameraReady();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTap:(NSNumber *) mode{
    intMode = [mode intValue];
    if(intMode == 1){
        cameraMode = YES;
        self.onCameraOpen();
    }
    else if(intMode == 2){
        [self takePicture];
    }
    else if(intMode == 0){
        if(imageReadyForUpload){
            [self uploadMedia];
        }else{
            //camera is not ready
            
        }
    }
}

-(void)startRecording
{
    [cameraHelper startRecording];
    isRecording = YES;
    NSLog(@"starting recording");
    circleIndicatorView = [[CircleIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [recordingProgressView addSubview:circleIndicatorView];
    
    [circleIndicatorView setIndicatorWithMaxTime:10];
    [self hideAllTools];
    [self hideButton:selfieButton];
    //Start recording
    
    recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(decrementSpin) userInfo:nil repeats:YES];
    
}

-(void)stopRecording
{
    //sjekke her om videoen allerede er stoppet. kan skje hvis tiden går ut å brukeren deretter slipper knappen
    if(isRecording){
        [cameraHelper stopRecording];
        isRecording = NO;
        NSLog(@"stopping recording");
        [recordTimer invalidate];
        [circleIndicatorView removeFromSuperview];
        circleIndicatorView.percent = 0;
        [self showButton:cancelButton];
    }
    
}

-(void)decrementSpin{
    [circleIndicatorView incrementSpin];
    NSLog(@"spinn");
    if(circleIndicatorView.percent >100){
        //STOP RECORDING
        NSLog(@"stop recording");
        [self stopRecording];
    }
}

-(void)uploadMedia{
    // self.onPictureUploading();
    
    if(mediaIsVideo){
        [mediaPlayer stopVideo];
    }
    
    //LAST OPP HER
    
    self.onCameraClose();
    cameraMode = NO;
    imageReadyForUpload = NO;
    if(mediaIsVideo){
        self.onVideoTaken(lastRecordedVideo, imgTaken);
    }
    else{
        self.onImageTaken(imgTaken);
    }

            mediaIsVideo = NO;
   
}

-(void)closeCamera{
    cameraMode = NO;
    self.onCameraClose();
    [cameraHelper stopCameraSession];
}

-(void)takePicture{
    [cameraHelper capImage:self withSuccess:@selector(imageWasTaken:)];
}

-(void)imageWasTaken:(UIImage *)image{
    imgTaken = image;

    if(frontFacingMode){
        //Flip image
        NSLog(@"FRONT FACING MODE");
        imgTaken = [GraphicsHelper mirrorImageWithImage:imgTaken];
    }
    
    
    imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = imgTaken;
    [self.view insertSubview:imageView belowSubview:saveMediaButton];
    imageReadyForUpload = YES;
    self.onImageReady();
    [self hideTools];
}

-(void)hideTools{
    saveMediaButton.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         typeButton.alpha = 0.0;
                         toolTip.alpha = 0.0;
                         saveMediaButton.alpha = 0.9;
                         
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

-(void)showTools{
    typeButton.hidden = NO;
    toolTip.hidden = NO;
    selfieButton.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         typeButton.alpha = 0.9;
                         toolTip.alpha = 0.9;
                         selfieButton.alpha = 0.9;
                         saveMediaButton.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         saveMediaButton.hidden = YES;
                     }];
}

-(UIView *)getCameraView{
    return [cameraHelper getView];
}

-(AVCaptureVideoPreviewLayer *)getLayer{
    return [cameraHelper getLayer];
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
    /*
     [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==50)]"
     options:0
     metrics:nil
     views:NSDictionaryOfVariableBindings(button)]];
     [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]"
     options:0
     metrics:nil
     views:NSDictionaryOfVariableBindings(button)]];
     */
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
