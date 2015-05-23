//
//  ProfilePictureViewController.h
//  wzup
//
//  Created by Simen Lie on 27/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilePictureViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *camView;
- (IBAction)cameraAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
