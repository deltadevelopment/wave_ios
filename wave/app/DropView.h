//
//  DropView.h
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropView : UIImageView
@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UILabel *dropTitle;
@property (strong, nonatomic) UIView *topBar;
@property (nonatomic) BOOL hasVideo;
@property (nonatomic) BOOL isPlaying;
-(void)setMedia:(NSObject *) media withIndexId:(int) indexId;
-(void)dropWillHide;
-(void)playVideo;
-(void)stopVideo;
-(void)playMediaWithButton:(UIButton *) button;
@end
