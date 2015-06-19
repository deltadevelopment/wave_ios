//
//  UserFeed.m
//  wave
//
//  Created by Simen Lie on 19.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "UserFeed.h"

@implementation UserFeed{
    AuthHelper *authHelper;
    NSString *url;
}
-(id)init{
    self =[super init];
    authHelper = [[AuthHelper alloc] init];
    url = [NSString stringWithFormat:@"user/%d/subscriptions", [[authHelper getUserId] intValue]];
    return self;
}

-(void)getFeed:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback{
    self.feed = [[NSMutableArray alloc] init];
    [self.applicationController getHttpRequest:url
                                  onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                      NSMutableDictionary *dic = [ParserHelper parse:data];
                                      ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                                      [self feedFromResponseModel:responseModel];
                                      completionCallback();
                                      
                                  } onError:errorCallback];
}

-(void)feedFromResponseModel:(ResponseModel *) response{
    if ([response success]) {
        NSLog(@"users was returned");
        self.hasUsers = YES;
        NSMutableArray *rawFeed = [[response data] objectForKey:@"subscriptions"];
        for(NSMutableDictionary *rawBucket in rawFeed){
            SubscribeModel *subscribeModel = [[SubscribeModel alloc] init:rawBucket];
            [self.feed addObject:subscribeModel];
        }
    }else{
        self.hasUsers = NO;
    }
    
}

@end
