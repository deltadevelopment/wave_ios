//
//  DropView.m
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DropView.h"
#import "UIHelper.h"
#import "MediaPlayerViewController.h"
#import "GraphicsHelper.h"
@implementation DropView
{
    MediaPlayerViewController *mediaPlayer;
    UIButton *playButton;
    UIView *shadowView;
    bool isPlaying;
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    mediaPlayer = [[MediaPlayerViewController alloc] init];
    //Drop topBar
    self.topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], 50)];
    
    //Drop profilePicture
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
    
    self.profilePicture.image = [UIImage imageNamed:@"user-icon-gray.png"];
    self.profilePicture.layer.cornerRadius = 15;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.hidden = YES;
    //Drop Name Label
    self.dropTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, -2, [UIHelper getScreenWidth] - 52, 50)];
    //nameLabel.text = [drop username];
    [UIHelper applyThinLayoutOnLabel:self.dropTitle withSize:19 withColor:[UIColor whiteColor]];
    [self.dropTitle setMinimumScaleFactor:12.0/17.0];
    self.dropTitle.adjustsFontSizeToFitWidth = YES;
    
    //Drop Temperature Label
    self.dropTemperature = [[UILabel alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth] - 100, 10, 50, 30)];
    //nameLabel.text = [drop username];
    [UIHelper applyThinLayoutOnLabel:self.dropTemperature withSize:15 withColor:[UIColor whiteColor]];
    [self.dropTemperature setMinimumScaleFactor:12.0/17.0];
    self.dropTemperature.textAlignment = NSTextAlignmentCenter;
    self.dropTemperature.adjustsFontSizeToFitWidth = YES;
    
    self.redropView = [[UIImageView alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth] - 86, 15, 20, 20)];
    [self.redropView setImage:[UIHelper iconImage:[UIImage imageNamed:@"drop.png"] withSize:40.0f]];
    self.redropView.hidden = YES;
    [self.redropView setAlpha:0.5f];
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake([UIHelper getScreenWidth] - 140, 8, 35, 35);
    [playButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    //[playButton setBackgroundColor:[UIColor redColor]];
    [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"play.png"] withSize:40] forState:UIControlStateNormal];
    playButton.userInteractionEnabled = YES;
    [playButton addTarget:self action:@selector(playPause) forControlEvents:UIControlEventTouchUpInside];
    playButton.alpha = 0.5;
    //Loader
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    float center = ([UIHelper getScreenHeight])/2;
    self.spinner.center = CGPointMake([UIHelper getScreenWidth]/2, center);
    
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
    self.spinner.hidden = NO;
    
    //Shadow View
    shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]/4)];
    [UIHelper addShadowToView:shadowView];
    
    //Attach elements
    [self.topBar addSubview:self.dropTitle];
    [self.topBar addSubview:self.dropTemperature];
    [self.topBar addSubview:self.profilePicture];
    
    [self addSubview:shadowView];
    [self addSubview:self.topBar];
    [self addSubview:self.spinner];
    [self addSubview:playButton];
    [self addSubview:self.redropView];
    playButton.hidden = YES;
    __weak typeof(self) weakSelf = self;
    mediaPlayer.onVideoFinishedPlaying = ^{
        [weakSelf onVideoFinished];
    };
    
    return self;

}

-(void)playPause{
    if(isPlaying){
        isPlaying = NO;
        [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"play.png"] withSize:30] forState:UIControlStateNormal];
  
        [mediaPlayer pauseVideo];
    }
    else{
        isPlaying = YES;
              [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"pause-icon.png"] withSize:30] forState:UIControlStateNormal];
        [mediaPlayer playVideoOnce];
    }
}

-(void)setDropUI:(DropModel *) drop{
    self.drop = drop;
    if(drop.media_type == 1){
        playButton.hidden = NO;
    }
    if (self.drop.originator != nil) {
        self.redropView.hidden = NO;
        self.dropTemperature.hidden = YES;
        //[self.dropTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
        self.dropTitle.text = [[drop originator] usernameFormatted];
        [drop.originator requestProfilePic:^(NSData *data){
            [self.profilePicture setImage:[UIImage imageWithData:data]];
            self.profilePicture.hidden = NO;
        }];
    }else{
        self.dropTemperature.text =[NSString stringWithFormat:@"%d°", drop.temperature];
        self.dropTitle.text = [[drop user] usernameFormatted];
        [drop.user requestProfilePic:^(NSData *data){
            [self.profilePicture setImage:[UIImage imageWithData:data]];
            self.profilePicture.hidden = NO;
        }];
    }
    //self.dropTitle.text = [NSString stringWithFormat:@"Drop #%d",drop.Id];
}

-(void)updateUI{

}

-(void)onVideoFinished{
    [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"play.png"] withSize:150] forState:UIControlStateNormal];
    isPlaying = NO;
}

-(void)setMedia:(NSObject *) media withIndexId:(int) indexId{
    if([media isKindOfClass:[UIImage class]]){
    //BILDE
        self.hasVideo = NO;
        CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
        
        //self.image = (UIImage*)media;
        self.image = [GraphicsHelper imageByScalingAndCroppingForSize:size img:(UIImage*)media];
        self.contentMode =UIViewContentModeScaleAspectFill;
    }else if([media isKindOfClass:[NSData class]]){
    //VIDEO
        self.hasVideo = YES;
        NSData *video =(NSData *)media;
        mediaPlayer.view.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
        //[self addSubview:mediaPlayer.view];
        [self insertSubview:mediaPlayer.view belowSubview:shadowView];
        [mediaPlayer setVideo:video withId:indexId];
      //  [mediaPlayer playVideo];
    }
}

-(void)dropWillHide{
    if(self.hasVideo){
        [mediaPlayer stopVideo];
    }
}

-(void)playMediaWithButton:(UIButton *) button{
    playButton = button;
    if(self.hasVideo){
        [mediaPlayer isPlaying] ? [self stopVideo] : [self playVideo];
    }
}

-(void)playVideo{
    self.isPlaying = YES;
    isPlaying = YES;
    [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"pause-icon.png"] withSize:150] forState:UIControlStateNormal];

    [mediaPlayer playVideoOnce];
    //[mediaPlayer playVideo];
}

-(void)stopVideo{
    [mediaPlayer stopVideo];
    [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"play.png"] withSize:150] forState:UIControlStateNormal];

    self.isPlaying = NO;
}

-(void)temperatureAnimation{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //[self.dropTemperature setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20]];
                         self.dropTemperature.transform = CGAffineTransformMakeScale(1.5,1.5);
                       
                     }
                     completion:^(BOOL finished){
                         //Temporary hard coded to show that temperature changes when voting
                         self.dropTemperature.text =[NSString stringWithFormat:@"%d°", self.drop.temperature + 1];
                         [UIView animateWithDuration:0.3f
                                               delay:0.1f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              //[self.dropTemperature setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20]];
                                              self.dropTemperature.transform = CGAffineTransformMakeScale(1.0,1.0);
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }];
                     
                     }];
}

-(void)mute{
    [mediaPlayer mute];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
