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

-(id)init:(NSMutableDictionary *)dic{
    self =[super init];
    self.dictionary = dic;
    self.Id = [self getIntValueFromString:@"id"];
    self.user_id = [self getIntValueFromString:@"user_id"];
    self.subscribee_id = [self getIntValueFromString:@"subscribee_id"];
    self.reverse = [self getBoolValueFromString:@"reverse"];
    self.subscribee = [[UserModel alloc] init:[self.dictionary objectForKey:@"subscribee"]];
    self.subscriber = [[UserModel alloc] initWithDeviceUser];
    
    
    if ((NSNull*)[self.dictionary objectForKey: @"subscribee"] != [NSNull null]) {
       [self.dictionary objectForKey:@"subscribee"];
    }else{
        self.subscribee = [[UserModel alloc] init];
        [self.subscribee setId:self.user_id];
    }
    //[self refresh:dic];
    return self;
};

-(void)saveChanges:(void (^)(ResponseModel *))completionCallback
           onError:(void(^)(NSError *))errorCallback
{
    [self.applicationController postHttpRequest:[NSString stringWithFormat:@"user/%d/subscription/%d", [self.subscriber Id], [self.subscribee Id]]
                     json:nil
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         [self storeSubscriberLocal];
         NSMutableDictionary *dic = [ParserHelper parse:data];
         ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
         completionCallback(responseModel);
     } onError:errorCallback];
}

-(void)delete:(void (^)(ResponseModel *))completionCallback
      onError:(void(^)(NSError *))errorCallback{
    [self.applicationController deleteHttpRequest:[NSString stringWithFormat:@"user/%d/subscription/%d", [self.subscriber Id], [self.subscribee Id]]
               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                   [self removeSubscriberLocal];
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

-(void)storeSubscriberLocal{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.subscribee.Id]
                                              forKey:[NSString stringWithFormat:@"subscriber-%d", [self.subscribee Id]]];
}

-(void)removeSubscriberLocal{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"subscriber-%d", [self.subscribee Id]]];
}

-(BOOL)isSubscriberLocal{
   int localId = [[[NSUserDefaults standardUserDefaults] objectForKey:
                   [NSString stringWithFormat:@"subscriber-%d", [self.subscribee Id]]] intValue];
    NSLog(@"the subscriber id is %d", localId);
    if (localId > 0) {
        return YES;
    }else{
        return NO;
    }
}

@end
