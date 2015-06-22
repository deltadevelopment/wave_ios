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
    self.Id =[self getIntValueFromString:@"id"];
    self.trigger_id =[self getIntValueFromString:@"trigger_id"];
    //self.trigger_type =[self getStringValueFromString:@"trigger_type"];
    self.message = [self getStringValueFromString:@"message"];
    self.created_at = [dic objectForKey:@"created_at"];
    //self.user = [[UserModel alloc] init:[self.dictionary objectForKey:@"triggee"]];
    self.interaction_id = [self getIntValueFromString:@"interaction_id"];
    self.interaction = [[InteractionModel alloc] init:[self.dictionary objectForKey:@"interaction"]];

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
