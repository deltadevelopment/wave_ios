//
//  SearchTableViewCell.h
//  wave
//
//  Created by Simen Lie on 19.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "SubscribeModel.h"
@interface SearchTableViewCell : UITableViewCell
@property (nonatomic) bool isInitialized;
-(void)initalizeWithMode:(bool)searchMode;
@property (strong, nonatomic)  UILabel *usernameLabel;
@property (strong, nonatomic)  UIImageView *profilePictureImage;
@property (strong, nonatomic)  UIButton *actionButton;
@property (strong, nonatomic)  UIButton *subscribeButton;
@property (strong, nonatomic)  UserModel *user;
@property (strong, nonatomic)  SubscribeModel *subscription;
@property (strong, nonatomic)  UserModel *userReturned;
@property (nonatomic)  bool searchMode;
-(void)updateUI:(SuperModel *) superModel;
@end
