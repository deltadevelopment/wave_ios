//
//  ProfilePictureViewController.m
//  wzup
//
//  Created by Simen Lie on 27/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfilePictureViewController.h"
#import "CameraHelper.h"
#import "UIHelper.h"
#import "GraphicsHelper.h"
#import "ColorHelper.h"
#import "PartialTransparentBlurView.h"
#import "MediaModel.h"
#import "UserModel.h"
@interface ProfilePictureViewController (){
    //MediaHelper *mediaHelper;
    UIImage *imgTaken;
    CGRect defaultSize;
    //ImageHelper *imageHelper;
    bool hasTakenPhoto;
    UIImageView *imageView;
    UIImage *imageForUplaod;
    UIVisualEffectView  *blurEffectView;
    UIView *progressIndicator;
}

@end

@implementation ProfilePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // imageHelper = [[ImageHelper alloc]init];
   // mediaHelper = [[MediaHelper alloc]init];
    //cameraHelper = [[CameraHelper alloc] init];
    self.camView.hidden = YES;
   self.cameraButton.hidden = YES;
    self.cameraButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton2.frame = CGRectMake([UIHelper getScreenWidth]/2 - 25, [UIHelper getScreenHeight] - 150, 50, 50);
    [self.cameraButton2 setImage:[UIImage imageNamed:@"camera-icon.png"] forState:UIControlStateNormal];
    [self.cameraButton2 setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.cameraButton2 setBackgroundColor:[ColorHelper purpleColor]];
    self.cameraButton2.alpha = 0.0;
    self.cameraButton2.layer.cornerRadius = 25;
    self.cameraButton2.clipsToBounds = YES;
    [self.cameraButton2 addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initCameraHelper];
    
    
    [self addBlur];
    
    progressIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 4)];
    progressIndicator.backgroundColor = [ColorHelper blueColor];
    progressIndicator.hidden = YES;
   
     //
   
    
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
        //Show tick here
        
    }
    
}

-(void)prepareCamera{
    
    
    //[self.cameraHelper setView:self.view withRect:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
   
    if(![self.cameraHelper isInitialised]){
        [self.cameraHelper initaliseLightVideo:NO withView:self.camView];
        if (imageView == nil) {
            NSLog(@"the width is %f", [UIHelper getScreenWidth]);
            float val = ([UIHelper getScreenHeight]/2)-([UIHelper getScreenWidth]/2) - 32;
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -32, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setTranslatesAutoresizingMaskIntoConstraints:YES];
           //[imageView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3f]];
        }
        
        [self.view insertSubview:imageView aboveSubview:self.camView];
        [self.view insertSubview:blurEffectView belowSubview:self.cameraButton];
        [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view insertSubview:self.cameraButton2 aboveSubview:blurEffectView];
         [self.view insertSubview:progressIndicator aboveSubview:blurEffectView];
        
        //add auto layout constraints so that the blur fills the screen upon rotating device
        
       // [self.cameraHelper CameraToggleButtonPressed:YES];
    }
    
    else{
        // [cameraHelper initRecording];
    }
    
    
    //[self.cameraHelper startPreviewLayer];
}


-(void)initCameraHelper{
    self.cameraHelper = [[CameraHelper alloc]init];
}



-(void)viewDidAppear:(BOOL)animated{
    [self prepareCamera];
    self.camView.hidden = NO;
  
   // [self.view insertSubview:self.cameraButton aboveSubview:self.camView];
//self.camView.transform = CGAffineTransformMakeScale(0,0);
  //  self.camView.layer.cornerRadius = self.camView.frame.size.width/2;
    //self.camView.layer.masksToBounds = YES;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                        // self.camView.transform = CGAffineTransformIdentity;
                         //self.camView.layer.cornerRadius = self.camView.frame.size.width/2;
                         //self.camView.layer.masksToBounds = YES;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.6f
                                               delay:0.0f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.cameraButton2.alpha = 1;
                                          }
                                          completion:^(BOOL finished){
                                              //READY to take picture
                                              
                                          }];
                         
                     }];
}

-(void)addBlur{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    // blurEffectView.alpha = 0.9;
    blurEffectView.alpha = 1.0f;

    
    [self addMaskToHoleView];

    
}

- (void)addMaskToHoleView {
    CGRect bounds = blurEffectView.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    static CGFloat const kRadius = 100;
    /*
    CGRect const circleRect = CGRectMake(CGRectGetMidX(bounds) - kRadius,
                                         CGRectGetMidY(bounds) - kRadius,
                                         2 * kRadius, 2 * kRadius);
    */
    
    CGRect circleRect = CGRectMake(0, ([UIHelper getScreenHeight]/2)-([UIHelper getScreenWidth]/2) - 32, [UIHelper getScreenWidth], [UIHelper getScreenWidth]);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [path appendPath:[UIBezierPath bezierPathWithRect:bounds]];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    blurEffectView.layer.mask = maskLayer;
}


-(void)pictureWasTaken:(UIImage *) imageFromCamera{
    imgTaken = imageFromCamera;
    if (imageView == nil) {
        
    }else{
        //imageView
    }
    //imageForUplaod = [self cropImageWithSize:CGSizeMake(480, 480) withY:80];
    //[UIImage imageNamed:@"miranda-kerr.jpg"];
    CGSize size =  CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    //[imageView setBackgroundColor:[UIColor redColor]];
    imageForUplaod = [self cropImageWithSize:CGSizeMake(480, 480) withY:80];
       NSLog(@"the cropped image size is %f %f", imageForUplaod.size.width, imageForUplaod.size.height);
   
    //imageForUplaod = [self croptere];
   // imageForUplaod = [UIImage imageWithData:UIImagePNGRepresentation(imageForUplaod)];
    [imageView setImage: imageForUplaod];//[self cropImageWithSize:CGSizeMake(size.width, size.height - 80) withY:80]];

    //[self.camView insertSubview:imageView atIndex:0];
    
    self.cameraButton.imageView.image = [UIImage imageNamed:@"cross-white.png"];
    self.cameraButton2.backgroundColor =[UIColor colorWithRed:0.149 green:0.149 blue:0.149 alpha:1];
    
    //imgTaken = customScreenShot;
    //[self cropImage];
    //[feedController setSelector:@selector(mediaIsUploaded:) withObject:self];
        //[feedController sendImageToServer:data];

}

-(void)cropIt{
  
    

}

- (UIImage*) getSubImageFrom: (UIImage*) img WithRect: (CGRect) rect {
       UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.width));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rect.size.width, 0);
    CGContextScaleCTM(context, -1.0, 1.0);
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, rect.size.width, rect.size.height);
 //   NSLog(@"imag size is %f %f", img.size.width, img.size.height);
  //  NSLog(@"rect size is %f %f", rect.size.width, rect.size.height);
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.width));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
   
    UIGraphicsEndImageContext();
     // NSLog(@"the cropped image size is %f %f", subImage.size.width, subImage.size.height);
    return subImage;
}

-(UIImage *)cropImageWithSize:(CGSize) size withY:(float)yPos{
    CGRect rect = CGRectMake(0, ([UIHelper getScreenHeight]/2)-([UIHelper getScreenWidth]/2),[UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    
    /*
    CGImageRef imageRef = CGImageCreateWithImageInRect([imgTaken CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    */
    UIImage *temp = [self getSubImageFrom:imgTaken WithRect:rect];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:temp.CGImage
                                                scale:temp.scale
                                          orientation:UIImageOrientationUpMirrored];
    
    
   
    
    //SEND FLIPPED Image to Server
    return temp;
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

- (IBAction)cameraAction:(id)sender {
    //TAKE picture
    
    if(!hasTakenPhoto){
        [self.cameraHelper capImage:self withSuccess:@selector(pictureWasTaken:)];
        [imageView setImage:nil];
        imageView.hidden = NO;
    }else{
        //[self.view insertSubview:self.cameraButton2 aboveSubview:blurEffectView]
        self.cameraButton2.imageView.image = [UIImage imageNamed:@"camera-icon.png"];
        [self.cameraButton2 setBackgroundColor:[ColorHelper purpleColor]];
        imageView.hidden = YES;
        //[imageView removeFromSuperview];
    
        [self.cameraHelper addImageOutput];
        [self.cameraHelper startPreviewLayer];
    }
    
    hasTakenPhoto = hasTakenPhoto ? NO : YES;
    
}

- (IBAction)doneAction:(id)sender {
    //upload here
    //[self crop2];
    // UIImage *image = [self imageWithImage:imageForUplaod scaledToSize:CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenWidth])];
    //NSLog(@"the cropped image size is %f %f", imageForUplaod.size.width, imageForUplaod.size.height);
    MediaModel *mediaModel = [[MediaModel alloc] init:UIImagePNGRepresentation(imageForUplaod)];
    [mediaModel setEndpoint:@"user"];
    UserModel *user = [[UserModel alloc] initWithDeviceUser];
    [user setMediaModel:mediaModel];
    __weak typeof(self) weakSelf = self;
    [user upload:^(){
        [user saveChanges:^(ResponseModel *response, UserModel *user){
            [weakSelf dismiss];
        } onError:^(NSError *error){
        
        }];
    } onProgress:^(NSNumber *progress){
        [self increaseProgress:[progress intValue]];
    } onError:^(NSError *error){
    
    
    }];
   // [self dismiss];
}

- (IBAction)cancelAction:(id)sender {
    [self dismiss];
}

-(UIImage *)cropNow{
    UIImage *image = imgTaken;
    
    // Create rectangle from middle of current image
    CGRect croprect = CGRectMake(image.size.width / 4, image.size.height / 4 ,
                                 (image.size.width / 2), (image.size.height / 2));
    
    // Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
    
    // Create new cropped UIImage
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:imgTaken.scale orientation:imgTaken.imageOrientation];
    
    CGImageRelease(imageRef);
    return croppedImage;
}



-(void)dismiss{
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([self.cameraHelper sessionIsRunning]){
            [self.cameraHelper stopCameraSession];
        }
    
    });
     [self dismissViewControllerAnimated:YES completion:nil];
}






@end
