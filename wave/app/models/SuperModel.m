//
//  SuperModel.m
//  wave
//
//  Created by Simen Lie on 15/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//


#import "SuperModel.h"

@implementation SuperModel

-(id)init{
    self = [super init];
    self.applicationController = [[ApplicationController alloc] init];
    return self;
}
-(int)getIntValueFromString:(NSString *) stringValue{
    int value;
    if((NSNull*)[self.dictionary objectForKey: stringValue] != [NSNull null]){
        value  = [[self.dictionary objectForKey:stringValue] intValue];
    }else{
        return -1;
    }
    return value;
}

-(NSString *)getStringValueFromString:(NSString *) stringValue{
    NSString *value;
    if((NSNull*)[self.dictionary objectForKey: stringValue] != [NSNull null]){
        value = [self.dictionary objectForKey:stringValue];
    }else{
        return nil;
    }
    return value;
}

-(bool)getBoolValueFromString:(NSString *) stringValue{
    bool value;
    if((NSNull*)[self.dictionary objectForKey: stringValue] != [NSNull null]){
        value = [[self.dictionary objectForKey:stringValue] boolValue];
    }else{
        return nil;
    }
    return value;
}

-(ResponseModel *)responseModelFromData:(NSData *) data{
    NSMutableDictionary *dic = [ParserHelper parse:data];
    ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
    return responseModel;
}

-(NSDictionary *)asDictionary{
    [NSException raise:@"Invalid foo value" format:@"foo of %d is invalid", 1];
    return nil;
}

-(NSString *)addSpaceToString:(NSString *) string{
    return [NSString stringWithFormat:@" %@", string];
}

-(NSString *)asJSON:(NSDictionary *) dictionary{
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:dictionary];
    return jsonData;
}

@end
