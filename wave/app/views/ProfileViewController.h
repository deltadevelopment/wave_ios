//
//  ProfileViewController.h
//  wave
//
//  Created by Simen Lie on 22.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ActivityViewController.h"
#import "SubscribeModel.h"
@interface ProfileViewController : AbstractFeedViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) ActivityViewController *profileBuckets;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic) BOOL canDragTable;

@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *subscribeButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UILabel *subscribersCountLabel;
@property (strong, nonatomic) SubscribeModel *subscribeModel;
@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) UIImageView *profileBackgroundImage;
@property (nonatomic) BOOL isNotDeviceUser;
@property (nonatomic, strong) UIVisualEffectView *vibrancyEffectView;
@end
