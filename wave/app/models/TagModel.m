//
//  TagModel.m
//  wave
//
//  Created by Simen Lie on 25.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel
-(id)init:(NSMutableDictionary *)dic{
    self.dictionary = dic;
    self =[super init];
    self.Id = [self getIntValueFromString:@"id"];
    self.taggee_id = [self getIntValueFromString:@"taggee_id"];
    
    self.taggee_type = [self getStringValueFromString:@"taggee_type"];
    self.taggable_id = [self getIntValueFromString:@"taggable_id"];
    self.taggable_type = [self getStringValueFromString:@"taggable_type"];
    
    if((NSNull*)[self.dictionary objectForKey:@"taggee"] != [NSNull null]){
        if([self.taggee_type isEqualToString:@"User"]){
            self.taggee = [[UserModel alloc] init:[self.dictionary objectForKey:@"taggee"]];
        }
    }
    
    if((NSNull*)[self.dictionary objectForKey:@"user"] != [NSNull null]){
        if([self.taggee_type isEqualToString:@"User"]){
            self.user = [[UserModel alloc] init:[self.dictionary objectForKey:@"user"]];
        }
    }
    if((NSNull*)[self.dictionary objectForKey:@"taggable"] != [NSNull null]){
        if([self.taggable_type isEqualToString:@"Drop"]){
            self.taggable = [[DropModel alloc] init:[self.dictionary objectForKey:@"taggable"]];
        }
        else if ([self.taggable_type isEqualToString:@"Bucket"]){
            self.bucket = [[BucketModel alloc] init:[self.dictionary objectForKey:@"taggable"]];
        }
    }
    return self;
};

-(NSDictionary *)asDictionary{
    NSDictionary *dictionary = @{
                                 @"tag": @{
                                         @"tag_string": self.tagString
                                         }
                                 };
    return dictionary;
}

///bucket/:bucket_id/tag	{ tag: { tag_string: } }

-(void)saveChanges:(void (^)(ResponseModel *))completionCallback
           onError:(void(^)(NSError *))errorCallback
{
    [self.applicationController postHttpRequest:[NSString stringWithFormat:@"bucket/%d/tag", self.bucketId]
                                           json:[self asJSON:[self asDictionary]]
                                   onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         NSMutableDictionary *dic = [ParserHelper parse:data];
         ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
         completionCallback(responseModel);
     } onError:errorCallback];
}

-(void)delete:(void (^)(ResponseModel *))completionCallback
      onError:(void(^)(NSError *))errorCallback{
    [self.applicationController deleteHttpRequest:[NSString stringWithFormat:@"tag/%d", self.Id]
                                     onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                         NSMutableDictionary *dic = [ParserHelper parse:data];
                                         ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                                         completionCallback(responseModel);
                                     } onError:errorCallback];
    
}




@end
