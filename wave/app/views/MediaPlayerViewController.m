//
//  MediaPlayerViewController.m
//  wave
//
//  Created by Simen Lie on 08/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MediaPlayerViewController.h"
#import "UIHelper.h"
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

-(void)setVideo:(NSData *) video{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    appFile = [documentsDirectory stringByAppendingPathComponent:@"MyFile.mov"];
    [video writeToFile:appFile atomically:YES];
    NSURL *movieUrl = [NSURL fileURLWithPath:appFile];
    
    //NSString *dataString = [[NSString alloc] initWithData:[status getMedia] encoding:NSUTF8StringEncoding];
    NSLog(@"video: %@",@"mdia is downloaded");
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:thumbnail]];
    //[self.statusImage ];
}

-(void)playVideo{
    [self.view addSubview:player.view];
    [player play];
}

-(void)stopVideo{
    [player stop];
    [player.view removeFromSuperview];
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
    NSLog(@"DONE PLAYING VIDEO");
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
