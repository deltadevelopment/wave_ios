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
@property (nonatomic, strong) UserModel *subscriber2;
@property (nonatomic) int Id;
@property (nonatomic) int user_id;
@property (nonatomic) int subscribee_id;
@property (nonatomic) BOOL reverse;
@property (nonatomic) BOOL reverseIt;
-(void)removeSubscriberLocal;
-(id)init:(NSMutableDictionary *)dic;
-(void)delete:(void (^)(ResponseModel *))completionCallback
onError:(void(^)(NSError *))errorCallback;
-(void)saveChanges:(void (^)(ResponseModel *))completionCallback
           onError:(void(^)(NSError *))errorCallback;
-(void)isSubscriber:(void (^)(ResponseModel *))completionCallback
            onError:(void(^)(NSError *))errorCallback;
-(BOOL)isSubscriberLocal;
-(id)initWithSubscriber:(UserModel *) user withSubscribee:(UserModel *) subscribee;
-(void)storeSubscriberLocal;
@end
