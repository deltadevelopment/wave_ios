//
//  FeedInterface.h
//  wave
//
//  Created by Simen Lie on 17/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BucketModel.h"
#import "DropModel.h"
@protocol FeedInterface <NSObject>
-(void)scrollUp;
-(void)prepareCamera:(UIView *) view;
-(void)onCameraOpen;
-(void)oncameraClose;
-(void)onImageTaken:(UIImage *)image withText:(NSString *)text;
-(void)onMediaPosted:(BucketModel *) bucket;
-(void)onMediaPostedDrop:(DropModel *) drop;
-(void)onVideoTaken:(NSData *) video withImage:(UIImage *)image withtext:(NSString *)text;
-(void)onCameraReady;
-(void)onFocusGained;
-(void)onCancelTap;
-(void)increazeProgress:(int)progress;
@end
