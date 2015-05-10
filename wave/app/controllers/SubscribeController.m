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
{

    [self postHttpRequest:[NSString stringWithFormat:@"/user/%d/subscribe/%d", user_id, subscribee_id]
                     json:nil
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         NSMutableDictionary *dic = [parserHelper parse:data];
         ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
         completionCallback(responseModel);
     }];
    
}

-(void)unSubscribeToUser:(int) user_id
        withSubscribeeId:(int) subscribee_id
    onCompletion:(void (^)(ResponseModel*))completionCallback
{
    [self deleteHttpRequest:[NSString stringWithFormat:@"/user/%d/subscribe/%d", user_id, subscribee_id]
               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                   NSMutableDictionary *dic = [parserHelper parse:data];
                   ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                   completionCallback(responseModel);
               }];
}
@end
