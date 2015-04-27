//
//  FeedInterface.h
//  wave
//
//  Created by Simen Lie on 17/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedInterface <NSObject>
-(void)scrollUp;
-(void)prepareCamera:(UIView *) view;
-(void)onCameraOpen;
-(void)oncameraClose;
-(void)onImageTaken:(UIImage *)image;
-(void)onCameraReady;
-(void)onFocusGained;
@end
