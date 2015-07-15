//
//  BucketViewController2.h
//  wave
//
//  Created by Simen Lie on 30.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropController.h"
#import "SuperViewController.h"
#import "ChatViewController.h"
#import "CarouselController.h"
#import "VoteInfoView.h"
@interface BucketController : SuperViewController<UIPageViewControllerDataSource, UIGestureRecognizerDelegate, UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *drops;
@property (nonatomic) NSInteger count;
@property (strong, nonatomic)  ChatViewController *chat;
//@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) CarouselController *superCarousel;
@property (nonatomic) bool infoViewMode;
@property (nonatomic, strong) NSLayoutConstraint *heightFromTopChat;
-(void)setBucket:(BucketModel *)inputBucket withCurrentDropId:(int) dropId;
-(void)stopAllVideo;
@end
