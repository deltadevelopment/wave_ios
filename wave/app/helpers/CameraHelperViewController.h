//
//  CameraHelperViewController.h
//  wave
//
//  Created by Simen Lie on 13.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>
#import <ImageIO/ImageIO.h>
@interface CameraHelperViewController : UIViewController
@property(nonatomic, retain) UIView *vImagePreview;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, retain) UIImageView *vImage;
@end
