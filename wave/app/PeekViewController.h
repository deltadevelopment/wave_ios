//
//  PeekViewController.h
//  wave
//
//  Created by Simen Lie on 27.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "SubscribeModel.h"
#import "ActivityViewController.h"
#import "BucketController.h"
@interface PeekViewController : UIViewController
@property (strong, nonatomic) IBOutlet  UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *displayName;
@property (strong, nonatomic) IBOutlet UILabel *availability;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UIButton *subscribeButton;
@property (strong, nonatomic)  NSLayoutConstraint *subscribeVerticalconstraint;
@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) SubscribeModel *subscribeModel;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) ActivityViewController *activityViewController;
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) BucketController *parentController;
-(void)updatePeekView:(UserModel *) user;
-(void)showAllDetails;
-(void)addBackgroundView;
-(void)hideSubscribeButton;
-(void)requestProfilePic;

-(void)animatePeekViewIn;
@end
