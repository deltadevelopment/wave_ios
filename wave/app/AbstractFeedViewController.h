//
//  AbstractFeedViewController.h
//  wave
//
//  Created by Simen Lie on 17/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedInterface.h"
#import "BucketModel.h"
#import "SuperButton.h"
@interface AbstractFeedViewController : UIViewController<FeedInterface>
//@property (nonatomic, copy) void (^onExpand)(void);
@property (nonatomic, copy) void (^onExpand)(BucketModel*(bucket));
@property (nonatomic, copy) void (^onProgression)(int(progress));
@property (nonatomic, copy) void (^onNetworkError)(UIView*(view));
@property (nonatomic, copy) void (^onNetworkErrorHide)(void);
@property (nonatomic, copy) void (^onTableViewDrag)(UIScrollView*(view));
@property (nonatomic, copy) void (^onLockScreenToggle)(void);
@property (nonatomic, copy) void (^onSearchedCanceled)(void);
@property (nonatomic, strong) SuperButton* superButton;
@property (nonatomic) bool isDeviceUser;
@property (nonatomic, strong) UserModel *anotherUser;
@property (nonatomic, strong) UIViewController *carouselParent;
@property (nonatomic) bool searchMode;
@property (nonatomic) bool tagMode;
@property NSUInteger pageIndex;
-(void)scrollUp;
-(void)prepareCamera:(UIView *)view;
-(void)onCameraOpen;
-(void)oncameraClose;
-(void)onImageTaken:(UIImage *)image withText:(NSString *)text;
-(void)onCameraReady;
-(void)onFocusGained;
-(void)onVideoTaken:(NSData *) video withImage:(UIImage *)image withtext:(NSString *)text;
-(void)onCancelTap;
-(void)increazeProgress:(int)progress;
-(void)onMediaPosted:(BucketModel *)bucket;
-(void)onMediaPostedDrop:(DropModel *)drop;
-(void)setViewMode:(int)mode;
-(void)hidePeekFirst;
-(void)layOutPeek;

-(void)initSearchTable:(UISearchController *) controller;

@end
