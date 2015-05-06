//
//  BucketController.m
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "BucketController.h"
#import "ResponseModel.h"

@implementation BucketController


-(void)createNewBucket:(BucketModel *)bucket
          onProgress:(void (^)(NSNumber*))progression
          onCompletion:(void (^)(BucketModel*,ResponseModel*))completionCallback
{
    //Generate URL
    [self postHttpRequest:@"drop/generate_upload_url"
                     json:nil
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                 [self uploadImage:[[bucket rootDrop] media_tmp]
                          withData:data withBucket:bucket
                    withCompletion:completionCallback
                   withProgression:progression];
             }];
}

-(void)updateBucket:(BucketModel *) bucket
       onCompletion:(void (^)(ResponseModel*))completionCallback
{
    NSDictionary *body = @{
                           @"bucket":@{
                                   @"title" : bucket.title,
                                   @"description" : bucket.bucket_description,
                                   @"when_datetime" : bucket.when_datetime,
                                   @"visibility" : [NSNumber numberWithInt:bucket.visibility],
                                   @"locked" : [NSNumber numberWithInt:bucket.locked]
                                   }
                           };
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    
    
    [self putHttpRequest:[NSString stringWithFormat:@"bucket/%d", [bucket Id]]
                    json:jsonData
            onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                NSMutableDictionary *dic = [parserHelper parse:data];
                ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                completionCallback(responseModel);
            }];

}

-(void)deleteBucket:(BucketModel *) bucket
 onCompletion:(void (^)(ResponseModel*))completionCallback
{
    [self deleteHttpRequest:[NSString stringWithFormat:@"bucket/%d", [bucket Id]]
               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *dic = [parserHelper parse:data];
        ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
        completionCallback(responseModel); 
    }];
}

#pragma Private methods

-(void)uploadImage:(NSData *) imageData
          withData:(NSData *) data
        withBucket:(BucketModel *)bucket
    withCompletion:(void (^)(BucketModel*,ResponseModel*))completionCallback
   withProgression:(void (^)(NSNumber*))progression
{
    NSMutableDictionary *dic = [parserHelper parse:data];
    ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
    NSString *uploadURL =  [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"url"];
    NSString *media_key = [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"media_key"];
    
    [mediaController putHttpRequestWithImage:imageData
                                       token:uploadURL
                                onCompletion:^(NSNumber *percentage)
    {
        progression(percentage);
        //NSLog(@"LASTET OPP %ld", [percentage longValue]);
        if([percentage longValue] == 100){
            [bucket rootDrop].media_key = media_key;
            [self createBucket:bucket withCompletion:completionCallback];
        }
        
    }];
}

-(void)createBucket:(BucketModel *) bucket withCompletion:(void (^)(BucketModel*,ResponseModel*))completionCallback{
    NSDictionary *body = @{
                           @"bucket":@{
                                   @"title" : bucket.title,
                                   @"description" : bucket.bucket_description
                                   },
                           @"drop":@{
                                   @"media_key" : [bucket rootDrop].media_key,
                                   @"caption" : [bucket rootDrop].caption
                                   }
                           
                           };
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    [self postHttpRequest:@"bucket"
                     json:jsonData
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
    {
        NSMutableDictionary *dic = [parserHelper parse:data];
        ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
        completionCallback(bucket, responseModel);
    }];
}

-(void)createSharedBucket
{

}

@end
