//
//  PeekViewModule.h
//  wave
//
//  Created by Simen Lie on 25.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "SubscribeModel.h"
@interface PeekViewModule : NSObject
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *subscribeButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UILabel *subscribersCountLabel;
@property (strong, nonatomic) SubscribeModel *subscribeModel;
@property (strong, nonatomic) UserModel *user;
-(id)initWithView:(UIView *) view withSubview:(UIView *)subview withController:(UIViewController *) controller;
-(void)updateText:(UserModel *) user;
-(void)fadeOut;
-(void)fadeIn;
-(void)layoutElementsWithSubview:(UIView *) subview;
-(void)hide;
-(void)layoutBackgroundWithSubview:(UIView *)subview;
@end
