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
@property (strong) CameraViewController *camera;
@property (nonatomic) int startY;
-(void)attachViews:(OverlayViewController *) x withY:(OverlayViewController *) y;
-(OverlayViewController *)createViewControllerWithStoryboardId:(NSString *) identifier;
-(void)attachSuperButtonToView;
-(void)onTap:(NSNumber *) mode;
-(void)prepareCamera;
-(void)onCameraOpen;
-(void)onCameraClose;
-(void)onCancelTap;
-(void)onMediaPosted:(BucketModel *) bucket;
-(void)onMediaPostedDrop:(DropModel *)drop;
-(void)addConstraints:(UIView *) view;
-(void)onImageTaken:(UIImage *)image withText:(NSString *) text;
-(void)onVideoTaken:(NSData *) video withImage:(UIImage *) image withtext:(NSString *) text;
-(void)attachCameraToView:(UIView *)view;
-(void)showCamera;
-(void)increaseProgress:(int) progress;
-(void)addErrorMessage:(UIView *) view;
-(void)hideError;
-(void)initCameraView;
-(void)setReplyMode:(BOOL) replyMode;
-(void)disableReply;
-(void)enableReply;
-(UIView *)getProgressIndicator;
@end
