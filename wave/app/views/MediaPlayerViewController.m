//
//  MediaPlayerViewController.m
//  wave
//
//  Created by Simen Lie on 08/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MediaPlayerViewController.h"
#import "UIHelper.h"
#import "GraphicsHelper.h"
@interface MediaPlayerViewController ()

@end

@implementation MediaPlayerViewController{
    MPMoviePlayerController *player;
    NSString *appFile;
    UIImage *thumbnail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setVideo:(NSData *) video withId:(int) Id{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"MyFile%d.mov", Id]];
    [video writeToFile:appFile atomically:YES];
    NSURL *movieUrl = [NSURL fileURLWithPath:appFile];
    
    //NSString *dataString = [[NSString alloc] initWithData:[status getMedia] encoding:NSUTF8StringEncoding];
    //NSURL *url = [NSURL URLWithString:dataString];
    player = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    player.view.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    //NSLog(@"video: %@",[status getMediaUrl]);
    player.movieSourceType = MPMovieSourceTypeFile;
    player.controlStyle = MPMovieControlStyleNone;
    player.repeatMode = MPMovieRepeatModeOne;
    
    AVAsset *asset = [AVAsset assetWithURL:movieUrl];
    
    //  Get thumbnail at the very start of the video
    CMTime thumbnailTime = [asset duration];
    thumbnailTime.value = 0;
    
    //  Get image from the video at the given time
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
    thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
 
    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    thumbnailView.image = [GraphicsHelper imageByScalingAndCroppingForSize:size img:thumbnail];
    [self.view addSubview:thumbnailView];
    /*
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake([UIHelper getScreenWidth]/2 - 50, [UIHelper getScreenHeight]/2 - 50, 100, 100);
    playButton.alpha = 0.7;
    [playButton addTarget:self action:@selector(startStopVideo:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"play.png"] withSize:150] forState:UIControlStateNormal];
    [self.view addSubview:playButton];
    */
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:thumbnail]];
    //[self.statusImage ];

}

-(void)startStopVideo:(id)sender{
    if(self.isPlaying){
        [player stop];
    }else{
        [player play];
    }
}

-(void)playVideoOnce{
    player.repeatMode = MPMovieRepeatModeNone;
    [self playVideo];
}

-(void)playVideo{
    [self.view addSubview:player.view];
    [player play];
    self.isPlaying = YES;
}

-(void)stopVideo{
    self.isPlaying = NO;
    [player stop];
    [player.view removeFromSuperview];
}

-(void)pauseVideo{
    self.isPlaying = NO;
    [player stop];
    player.view.hidden = YES;
}

-(UIImage *)getVideoThumbnail{
    return thumbnail;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *thePlayer = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:thePlayer];
    if(![player repeatMode]){
        [self stopVideo];
        
        self.onVideoFinishedPlaying();
    }
 
    
   
    //[player stop];
    //[player repeatMode];
    /*
    isPlaying = NO;
    [player stop];
    [player.view removeFromSuperview];
    [self despand];
    isExpanded = NO;
     */
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
