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
    self.user = [[UserModel alloc] init:[self.dictionary objectForKey:@"triggee"]];
    
    if([self.trigger_type isEqualToString:@"Drop"]){
     self.drop = [[DropModel alloc] init:[self.dictionary objectForKey:@"trigger"]];
    
    }
    else if([self.trigger_type isEqualToString:@"Bucket"]){
        self.bucket = [[BucketModel alloc] init:[self.dictionary objectForKey:@"trigger"]];
        
    }
    else if([self.trigger_type  isEqualToString:@"Subscription"]){
        if((NSNull*)[self.dictionary objectForKey:@"trigger"] != [NSNull null]){
            self.subscription = [[SubscribeModel alloc] init:[self.dictionary objectForKey:@"trigger"]];
        }
    }
    else if([self.trigger_type  isEqualToString:@"Vote"]){
        self.temperature = [[TemperatureModel alloc] init:[self.dictionary objectForKey:@"trigger"]];
    }
    else if([self.trigger_type  isEqualToString:@"Tag"]){
        NSLog(@"Not implemented yet");
    }
        return self;
    

  //  NSLog(self.message);
    
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

-(NSArray *)getComputedString{
    NSArray *listItems = [self.message componentsSeparatedByString:@" "];
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithArray:listItems];
    [mutable removeObjectAtIndex:0];
    NSString *computedUsername = [listItems objectAtIndex:0];
    NSString *computedMessage = [listItems objectAtIndex:0];

    NSString * result = [[mutable valueForKey:@"description"] componentsJoinedByString:@" "];
    result = [NSString stringWithFormat:@" %@", result];
    NSArray *final = [[NSArray alloc] initWithObjects:computedUsername,result, nil];
    return final;
}

@end
