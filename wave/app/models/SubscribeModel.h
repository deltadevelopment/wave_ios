//
//  SubscribeModel.h
//  wave
//
//  Created by Simen Lie on 29/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"
#import "UserModel.h"
@interface SubscribeModel : SuperModel
@property (nonatomic) UserModel *subscribee;
@property (nonatomic, strong) UserModel *subscriber;

@property (nonatomic) int Id;
@property (nonatomic) int user_id;
@property (nonatomic) int subscribee_id;
@property (nonatomic) BOOL reverse;

-(id)init:(NSMutableDictionary *)dic;
-(void)delete:(void (^)(ResponseModel *))completionCallback
onError:(void(^)(NSError *))errorCallback;
-(void)saveChanges:(void (^)(ResponseModel *))completionCallback
           onError:(void(^)(NSError *))errorCallback;
-(void)isSubscriber:(void (^)(ResponseModel *))completionCallback
            onError:(void(^)(NSError *))errorCallback;
-(id)initWithSubscriber:(UserModel *) user withSubscribee:(UserModel *) subscribee;
@end
