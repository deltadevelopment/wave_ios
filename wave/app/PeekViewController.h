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
@interface PeekViewController : UIViewController
@property (strong, nonatomic)  UIImageView *profilePicture;
@property (strong, nonatomic)  UILabel *displayName;
@property (strong, nonatomic)  UILabel *availability;
@property (strong, nonatomic)  UILabel *location;
@property (strong, nonatomic)  UIButton *subscribeButton;
@property (strong, nonatomic)  NSLayoutConstraint *subscribeVerticalconstraint;
@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) SubscribeModel *subscribeModel;

-(void)updatePeekView:(UserModel *) user;
-(void)showAllDetails;

-(void)hideSubscribeButton;

-(void)animatePeekViewIn;
@end
