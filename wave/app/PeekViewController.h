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
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *availability;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subscribeVerticalconstraint;
@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) SubscribeModel *subscribeModel;

-(void)updatePeekView:(UserModel *) user;
-(void)showAllDetails;

-(void)hideSubscribeButton;

-(void)animatePeekViewIn;
@end
