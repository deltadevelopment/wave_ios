//
//  RipplesFeed.h
//  wave
//
//  Created by Simen Lie on 16.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"

@interface RipplesFeed : SuperModel
@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic) bool hasNotifications;
-(void)getFeed:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback;

-(void)feedFromResponseModel:(ResponseModel *) response;

@end
