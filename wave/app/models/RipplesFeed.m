//
//  RipplesFeed.m
//  wave
//
//  Created by Simen Lie on 16.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RipplesFeed.h"
#import "RippleModel.h"
@implementation RipplesFeed{
    AuthHelper *authHelper;
    NSString *url;
}
-(id)init{
    self =[super init];
    authHelper = [[AuthHelper alloc] init];
    url = @"ripples";
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
        NSLog(@"notifcations");
        self.hasNotifications = YES;
        NSMutableArray *rawFeed = [[response data] objectForKey:@"ripples"];
        for(NSMutableDictionary *rawBucket in rawFeed){
            RippleModel *ripple = [[RippleModel alloc] init:rawBucket];
            [self.feed addObject:ripple];
        }
    }else{
        self.hasNotifications = NO;
    }
    
}
@end
