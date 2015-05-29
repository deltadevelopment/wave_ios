//
//  SubscribeModel.m
//  wave
//
//  Created by Simen Lie on 29/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SubscribeModel.h"

@implementation SubscribeModel
-(id)initWithSubscriber:(UserModel *) user withSubscribee:(UserModel *) subscribee{
    self =[super init];
    self.subscriber = user;
    self.subscribee = subscribee;
    return self;
}

-(void)saveChanges:(void (^)(ResponseModel *))completionCallback
           onError:(void(^)(NSError *))errorCallback
{
    [self.applicationController postHttpRequest:[NSString stringWithFormat:@"user/%d/subscription/%d", [self.subscriber Id], [self.subscribee Id]]
                     json:nil
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         NSMutableDictionary *dic = [ParserHelper parse:data];
         ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
         completionCallback(responseModel);
     } onError:errorCallback];
}

-(void)delete:(void (^)(ResponseModel *))completionCallback
      onError:(void(^)(NSError *))errorCallback{
    [self.applicationController deleteHttpRequest:[NSString stringWithFormat:@"user/%d/subscription/%d", [self.subscriber Id], [self.subscribee Id]]
               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                   NSMutableDictionary *dic = [ParserHelper parse:data];
                   ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                   completionCallback(responseModel);
               } onError:errorCallback];

}

-(void)isSubscriber:(void (^)(ResponseModel *))completionCallback
            onError:(void(^)(NSError *))errorCallback
{
    [self.applicationController getHttpRequest:[NSString stringWithFormat:@"user/%d/subscription/%d", [self.subscriber Id], [self.subscribee Id]]
                                  onCompletion: ^(NSURLResponse *response,NSData *data,NSError *error){
                                      NSMutableDictionary *dic = [ParserHelper parse:data];
                                      ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                                      completionCallback(responseModel);
                                  } onError:errorCallback];


}

@end
