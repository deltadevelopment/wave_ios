//
//  SubscribeController.m
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SubscribeController.h"

@implementation SubscribeController
-(void)subscribeToUser:(int) user_id
      withSubscribeeId:(int) subscribee_id
          onCompletion:(void (^)(ResponseModel*))completionCallback
               onError:(void(^)(NSError *))errorCallback
{
    
    [self postHttpRequest:[NSString stringWithFormat:@"user/%d/subscribe/%d", user_id, subscribee_id]
                     json:nil
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         NSMutableDictionary *dic = [ParserHelper parse:data];
         ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
         completionCallback(responseModel);
     } onError:errorCallback];
    
    
}

-(void)unSubscribeToUser:(int) user_id
        withSubscribeeId:(int) subscribee_id
            onCompletion:(void (^)(ResponseModel*))completionCallback
                 onError:(void(^)(NSError *))errorCallback
{
    [self deleteHttpRequest:[NSString stringWithFormat:@"user/%d/subscribe/%d", user_id, subscribee_id]
               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                   NSMutableDictionary *dic = [ParserHelper parse:data];
                   ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                   completionCallback(responseModel);
               } onError:errorCallback];
}
@end
