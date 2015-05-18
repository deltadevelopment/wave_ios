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


-(void)createNewBucket:(NSData *)media
       withBucketTitle:(NSString *) bucketTitle
 withBucketDescription:(NSString *) bucketDescription
       withDropCaption:(NSString *) dropCaption
         withMediaType:(int) media_type
            onProgress:(void (^)(NSNumber*))progression
          onCompletion:(void (^)(ResponseModel*, BucketModel*))completionCallback
               onError:(void(^)(NSError *))errorCallback
{
    //Generate URL
    [self postHttpRequest:@"drop/generate_upload_url"
                     json:nil
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                 NSMutableDictionary *dic = [parserHelper parse:data];
                 ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                 NSString *uploadURL =  [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"url"];
                 NSString *media_key = [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"media_key"];
                 
                 [mediaController putHttpRequestWithImage:media
                                                    token:uploadURL
                                             onCompletion:^(NSNumber *percentage)
                  {
                      progression(percentage);
                      //NSLog(@"LASTET OPP %ld", [percentage longValue]);
                      if([percentage longValue] == 100){
                          NSDictionary *body = @{
                                                 @"bucket":@{
                                                         @"title" : bucketTitle,
                                                         @"description" : bucketDescription
                                                         },
                                                 @"drop":@{
                                                         @"media_key" : media_key,
                                                         @"caption" : dropCaption,
                                                         @"media_type" : [NSNumber numberWithInt:media_type]
                                                         }
                                                 };
                          NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
                          [self postHttpRequest:@"bucket"
                                           json:jsonData
                                   onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
                           {
                               NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                              // NSLog(@"%@", strdata);
                               NSMutableDictionary *dic = [parserHelper parse:data];
                               ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                               BucketModel *bucket = [[BucketModel alloc] init:[[responseModel data] objectForKey:@"bucket"]];
                               DropModel *drop = [[DropModel alloc] init:[[responseModel data] objectForKey:@"drop"]];
                               drop.media_tmp = media;
                               
                               [bucket addDrop:drop];
                               completionCallback(responseModel, bucket);
                           } onError:errorCallback];
                      }
                      
                  }];
             } onError:errorCallback];
}

-(void)updateBucket:(BucketModel *) bucket
       onCompletion:(void (^)(ResponseModel*))completionCallback
 onError:(void(^)(NSError *))errorCallback
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
            } onError:errorCallback];

}

-(void)deleteBucket:(BucketModel *) bucket
 onCompletion:(void (^)(ResponseModel*))completionCallback
 onError:(void(^)(NSError *))errorCallback
{
    [self deleteHttpRequest:[NSString stringWithFormat:@"bucket/%d", [bucket Id]]
               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *dic = [parserHelper parse:data];
        ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
        completionCallback(responseModel); 
    } onError:errorCallback];
}

-(void)getFeed:(void (^)(ResponseModel*))completionCallback
       onError:(void(^)(NSError *))errorCallback
{
    [self getHttpRequest:@"feed"
            onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                NSMutableDictionary *dic = [parserHelper parse:data];
                ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", strdata);
                completionCallback(responseModel);
               
            } onError:errorCallback];
}

-(void)getBucket:(int)bucketId
    onCompletion:(void (^)(ResponseModel*))completionCallback
       onError:(void(^)(NSError *))errorCallback
{
    [self getHttpRequest:[NSString stringWithFormat:@"bucket/%d", bucketId]
            onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                NSMutableDictionary *dic = [parserHelper parse:data];
                ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", strdata);
                completionCallback(responseModel);
                
            } onError:errorCallback];
}
       
#pragma Private methods
/*
-(void)uploadImage:(NSData *) imageData
          withData:(NSData *) data
        withBucket:(BucketModel *)bucket
    withCompletion:(void (^)(BucketModel*,ResponseModel*))completionCallback
   withProgression:(void (^)(NSNumber*))progression
{
   
}

-(void)createBucket:(BucketModel *) bucket withCompletion:(void (^)(BucketModel*,ResponseModel*))completionCallback{
  
}

-(void)createSharedBucket
{

}
*/
@end
