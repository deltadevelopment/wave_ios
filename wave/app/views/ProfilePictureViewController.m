//
//  ProfilePictureViewController.m
//  wzup
//
//  Created by Simen Lie on 27/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfilePictureViewController.h"
#import "CameraHelper.h"
@interface ProfilePictureViewController (){
    //MediaHelper *mediaHelper;
    UIImage *imgTaken;
    CGRect defaultSize;
    //ImageHelper *imageHelper;
    bool hasTakenPhoto;
    UIImageView *imageView;
    CameraHelper *cameraHelper;
}

@end

@implementation ProfilePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // imageHelper = [[ImageHelper alloc]init];
   // mediaHelper = [[MediaHelper alloc]init];
    cameraHelper = [[CameraHelper alloc] init];
    self.camView.hidden = YES;
    self.cameraButton.alpha = 0.0;
    self.cameraButton.layer.cornerRadius = 25;
    self.cameraButton.clipsToBounds = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self showCamera];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
         
        });
    });
    
}

-(void)showCamera{
    CGRect imageRect = CGRectMake(0, 0, 480, 480);
    [cameraHelper initaliseVideo:NO withView:self.camView];
    [cameraHelper CameraToggleButtonPressed:YES];
}



-(void)viewDidAppear:(BOOL)animated{
    self.camView.hidden = NO;
    self.camView.transform = CGAffineTransformMakeScale(0,0);
    self.camView.layer.cornerRadius = self.camView.frame.size.width/2;
    self.camView.layer.masksToBounds = YES;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.camView.transform = CGAffineTransformIdentity;
                         self.camView.layer.cornerRadius = self.camView.frame.size.width/2;
                         self.camView.layer.masksToBounds = YES;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.6f
                                               delay:0.0f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.cameraButton.alpha = 1;
                                          }
                                          completion:^(BOOL finished){
                                              //READY to take picture
                                              
                                          }];
                         
                     }];
}


-(void)pictureWasTaken:(UIImage *) imageFromCamera{
    
    
    imgTaken = imageFromCamera;
    [self cropImage];
    self.cameraButton.imageView.image = [UIImage imageNamed:@"cross-white.png"];
    self.cameraButton.backgroundColor =[UIColor colorWithRed:0.149 green:0.149 blue:0.149 alpha:1];
    
    //imgTaken = customScreenShot;
    //[self cropImage];
        //[feedController setSelector:@selector(mediaIsUploaded:) withObject:self];
        //[feedController sendImageToServer:data];

}

-(void)cropIt{
  
    

}

- (UIImage*) getSubImageFrom: (UIImage*) img WithRect: (CGRect) rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}

-(void)cropImage{
    CGRect rect = CGRectMake(0, 80,480, 480);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imgTaken CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.camView.frame.size.width, self.camView.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *temp = [self getSubImageFrom:imgTaken WithRect:rect];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:temp.CGImage
                                                scale:temp.scale
                                          orientation:UIImageOrientationUpMirrored];
    
    
    imageView.image = flippedImage;
 
    
    [self.camView insertSubview:imageView atIndex:0];
    
    //SEND FLIPPED Image to Server
    
}

-(void)mediaIsUploaded:(NSNumber*) percentUploaded{
    NSLog(@"downloaded: %@", percentUploaded);
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
   // UILabel *loadingLabel = [currentCell uploadImageIndicatorLabel];
    /*
    if(loadingLabel != nil){
        loadingLabel.hidden = NO;
        double width = ([percentUploaded longLongValue]* screenWidth)/100 ;
        CGRect frame = loadingLabel.frame;
        NSLog(@"%f", width);
        frame.size.width = width;
        loadingLabel.frame = frame;
        [loadingLabel setNeedsDisplay];
    }*/
    if([percentUploaded  longLongValue] == 100){
        //loadingLabel.hidden = YES;
      //  [feedController SetStatusWithMedia:self withSuccess:@selector(statusIsSuccess:) withError:@selector(statusIsNotSuccess:)];
        
    }
    
    
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
         [cameraHelper capImage:self withSuccess:@selector(pictureWasTaken:)];
    }else{
        self.cameraButton.imageView.image = [UIImage imageNamed:@"camera-icon.png"];
        self.cameraButton.backgroundColor = [UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1];
        [imageView removeFromSuperview];
        [cameraHelper startPreviewLayer];
    }
    
    hasTakenPhoto = hasTakenPhoto ? NO : YES;
    
}
- (IBAction)doneAction:(id)sender {
    [self dismiss];
}

- (IBAction)cancelAction:(id)sender {
    [self dismiss];
}

-(void)dismiss{
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([cameraHelper sessionIsRunning]){
            [cameraHelper stopCameraSession];
        }
    
    });
     [self dismissViewControllerAnimated:YES completion:nil];
}






@end
