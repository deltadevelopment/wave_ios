//
//  UserFeed.h
//  wave
//
//  Created by Simen Lie on 19.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"
#import "UserModel.h"
#import "SubscribeModel.h"
@interface UserFeed : SuperModel
@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic) bool hasUsers;
-(void)getFeed:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback;


@end
