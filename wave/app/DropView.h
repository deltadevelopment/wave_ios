//
//  DropView.h
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropModel.h"
@interface DropView : UIImageView
@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UILabel *dropTitle;
@property (strong, nonatomic) UILabel *dropTemperature;
@property (strong, nonatomic) UIView *topBar;
@property (nonatomic) BOOL hasVideo;
@property (nonatomic, strong) DropModel *drop;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic) bool isPlaceholderView;
@property (nonatomic, strong) UIButton *playButton;
-(void)setMedia:(NSObject *) media withIndexId:(int) indexId;
-(void)dropWillHide;
-(void)playVideo;
-(void)stopVideo;
-(void)playMediaWithButton:(UIButton *) button;
-(void)updateUI;
-(void)setDropUI:(DropModel *) drop;
-(void)temperatureAnimation;
-(void)playPause;
@end
