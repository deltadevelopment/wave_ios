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

-(void)setVideo:(NSData *) video;
-(void)playVideo;
-(void)stopVideo;
-(UIImage *)getVideoThumbnail;
@end
