//
//  AbstractFeedViewController.h
//  wave
//
//  Created by Simen Lie on 17/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedInterface.h"
@interface AbstractFeedViewController : UIViewController<FeedInterface>
//@property (nonatomic, copy) void (^onExpand)(void);
@property (nonatomic, copy) void (^onExpand)(UIImage*(bucketImage));
@property (nonatomic, copy) void (^onLockScreenToggle)(void);
-(void)scrollUp;
-(void)prepareCamera:(UIView *)view;
-(void)onCameraOpen;
-(void)oncameraClose;
-(void)onImageTaken:(UIImage *)image;
-(void)onCameraReady;
-(void)onFocusGained;
-(void)onVideoTaken:(NSData *) video withImage:(UIImage *)image;
-(void)onCancelTap;
@end
