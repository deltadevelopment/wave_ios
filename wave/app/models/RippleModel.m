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
    self.dictionary = dic;
    self.triggee_id =[self getIntValueFromString:@"triggee_id"];
    self.trigger_id =[self getIntValueFromString:@"trigger_id"];
    self.trigger_type =[self getStringValueFromString:@"trigger_type"];
    self.message = [self getStringValueFromString:@"message"];
    self.created_at = [dic objectForKey:@"created_at"];
    
    return self;
};

-(id)initFromPushNotification:(NSMutableDictionary *)dic{
    self =[super init];
    self.dictionary = [dic objectForKey:@"aps"];
    
    self.Id = [self getIntValueFromString:@"id"];
    self.bucket_id = [self getIntValueFromString:@"bucket_id"];
    self.drop_id = [self getIntValueFromString:@"drop_id"];
    self.message = [self getStringValueFromString:@"alert"];
    self.created_at = [dic objectForKey:@"date_recieved"];
    
    return self;
};

@end
