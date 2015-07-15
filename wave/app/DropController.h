//
//  PageContentViewController.h
//  wave
//
//  Created by Simen Lie on 30.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropModel.h"
#import "BucketController.h"
@interface DropController : UIViewController
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@property (strong, nonatomic) DropModel *drop;
@property (nonatomic) bool isStartingView;
@property (nonatomic) bool isPlaceholderView;
@property (nonatomic) bool isDisplaying;
@property (nonatomic) bool isOutOfFocus;
@property (nonatomic) bool isLoaded;
@property (nonatomic, copy) void (^onVotesTapped)(DropModel* (drop));

-(void)bindToModel;
-(void)stopVideo;
-(void)startVideo;
-(void)bindTemperatureChanges;
-(void)mute;
-(void)unmute;
@end
