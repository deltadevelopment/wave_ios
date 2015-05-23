//
//  FeedModel.h
//  wave
//
//  Created by Simen Lie on 21.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"

@interface FeedModel : SuperModel
@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic) bool isYourBucketInFeed;
@property (nonatomic) int personalBucketIndex;

-(id)init;
-(void)getFeed:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback;
-(id)initWithURL:(NSString *) URL;
@end
