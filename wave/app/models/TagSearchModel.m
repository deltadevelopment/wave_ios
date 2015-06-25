//
//  TagSearchModel.m
//  wave
//
//  Created by Simen Lie on 25.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "TagSearchModel.h"

@implementation TagSearchModel{
    AuthHelper *authHelper;
    NSString *url;
}
-(id)init{
    self =[super init];
    authHelper = [[AuthHelper alloc] init];
    //searchModes = @[@"user",@"hashtag"];
    url = @"bucket";
    self.searchMode = @"user";
    self.mediaController = [[MediaController alloc] init];
    return self;
   // bucket/:bucket_id/tags' => 'tags#list
}

-(void)getTags:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback{
    self.feed = [[NSMutableArray alloc] init];
    [self.applicationController getHttpRequest:[NSString stringWithFormat:@"%@/%d/%@", url, self.bucketId, @"tags"]
                                  onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                      NSMutableDictionary *dic = [ParserHelper parse:data];
                                      ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                                      [self feedFromResponseModel:responseModel];
                                      completionCallback();
                                      
                                  } onError:errorCallback];
}

-(void)stopSearchConnection{
    [self.mediaController stopConnection];
}

-(void)feedFromResponseModel:(ResponseModel *) response{
    if ([response success]) {
        self.hasSearchResults = YES;
        NSMutableArray *rawFeed = [[response data] objectForKey:@"tags"];
        for(NSMutableDictionary *rawBucket in rawFeed){
            NSLog(@"my bu is %@", rawBucket);
            TagModel *user = [[TagModel alloc] init:rawBucket];
            [self.feed addObject:user];
        }
    }else{
        self.hasSearchResults = NO;
    }
    
}

-(bool)isUserTagged:(UserModel *) user{
    for (TagModel *tag in self.feed) {
        if ([tag taggee].Id == user.Id) {
            return YES;
        }
    }
    return NO;
}

@end
