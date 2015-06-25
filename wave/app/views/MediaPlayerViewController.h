//
//  MediaPlayerViewController.h
//  wave
//
//  Created by Simen Lie on 08/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
@interface MediaPlayerViewController : UIViewController
@property (nonatomic, copy) void (^onVideoFinishedPlaying)(void);
-(void)setVideo:(NSData *) video withId:(int) Id;
-(void)playVideo;
-(void)stopVideo;
-(void)pauseVideo;
-(void)playVideoOnce;
-(UIImage *)getVideoThumbnail;
@property (nonatomic) BOOL isPlaying;
-(void)mute;
@end
