//
//  SuperViewController.h
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultViewController.h"
#import "SuperButton.h"
#import "OverlayViewController.h"
#import "CameraViewController.h"
@interface SuperViewController : DefaultViewController
@property(strong, nonatomic) SuperButton *superButton;
@property (strong, nonatomic) CameraViewController *camera;
-(void)attachViews:(OverlayViewController *) x withY:(OverlayViewController *) y;
-(OverlayViewController *)createViewControllerWithStoryboardId:(NSString *) identifier;
-(void)attachSuperButtonToView;
-(void)onTap;
-(void)prepareCamera;
-(void)onCameraOpen;
-(void)onCameraClose;
-(void)onCancelTap;
-(void)addConstraints:(UIView *) view;
-(void)onImageTaken:(UIImage *)image;
-(void)attachCameraToView:(UIView *)view;
-(void)showCamera;
@end
