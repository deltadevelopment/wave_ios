//
//  RippleModel.m
//  wave
//
//  Created by Simen Lie on 16/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RippleModel.h"

@implementation RippleModel

-(id)init:(NSMutableDictionary *)dic{
    self =[super init];
    self.dictionary = [dic objectForKey:@"aps"];
    
    self.Id = [self getIntValueFromString:@"id"];
    self.bucket_id = [self getIntValueFromString:@"bucket_id"];
    self.drop_id = [self getIntValueFromString:@"drop_id"];
    self.message = [self getStringValueFromString:@"alert"];
    self.date_recieved = [dic objectForKey:@"date_recieved"];
    
    return self;
};

@end
