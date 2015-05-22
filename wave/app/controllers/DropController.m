//
//  DropController.m
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DropController.h"
#import "BucketModel.h"
@implementation DropController
-(void)addDropToBucket:(NSString*) caption
             withMedia:(NSData*) media
          withBucketId:(int)bucket_id
         withMediaType:(int)media_type
            onProgress:(void (^)(NSNumber*))onProgression
          onCompletion:(void (^)(ResponseModel*))completionCallback
 onError:(void(^)(NSError *))errorCallback
{
    [self postHttpRequest:@"drop/generate_upload_url"
                     json:nil
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                 NSMutableDictionary *dic = [ParserHelper parse:data];
                 ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                 NSString *uploadURL =  [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"url"];
                 NSString *media_key = [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"media_key"];
                 
                 [mediaController putHttpRequestWithImage:media
                                                    token:uploadURL onProgress:^(NSNumber *percentage){
                                                        onProgression(percentage);
                                                    }
                                             onCompletion:^
                  {
                      
                      NSDictionary *body = @{
                                             @"drop":@{
                                                     @"media_key" : media_key,
                                                     @"caption" : caption,
                                                     @"media_type":[NSNumber numberWithInt:media_type]
                                                     }
                                             };
                      NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:body];
                      [self postHttpRequest:[NSString stringWithFormat:@"bucket/%d/drop", bucket_id]
                                       json:jsonData
                               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
                       {
                           NSMutableDictionary *dic = [ParserHelper parse:data];
                           ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                           completionCallback(responseModel);
                       } onError:errorCallback];
                      
                      
                      
                  }];
             } onError:errorCallback];
}

-(void)deleteDrop:(int)drop_id
     onCompletion:(void (^)(ResponseModel*))completionCallback
          onError:(void(^)(NSError *))errorCallback
{
    [self deleteHttpRequest:[NSString stringWithFormat:@"bucket/%d", drop_id]
               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                   NSMutableDictionary *dic = [ParserHelper parse:data];
                   ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                   completionCallback(responseModel);
               } onError:errorCallback];
}





@end
