//
//  BucketModel.h
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropModel.h"
#import "UserModel.h"
#import "SuperModel.h"
@interface BucketModel : SuperModel
-(id)init:(NSMutableDictionary *)dic;
@property (nonatomic) int Id;
@property (nonatomic) int temperature;
@property (nonatomic) int visibility;
@property (nonatomic) BOOL locked;
@property (nonatomic) int user_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *bucket_description;
@property (nonatomic,strong) NSDate *when_datetime;
@property (nonatomic,strong) NSDate *created_at;
@property (nonatomic,strong) NSDate *updated_at;
@property (nonatomic, strong) NSString *bucket_type;
@property (nonatomic) int drops_count;

//Client properties
@property (nonatomic,strong) DropModel *rootDrop;
@property (nonatomic,strong) NSMutableArray *drops;
@property (nonatomic, strong) UserModel *user;
-(DropModel *)getDrop:(int)index;
-(void)saveChanges:(void (^)(ResponseModel*, BucketModel*))completionCallback onError:(void(^)(NSError *))errorCallback;
-(void)saveChanges:(void (^)(ResponseModel *, BucketModel *))completionCallback
           onError:(void (^)(NSError *))errorCallback
        onProgress:(void (^)(NSNumber*))progression;
-(void)find:(int) bucketId
onCompletion:(void (^)(ResponseModel*, BucketModel*))completionCallback
    onError:(void(^)(NSError *))errorCallback;
-(void)find:(void (^)(void))completionCallback
    onError:(void(^)(NSError *))errorCallback;

@property (nonatomic) BOOL isInitalized;
-(void)addDropToFirst:(DropModel *) drop;
-(void)addDrop:(DropModel *) drop;
-(void)removeLastDrop;
-(DropModel *)getLastDrop;
@end
