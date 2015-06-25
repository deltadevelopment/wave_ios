//
//  TagModel.h
//  wave
//
//  Created by Simen Lie on 25.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"
#import "UserModel.h"
#import "DropModel.h"
#import "BucketModel.h"
@interface TagModel : SuperModel
@property(nonatomic) int Id;
@property(nonatomic) int taggee_id;
@property(nonatomic, strong) NSString *taggee_type;
@property(nonatomic) int taggable_id;
@property(nonatomic, strong) NSString *taggable_type;

@property(nonatomic, strong) UserModel *taggee;
@property(nonatomic, strong) DropModel *taggable;
@property(nonatomic, strong) BucketModel *bucket;
@property(nonatomic, strong) UserModel *user;

//Client
@property(nonatomic) int bucketId;
@property(nonatomic, strong) NSString *tagString;
-(id)init:(NSMutableDictionary *)dic;

-(void)saveChanges:(void (^)(ResponseModel *))completionCallback
           onError:(void(^)(NSError *))errorCallback;

-(void)delete:(void (^)(ResponseModel *))completionCallback
onError:(void(^)(NSError *))errorCallback;
@end
