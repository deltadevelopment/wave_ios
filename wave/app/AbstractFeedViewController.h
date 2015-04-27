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
-(void)scrollUp;
-(void)prepareCamera:(UIView *)view;
@property (nonatomic, copy) void (^onExpand)(void);
-(void)onCameraOpen;
-(void)oncameraClose;
-(void)onImageTaken:(UIImage *)image;
-(void)onCameraReady;
-(void)onFocusGained;
@end
