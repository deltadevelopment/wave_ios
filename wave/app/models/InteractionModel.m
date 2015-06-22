//
//  InteractionModel.m
//  wave
//
//  Created by Simen Lie on 22.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "InteractionModel.h"

@implementation InteractionModel


-(id)init:(NSMutableDictionary *)dic{
    self =[super init];
    self.dictionary = dic;
    NSLog(@"my dic is %@", dic);
    self.Id = [self getIntValueFromString:@"Id"];
    self.topic_id = [self getIntValueFromString:@"topic_id"];
    self.topic_type = [self getStringValueFromString:@"topic_type"];
    self.user_id = [self getIntValueFromString:@"user_id"];
    self.action = [self getStringValueFromString:@"action"];
    
    if((NSNull*)[self.dictionary objectForKey:@"topic"] != [NSNull null]){
        if([self.topic_type isEqualToString:@"Drop"]){
            self.drop = [[DropModel alloc] init:[self.dictionary objectForKey:@"topic"]];
            
        }
        else if([self.topic_type isEqualToString:@"Bucket"]){
            self.bucket = [[BucketModel alloc] init:[self.dictionary objectForKey:@"topic"]];
            
        }
        else if([self.topic_type  isEqualToString:@"Subscription"]){
            
            
            self.subscription = [[SubscribeModel alloc] init:[self.dictionary objectForKey:@"topic"]];
            
        }
        else if([self.topic_type  isEqualToString:@"Vote"]){
            
            self.temperature = [[TemperatureModel alloc] init:[self.dictionary objectForKey:@"topic"]];
        }
        else if([self.topic_type  isEqualToString:@"Tag"]){
            NSLog(@"Not implemented yet");
        }
    }
    

    return self;
}

@end
