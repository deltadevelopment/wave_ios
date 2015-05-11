//
//  TagController.m
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "TagController.h"

@implementation TagController
-(void)addTagToBucket:(NSString*) tag
         withBucketId:(int) bucket_id
          onCompletion:(void (^)(ResponseModel*))completionCallback
 onError:(void(^)(NSError *))errorCallback
{
    NSDictionary *body = @{
                           @"tag":@{
                                   @"tag_string" : tag
                                   }
                           };
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    [self postHttpRequest:[NSString stringWithFormat:@"/bucket/%d/tag", bucket_id]
                     json:jsonData
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         NSMutableDictionary *dic = [parserHelper parse:data];
         ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
         completionCallback(responseModel);
     } onError:errorCallback];

}

-(void)deleteTag:(int)tag_id
     onCompletion:(void (^)(ResponseModel*))completionCallback
 onError:(void(^)(NSError *))errorCallback
{
    [self deleteHttpRequest:[NSString stringWithFormat:@"tag/%d", tag_id]
               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                   NSMutableDictionary *dic = [parserHelper parse:data];
                   ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                   completionCallback(responseModel);
               } onError:errorCallback];
}
@end
