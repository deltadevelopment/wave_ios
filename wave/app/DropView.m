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
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    mediaPlayer = [[MediaPlayerViewController alloc] init];
    //Drop topBar
    self.topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 32, [UIHelper getScreenWidth], 50)];
    
    //Drop profilePicture
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
    
    self.profilePicture.image = [UIImage imageNamed:@"miranda-kerr.jpg"];
    self.profilePicture.layer.cornerRadius = 15;
    self.profilePicture.clipsToBounds = YES;
    
    //Drop Name Label
    self.dropTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, -2, [UIHelper getScreenWidth] - 52, 50)];
    //nameLabel.text = [drop username];
    [UIHelper applyThinLayoutOnLabel:self.dropTitle withSize:18 withColor:[UIColor whiteColor]];
    [self.dropTitle setMinimumScaleFactor:12.0/17.0];
    self.dropTitle.adjustsFontSizeToFitWidth = YES;
    
    //Loader
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    float center = ([UIHelper getScreenHeight])/2;
    self.spinner.center = CGPointMake([UIHelper getScreenWidth]/2, center);
    
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
    self.spinner.hidden = NO;
    
    //Shadow View
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 32, [UIHelper getScreenWidth], [UIHelper getScreenHeight]/4)];
    [UIHelper addShadowToView:shadowView];
    
    //Attach elements
    [self.topBar addSubview:self.dropTitle];
    [self.topBar addSubview:self.profilePicture];
    
    [self addSubview:shadowView];
    [self addSubview:self.topBar];
    [self addSubview:self.spinner];
    __weak typeof(self) weakSelf = self;
    mediaPlayer.onVideoFinishedPlaying = ^{
        [weakSelf onVideoFinished];
    };
    
    return self;

}

-(void)onVideoFinished{
    [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"play.png"] withSize:150] forState:UIControlStateNormal];
}

-(void)setMedia:(NSObject *) media withIndexId:(int) indexId{
    if([media isKindOfClass:[UIImage class]]){
    //BILDE
        self.hasVideo = NO;
        self.image = (UIImage*)media;
    }else if([media isKindOfClass:[NSData class]]){
    //VIDEO
        self.hasVideo = YES;
        NSLog(@"SPILLER AV VIDEO");
        NSData *video =(NSData *)media;
        mediaPlayer.view.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
        [self addSubview:mediaPlayer.view];
        [mediaPlayer setVideo:video withId:indexId];
        //[mediaPlayer playVideo];
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
    [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"media-pause.png"] withSize:150] forState:UIControlStateNormal];

    [mediaPlayer playVideoOnce];
}

-(void)stopVideo{
    [mediaPlayer stopVideo];
    [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"play.png"] withSize:150] forState:UIControlStateNormal];

    self.isPlaying = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
