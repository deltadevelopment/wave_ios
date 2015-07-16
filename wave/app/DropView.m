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
#import "VoteInfoView.h"
#import "ProfileViewController.h"
@implementation DropView
{
    MediaPlayerViewController *mediaPlayer;
    UIButton *playButton;
    UIView *shadowView;
    bool isPlaying;
    
    ProfileViewController *profileView;
    
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
    [self.profilePicture setUserInteractionEnabled:YES];
    UITapGestureRecognizer *showProfileGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile)];
    UITapGestureRecognizer *showProfileGestureLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile)];
    [self.profilePicture addGestureRecognizer:showProfileGesture];
    
    //Drop Name Label
    self.dropTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, -2, [UIHelper getScreenWidth] - 52, 50)];
    [self.dropTitle setUserInteractionEnabled:YES];
    //nameLabel.text = [drop username];
    [UIHelper applyThinLayoutOnLabel:self.dropTitle withSize:19 withColor:[UIColor whiteColor]];
    [self.dropTitle setMinimumScaleFactor:12.0/17.0];
    self.dropTitle.adjustsFontSizeToFitWidth = YES;
    [self.dropTitle addGestureRecognizer:showProfileGestureLabel];
    
    
    //Drop Temperature Label
    self.dropTemperature = [[UILabel alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth] - 120, 10, 50, 30)];
   
    //nameLabel.text = [drop username];
    //[self.dropTemperature setBackgroundColor:[UIColor redColor]];
    [UIHelper applyThinLayoutOnLabel:self.dropTemperature withSize:15 withColor:[UIColor whiteColor]];
    [self.dropTemperature setMinimumScaleFactor:12.0/17.0];
    self.dropTemperature.textAlignment = NSTextAlignmentCenter;
    self.dropTemperature.adjustsFontSizeToFitWidth = YES;
    
    self.redropView = [[UIImageView alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth] - 65, 15, 20, 20)];
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
    
    self.voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voteButton.frame = CGRectMake([UIHelper getScreenWidth] - 95, 8, 35, 35);
    //[self.voteButton setBackgroundColor:[UIColor redColor]];
    [self.voteButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    //[self.voteButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"profile-icon.png"] withSize:40] forState:UIControlStateNormal];
    
    self.voteButton.userInteractionEnabled = YES;
    [self.voteButton addTarget:self action:@selector(showVotes) forControlEvents:UIControlEventTouchUpInside];
    self.voteButton.alpha = 1.0;
    
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
    
    // [self.topBar addSubview:self.dropTemperature];
    [self.topBar addSubview:self.profilePicture];
    
    [self addSubview:shadowView];
    [self addSubview:self.topBar];
    [self addSubview:self.spinner];
    [self addSubview:playButton];
    [self addSubview:self.redropView];
    [self addSubview:self.voteButton];
    [self addSubview:self.dropTemperature];
    
    playButton.hidden = YES;
    __weak typeof(self) weakSelf = self;
    mediaPlayer.onVideoFinishedPlaying = ^{
        [weakSelf onVideoFinished];
    };
    
    return self;
}

-(void)showVotes{
    self.onVotesTapped();
    /*
     NSLog(@"clicked on show votes");
     if (voteInfoView == nil) {
     voteInfoView = [[VoteInfoView alloc] init];
     [self addSubview:voteInfoView];
     }
     [voteInfoView animateInfoIn];
     */
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
        if (drop.total_votes_count == 0) {
            self.voteButton.hidden = YES;
            self.dropTemperature.hidden = YES;
        }
        else{
            self.voteButton.hidden = NO;
            self.dropTemperature.hidden = NO;
            if (drop.most_votes == 1) {
                [self.voteButton setTitle:@"\xF0\x9F\x91\x8D" forState:UIControlStateNormal];
              //  [self.voteButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"eye.png"] withSize:40] forState:UIControlStateNormal];
                [self.voteButton setImage:nil forState:UIControlStateNormal];
            }else{
                //[self.voteButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"profile-icon.png"] withSize:40] forState:UIControlStateNormal];
                [self.voteButton setTitle:@"\xF0\x9F\x98\x82" forState:UIControlStateNormal];
            }
        }
          self.dropTemperature.text =[NSString stringWithFormat:@"%d", drop.total_votes_count];
    }else{
        if (drop.total_votes_count == 0) {
            NSLog(@"total votes is 0");
            self.voteButton.hidden = YES;
            self.dropTemperature.hidden = YES;
        }else{
            self.voteButton.hidden = NO;
            self.dropTemperature.hidden = NO;
            if (drop.most_votes == 1) {
               // [self.voteButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"eye.png"] withSize:40] forState:UIControlStateNormal];
                [self.voteButton setTitle:@"\xF0\x9F\x91\x8D" forState:UIControlStateNormal];
            }else{
               // [self.voteButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"profile-icon.png"] withSize:40] forState:UIControlStateNormal];
                [self.voteButton setTitle:@"\xF0\x9F\x98\x82" forState:UIControlStateNormal];
                
            }
        }
        
        self.dropTemperature.text =[NSString stringWithFormat:@"%d", drop.total_votes_count];
        self.dropTitle.text = [[drop user] usernameFormatted];
        [self placeCounter];
        [drop.user requestProfilePic:^(NSData *data){
            [self.profilePicture setImage:[UIImage imageWithData:data]];
            self.profilePicture.hidden = NO;
        }];
    }
    //self.dropTitle.text = [NSString stringWithFormat:@"Drop #%d",drop.Id];
}

-(void)placeCounter{
    float vote = self.drop.total_votes_count;
    self.dropTemperature.text =[NSString stringWithFormat:@"%d", (int)vote];
    if(vote > 999999){
        self.dropTemperature.frame = CGRectMake([UIHelper getScreenWidth] - 140, 10, 50, 30);
        self.dropTemperature.text = [NSString stringWithFormat:@"%.01f mill", ((vote/1000)/1000)];
    }else if(vote >999){
        self.dropTemperature.frame = CGRectMake([UIHelper getScreenWidth] - 140, 10, 50, 30);
        self.dropTemperature.text = [NSString stringWithFormat:@"%.01f k", (vote/1000)];
    }
    else if(vote >99){
        self.dropTemperature.frame = CGRectMake([UIHelper getScreenWidth] - 130, 10, 50, 30);
    }
    else if(vote > 9){
        self.dropTemperature.frame = CGRectMake([UIHelper getScreenWidth] - 130, 10, 50, 30);
    }
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

-(void)setVideoFromURL:(NSString *) url{
    self.hasVideo = YES;
  //  NSData *video =(NSData *)media;
    mediaPlayer.view.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    //[self addSubview:mediaPlayer.view];
    [self insertSubview:mediaPlayer.view belowSubview:shadowView];
   // [mediaPlayer setVideo:video withId:indexId];
    [mediaPlayer setVideoFromURL:url withId:0];
    //  [mediaPlayer playVideo];
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
    self.voteButton.hidden = NO;
    self.dropTemperature.hidden = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //[self.dropTemperature setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20]];
                         self.dropTemperature.transform = CGAffineTransformMakeScale(1.5,1.5);
                     }
                     completion:^(BOOL finished){
                         //Temporary hard coded to show that temperature changes when voting
                         if (self.drop.hasVotedAlready) {
                             NSLog(@"has voted");
                         }else {
                             [self.drop cacheVote];
                             self.drop.total_votes_count += 1;
                         }
                         self.dropTemperature.text =[NSString stringWithFormat:@"%d", self.drop.total_votes_count];
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

-(void)showProfile{
    //[self.parentController stopAllVideo];
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    profileView = [[ProfileViewController alloc] init];
    [profileView setViewMode:1];
    [profileView setIsNotDeviceUser:YES];
    [profileView setIsDeviceUser:NO];
    [profileView setAnotherUser:self.drop.user];
    

    /*
    [self insertSubview:profileView.view atIndex:0];
    //[self addChildViewController:profileView];
    CGRect frame = profileView.view.frame;
    frame.origin.y = -[UIHelper getScreenHeight];
    profileView.view.frame = frame;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = profileView.view.frame;
                         frame.origin.y = 0;
                         profileView.view.frame = frame;
                         CGRect frame2 = self.frame;
                         frame2.origin.y = [UIHelper getScreenHeight];
                         self.frame = frame2;
                     }
                     completion:^(BOOL finished){
                         CGRect frame2 = self.frame;
                         frame2.origin.y = 0;
                         self.frame = frame2;
                         [profileView.view removeFromSuperview];
                         //[profileController layOutPeek];
                         
                     }];
    */
    
    [[ApplicationHelper getMainNavigationController] pushViewController:profileView animated:YES];
}

-(void)mute{
    [mediaPlayer mute];
}

-(void)unmute{
    [mediaPlayer unmute];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
