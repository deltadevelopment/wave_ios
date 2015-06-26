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
    self.when = [self getStringValueFromString:@"when"];
    self.message = [self getStringValueFromString:@"message"];

    return self;
};
@end
