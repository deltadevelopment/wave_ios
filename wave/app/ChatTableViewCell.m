//
//  ChatTableViewCell.m
//  wave
//
//  Created by Simen Lie on 29.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "ColorHelper.h"
#import "ChatModel.h"
#import "UserModel.h"

@implementation ChatTableViewCell{
    UIVisualEffectView *blurEffectView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initalize{
    self.isInitialized = YES;
   // self.layer.shouldRasterize = YES;
    //self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.transform = CGAffineTransformMakeRotation(M_PI);
    self.messageImage.layer.cornerRadius = 15;
    self.message.textContainerInset = UIEdgeInsetsMake(20, 5, 5, 5);
    self.messageImage.clipsToBounds = YES;
    [self.messageImage setImage:[UIImage imageNamed:@"miranda-kerr.jpg"]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.message.layer.cornerRadius = 5;
    //self.message.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    //self.message.backgroundColor = [[ColorHelper whiteColor] colorWithAlphaComponent:1.5f];
   [self.message setBackgroundColor:[[ColorHelper whiteColor] colorWithAlphaComponent:0.8f]];
   // [self addBlur];
    [self.message setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    [self.message setTextColor:[UIColor colorWithRed:0.263 green:0.29 blue:0.329 alpha:1]];
    self.message.clipsToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
    [ self.usernameLabel setTextColor:[UIColor colorWithRed:0.667 green:0.698 blue:0.741 alpha:1]];
    [ self.usernameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0f]];
    [ self.usernameLabel setText:@"@simenlie"];
    [self addSubview: self.usernameLabel];
}

-(void)update:(ChatModel *) chatModel{
    __weak typeof(self) weakSelf = self;
    self.message.text = chatModel.message;
    UserModel *userModel = [[UserModel alloc] init];
    [userModel setId:chatModel.sender];
    [userModel find:^(UserModel *user){
        [weakSelf.usernameLabel setText:user.usernameFormatted];
        [user requestProfilePic:^(NSData *data){
         [weakSelf.messageImage setImage:[UIImage imageWithData:data]];
        }];
    } onError:^(NSError *error){
        
    }];
}

-(void)addBlur{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.message.frame;
    // blurEffectView.alpha = 0.9;
    blurEffectView.alpha = 1.0;
    [self.message addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

@end
