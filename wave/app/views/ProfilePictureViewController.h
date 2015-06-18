//
//  ProfilePictureViewController.h
//  wzup
//
//  Created by Simen Lie on 27/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraHelper.h"
@interface ProfilePictureViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *camView;
- (IBAction)cameraAction:(id)sender;
@property(nonatomic, strong) CameraHelper *cameraHelper;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) UIButton *cameraButton2;
- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
