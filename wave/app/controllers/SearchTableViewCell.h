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
#import "TagModel.h"
@interface SearchTableViewCell : UITableViewCell
@property (nonatomic) bool isInitialized;
-(void)initalizeWithMode:(bool)searchMode withTagMode:(BOOL) tagMode;
@property (strong, nonatomic)  UILabel *usernameLabel;
@property (strong, nonatomic)  UIImageView *profilePictureImage;
@property (strong, nonatomic)  UIButton *actionButton;
@property (strong, nonatomic)  UIButton *subscribeButton;
@property (strong, nonatomic)  UserModel *user;
@property (strong, nonatomic)  SubscribeModel *subscription;
@property (strong, nonatomic)  UserModel *userReturned;
@property (strong, nonatomic)  TagModel *tage;

@property (nonatomic, copy) void (^onTagDeleted)(TagModel*(tage));
@property (nonatomic, copy) void (^onTagCreated)(TagModel*(tage));

@property (nonatomic)  bool searchMode;
@property (nonatomic)  bool tagMode;
@property (nonatomic)  bool tagModeUI;
@property (nonatomic)  bool isTagged;
@property (nonatomic) int bucketId;
-(void)updateUI:(SuperModel *) superModel withTagmode:(BOOL) tagmode withBucketId:(int)bucketId;
@end
