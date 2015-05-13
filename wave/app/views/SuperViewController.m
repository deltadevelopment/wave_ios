//
//  SuperViewController.m
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperViewController.h"
#import "UIHelper.h"
#import "CameraViewController.h"
#import "InfoViewController.h"
#import "GraphicsHelper.h"
#import "ColorHelper.h"
#import "NotificationHelper.h"
#import "BucketModel.h"
@interface SuperViewController ()

@end

@implementation SuperViewController{
    OverlayViewController *xView;
    OverlayViewController *yView;
    InfoViewController *infoView;
    bool infoIsVisible;
    UIVisualEffectView  *blurEffectView;
    UIView *progressIndicator;
    UIImageView *tickView;
    UIView *errorView;
    UIButton *crossButton;
    NotificationHelper *notificationHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    infoView = (InfoViewController *)[self createViewControllerWithStoryboardId:@"infoView"];
    infoView.view.alpha = 0.0;
    [self initSuperButton];
    
     [self initCameraView];
    
    progressIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 4)];
    progressIndicator.backgroundColor = [ColorHelper blueColor];
    progressIndicator.hidden = YES;
    
    errorView =[[UIView alloc] initWithFrame:CGRectMake(0, -50, [UIHelper getScreenWidth], 50)];
    errorView.backgroundColor = [ColorHelper redColor];
    [self.view addSubview:errorView];
   crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame = CGRectMake([UIHelper getScreenWidth] - 40,15 , 20, 20);
                             
    [crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(dismissError) forControlEvents:UIControlEventTouchUpInside];
    [errorView addSubview:crossButton];
    
    tickView = [[UIImageView alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth]/2-25, [UIHelper getScreenHeight]/2-25, 50, 50)];
    tickView.image = [UIImage imageNamed:@"tick.png"];
    tickView.alpha = 0.0;
    tickView.hidden = YES;
    [self.view addSubview:tickView];
    [self.view addSubview:progressIndicator];
   
 
}

-(void)initCameraView{
    _camera = [[CameraViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    _camera.onCameraReady = ^{
        [weakSelf showCamera];
    };
    _camera.onCameraOpen =^{
        [weakSelf onCameraOpen];
    };
    _camera.onCameraClose=^{
        [weakSelf onCameraClose];
    };
    _camera.onImageTaken =^(UIImage*(image),NSString *(text)){
        [weakSelf onImageTaken:image withText:text];
    };
    _camera.onVideoTaken =^(NSData *(video), UIImage *(image),NSString*(text)){
        [weakSelf onVideoTaken:video withImage:image withtext:text];
    };
    _camera.onImageReady=^{
        [weakSelf onImageReady];
    };
    _camera.onCameraCancel=^{
        [weakSelf onCameraCancel];
    };
    _camera.onPictureDiscard=^{
        [weakSelf onPictureDiscard];
    };
    _camera.onPictureUploading=^{
        [weakSelf onPictureUploading];
    };
    _camera.onVideoRecorded =^{
        [weakSelf onVideoRecorded];
    };
    _camera.onCameraModeChanged = ^(bool(canChange)){
        [weakSelf onCameraModeChanged:canChange];
    };
    _camera.onNotificatonShow=^(NSString *(message)){
        [weakSelf onNotification:message];
    };
    _camera.onProgression = ^(int(progression)){
        [weakSelf increaseProgress:progression];
    };
    _camera.onNetworkError = ^(UIView *(view)){
        [weakSelf addErrorMessage:view];
    };
    _camera.onNetworkErrorHide=^{
        [weakSelf hideError];
    };
    _camera.onMediaPosted=^(BucketModel *(bucket)){
        [weakSelf onMediaPosted:bucket];
    };
}


-(void)onMediaPosted:(BucketModel *) bucket{

}
-(void)onNotification:(NSString *) message{
    notificationHelper =[[NotificationHelper alloc] initNotification];
    [notificationHelper setNotificationMessage:message];
    [notificationHelper addNotificationToView:self.navigationController.view];
}

-(void)onVideoRecorded{
    [self.superButton videoRecorded];
}

-(void)addErrorMessage:(UIView *) view{
    errorView.hidden = NO;
    self.superButton.hasError = YES;
    if([view superview] == errorView){
        NSLog(@"SKJEDDE");
    
        
    }else{
     [errorView addSubview:view];
        [errorView insertSubview:crossButton aboveSubview:view];
    
    }
     errorView.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = errorView.frame;
                         frame.origin.y = 0;
                         errorView.frame = frame;
                         [errorView layoutIfNeeded];
                     }
                     completion:nil];
   
}
-(void)dismissError{
    NSLog(@"here");
    self.superButton.hasError = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = errorView.frame;
                         frame.origin.y = -50;
                         errorView.frame = frame;
                         [errorView layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                          errorView.hidden = YES;
                     }];
}

-(void)hideError{
    [self dismissError];
}

-(void)increaseProgress:(int) progress{
    if(progressIndicator.hidden){
        progressIndicator.hidden = NO;
    }
    
    float maxWidth = [UIHelper getScreenWidth];
    float percentageOfMax = (progress * maxWidth)/100;
    progressIndicator.frame = CGRectMake(0, 0, percentageOfMax, 4);
    if(progress == 100){
        progressIndicator.hidden = YES;
        NSLog(@"HIDING PROGRESS");
        [self animateTick];
        
    }
    
}

-(void)animateTick{
    tickView.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         tickView.alpha = 0.8;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.3f
                                               delay:0.5f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              tickView.alpha = 0.0;
                                              [infoView.view layoutIfNeeded];
                                          }
                                          completion:nil];
                     }];
}

-(void)onPictureUploading{
    [self.superButton animateProgress];
}
-(void)onCameraCancel{
    [self.superButton tapCancelButton];
}

-(void)onPictureDiscard{
    [self.superButton discard];
}

-(void)onImageReady{
    self.superButton.lockActions = NO;
}

-(void)prepareCamera{
    [self.view insertSubview:_camera.view atIndex:0];
}

-(void)onImageTaken:(UIImage *)image withText:(NSString *) text{
    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[GraphicsHelper imageByScalingAndCroppingForSize:size img:image]]];
}
-(void)onVideoTaken:(NSData *) video withImage:(UIImage *) image withtext:(NSString *) text{

}

-(void)showCamera{
    NSLog(@"Sow");
}

-(void)onDragX:(NSNumber *) xValue{
    if(xView != nil){
        [xView onDragX:xValue];
    }
    
}

-(void)onCancelTap{
    NSLog(@"ccanceltap");
    
    [self.camera closeCamera];
}
-(void)onDragY:(NSNumber *) yValue{
    if(yView != nil){
        [yView onDragY:yValue];
    }
    
}
-(void)onDragStartedX{
    if(xView != nil){
        [xView onDragStarted];
    }
    
}
-(void)onDragStartedY{
    if(yView != nil){
        [yView onDragStarted];
    }
    
}
-(void)onDragEndedX{
    if(xView != nil){
        [xView onDragEnded];
    }
    
}
-(void)onDragEndedY{
    if(yView != nil){
        [yView onDragEnded];
    }
    
}

-(void)onDragSwitchedFromX{
    if(xView != nil){
        [xView onDragSwitched];
    }
    
}

-(void)onDragSwitchedFromY{
    if(yView != nil){
        [yView onDragSwitched];
    }
    
}
-(void)onDragInStartArea{
    if(!infoIsVisible){

        infoIsVisible = YES;
        infoView.xLineView.alpha = 0.4;
        infoView.yLineView.alpha = 0.4;
        infoView.view.alpha = 1.0;
        //blurEffectView.alpha = 1.0;
       // infoView.xButtonLeftConstraint.constant = 350;
        /*
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             infoView.view.alpha = 0.9;
                         }
                         completion:^(BOOL finished){
                             
                             
                             [UIView animateWithDuration:0.4f
                                                   delay:0.0f
                                                 options: UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  infoView.xLineView.alpha = 1;
                                                  infoView.yLineView.alpha = 1;
                                                  //infoView.xButtonLeftConstraint.constant = 10;
                                                  [infoView.view layoutIfNeeded];
                                              }
                                              completion:nil];
                         }];
         */
    }
 
   
    
}

-(void)onDragInStartAreaEnded{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         infoView.view.alpha = 0.0;
                         blurEffectView.alpha = 0.0;
                         infoIsVisible = NO;
                     }
                     completion:nil];
   
}
-(void)addBlur{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    // blurEffectView.alpha = 0.9;
    [self.view insertSubview:blurEffectView belowSubview:[self.superButton getButton]];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
}
-(void)onTap:(NSNumber *)mode{
    [_camera onTap:mode];
}

-(void)onCameraOpen{
    [_camera prepareCamera:YES withReply:NO];
}
-(void)onCameraClose
{
    
}

-(void)attachSuperButtonToView{
    _superButton = [[SuperButton alloc]init:self.view];
}


-(void)initSuperButton{
    [self attachSuperButtonToView];
    __weak typeof(self) weakSelf = self;
    self.superButton.onDragX =^(NSNumber*(xValue)){
        [weakSelf onDragX:xValue];
    };
    self.superButton.onErrorDismissed=^{
        [weakSelf dismissError];
    };
    self.superButton.onDragY =^(NSNumber*(yValue)){
        [weakSelf onDragY:yValue];
    };
    self.superButton.onDragStartedX =^{
        [weakSelf onDragStartedX];
    };
    self.superButton.onDragStartedY =^{
        [weakSelf onDragStartedY];
    };
    self.superButton.onDragEndedX =^{
        [weakSelf onDragEndedX];
    };
    self.superButton.onDragEndedY =^{
        [weakSelf onDragEndedY];
    };
    self.superButton.onTap = ^(NSNumber*(mode)){
        [weakSelf onTap:mode];
    };
    self.superButton.onDragSwitchedFromX = ^{
        [weakSelf onDragSwitchedFromX];
    };
    self.superButton.onDragSwitchedFromY = ^{
        [weakSelf onDragSwitchedFromY];
    };
    self.superButton.onDragInStartArea = ^{
        [weakSelf onDragInStartArea];
    };
    self.superButton.onDragInStartAreaEnded = ^{
        [weakSelf onDragInStartAreaEnded];
    };
    
    self.superButton.onCancelTap = ^{
        [weakSelf onCancelTap];
    };
    
    self.superButton.onLongPressStarted =^{
        [weakSelf onLongPressStarted];
    };
    self.superButton.onLongPressEnded = ^{
        [weakSelf onLongPressEnded];
    };
    
}

-(void)onCameraModeChanged:(bool) canChange
{
    self.superButton.shouldChangeMode = canChange;
}

-(void)onLongPressStarted{
    [_camera startRecording];
}
-(void)onLongPressEnded{
    [_camera stopRecording];
}


-(OverlayViewController *)createViewControllerWithStoryboardId:(NSString *) identifier
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    OverlayViewController  *viewController = [sb instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}

-(void)attachCameraToView:(UIView *)view{
    [self addConstraintsToCamera:view];
}

-(void)attachViews:(OverlayViewController *) x withY:(OverlayViewController *) y
{
    [self addBlur];
    blurEffectView.alpha = 0.0;
    xView = x;
    yView = y;
    [self.view insertSubview:infoView.view belowSubview:[self.superButton getButton]];
    [self addConstraints:infoView.view];
    
    [infoView.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    if(xView != nil)
    {
        infoView.xLineView.hidden = NO;
        [_superButton enableDragX];
        xView.changeIcon =^(UIImage*(img)){
            [weakSelf changeIcon:img];
        };
        [self.view insertSubview:xView.view belowSubview:[self.superButton getButton]];
        [self addConstraints:xView.view];
    }
    if(yView != nil)
    {
        infoView.yLineView.hidden = NO;
        [_superButton enableDragY];
        [self.view insertSubview:yView.view belowSubview:[self.superButton getButton]];
        [self addConstraints:yView.view];
    }
     [self prepareCamera];
  
}

-(void)changeIcon:(UIImage *) img{
    [_superButton changeIcon:img];

}

-(void)addConstraints:(UIView *) view
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];

}

-(void)addConstraintsToCamera:(UIView *) view
{
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_camera
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_camera
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_camera
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_camera
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
