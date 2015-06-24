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
    [self translate];

    return self;
}

-(void)translate{
   
    self.localizedMessage = NSLocalizedString(self.action, nil);
    
    if ([self.topic_type isEqualToString:@"Vote"]) {
        self.localizedMessage = [NSString stringWithFormat:@"%@ %d °", self.localizedMessage, self.temperature.temperature];
    }
    
    //"create_drop_shared_bucket" = "har lagt til en drop i";
}

-(UserModel *)GetCurrentUser{
    if (self.drop != nil) {
        return [self.drop user];
    }
    else if (self.temperature != nil) {
        return [self.temperature user];
    }
    
    if (self.bucket != nil) {
        return [self.bucket user];
    }
    
    if (self.subscription != nil) {
        return [self.subscription subscribee];
    }
    return nil;
}




@end
