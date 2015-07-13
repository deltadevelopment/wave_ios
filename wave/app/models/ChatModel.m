//
//  ChatModel.m
//  wave
//
//  Created by Simen Lie on 26.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel
-(id)init:(NSMutableDictionary *)dic{
    self =[super init];
    self.dictionary = dic;
    self.uuid = [self getStringValueFromString:@"uuid"];
    self.sender = [self getIntValueFromString:@"sender"];
    self.bucket = [self getIntValueFromString:@"bucket"];
    self.drop = [self getIntValueFromString:@"drop"];
    self.when = [self getStringValueFromString:@"when"];
    self.message = [self getStringValueFromString:@"message"];
    if((NSNull*)[self.dictionary objectForKey:@"message"] == [NSNull null]){
        self.empty = YES;
    }
    else if (self.message == nil){
     self.empty = YES;
    }
    return self;
};
@end
