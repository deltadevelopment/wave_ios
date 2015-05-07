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

@interface CameraViewController ()

@end

@implementation CameraViewController{
    CameraHelper *cameraHelper;
    UIButton *selfieButton;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
        bucketTypes = [[NSMutableArray alloc]init];
    selfieButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selfieButton setTitle:@"Selfie" forState:UIControlStateNormal];
    selfieButton.userInteractionEnabled = YES;
    [selfieButton addTarget:self action:@selector(flipCameraView:) forControlEvents:UIControlEventTouchDown];
   // selfieButton.frame = CGRectMake([UIHelper getScreenWidth]-60, 12, 50, 25);
  
    [selfieButton setTintColor:[UIColor whiteColor]];
    selfieButton.layer.borderWidth=1.0f;
    selfieButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    //[selfieButton setBackgroundImage:[UIImage imageNamed:@"bucket.png"] forState:UIControlStateNormal];
    cameraHelper = [[CameraHelper alloc]init];
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toolTip = [[UILabel alloc]init];
   
     [self initBucketTypes];
    // [self initUI];
    
}

-(void)initBucketTypes{
    [bucketTypes addObject:[[BucketTypeModel alloc] initWithProperties:0 withDescription:@"Create new shared bucket" withIconPath:@"bucket-white.png"]];
    [bucketTypes addObject:[[BucketTypeModel alloc] initWithProperties:1 withDescription:@"Update your personal bucket" withIconPath:@"events-icon.png"]];
}

-(void)initUI{
    [self initCancelButton];
    [self initTypeButton];
    [self initToolTip];
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
    if(intMode == 1){
        self.onCameraCancel();
    }
    else if (intMode == 2){
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
    frontFacingMode = NO;
}

-(void)flipCameraView:(id)sender{
    frontFacingMode = frontFacingMode ? NO : YES;
    [cameraHelper CameraToggleButtonPressed:frontFacingMode];
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
    [cameraHelper setView:self.view withRect:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    [cameraHelper initaliseVideo:rearCamera];
    [self.view addSubview:selfieButton];
    [self initUI];
    [self showTools];
    [self addConstraintsToButton:self.view withButton:selfieButton withPoint:CGPointMake(10, -64) fromLeft:NO fromTop:YES];
    self.onCameraReady();
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage{
    return [cameraHelper imageByScalingAndCroppingForSize:targetSize img:sourceImage];
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
             [self uploadImage];
        }else{
        //camera is not ready
           
        }
    }
}

-(void)uploadImage{
   // self.onPictureUploading();
    self.onCameraClose();
   cameraMode = NO;
   imageReadyForUpload = NO;
    self.onImageTaken(imgTaken);
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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = imgTaken;
    [self.view insertSubview:imageView belowSubview:cancelButton];
    imageReadyForUpload = YES;
    self.onImageReady();
    [self hideTools];
}

-(void)hideTools{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         typeButton.alpha = 0.0;
                         toolTip.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished){
                         typeButton.hidden = YES;
                         toolTip.hidden = YES;
                     }];
}

-(void)showTools{
    typeButton.hidden = NO;
    toolTip.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         typeButton.alpha = 0.9;
                         toolTip.alpha = 0.9;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(UIView *)getCameraView{
    return [cameraHelper getView];
}

-(AVCaptureVideoPreviewLayer *)getLayer{
    return [cameraHelper getLayer];
}

-(void)addConstraintsToButton:(UIView *)view withButton:(UIButton *) button withPoint:(CGPoint) xy fromLeft:(bool) left{
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
