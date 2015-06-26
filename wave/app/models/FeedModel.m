//
//  FeedModel.m
//  wave
//
//  Created by Simen Lie on 21.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FeedModel.h"
#import "BucketModel.h"
#import "AuthHelper.h"

@implementation FeedModel{
    AuthHelper *authHelper;
    NSString *url;
}
-(id)init{
    self =[super init];
    authHelper = [[AuthHelper alloc] init];
    url = @"feed";
    return self;
}

-(id)initWithURL:(NSString *) URL{
    self =[super init];
    authHelper = [[AuthHelper alloc] init];
    url = URL;
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
    NSMutableArray *rawFeed = [[response data] objectForKey:@"buckets"];
    for(NSMutableDictionary *rawBucket in rawFeed){
        BucketModel *bucket = [[BucketModel alloc] init:rawBucket];
        if ([bucket.drops count] != 0) {
             [self.feed addObject:bucket];
        }
       
        [self investigateBucket:bucket];
    }
}

-(void)investigateBucket:(BucketModel *) bucket{
    if([[bucket user] Id] == [[authHelper getUserId] intValue]){
        if([bucket.bucket_type isEqualToString:@"user"] ){
            //Do additional operations with user buckets here
            self.personalBucketIndex = (int)[self.feed count] - 1;
            self.isYourBucketInFeed = YES;
        }
        
    }
}

@end
