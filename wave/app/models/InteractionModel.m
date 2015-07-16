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
    self.user = [[UserModel alloc] init:[self.dictionary objectForKey:@"user"]];
    
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
            self.tag = [[TagModel alloc] init:[self.dictionary objectForKey:@"topic"]];
        }
    }
    [self translate];

    return self;
}

-(void)translate{
   
    self.localizedMessage = NSLocalizedString(self.action, nil);
    
    if ([self.action isEqualToString:@"create_chat_message"]) {
        if ([self.bucket.bucket_type isEqualToString:@"user"]) {
            self.localizedMessage = [NSString stringWithFormat:@"%@ %@ %@.",
                                     self.localizedMessage, self.bucket.user.username, NSLocalizedString(@"personal_bucket", nil)];
        }else{
            self.localizedMessage = [NSString stringWithFormat:@"%@ '%@'.",
                                     self.localizedMessage, self.bucket.title];
        }
    }
    
    else if ([self.topic_type isEqualToString:@"Vote"]) {
        if (self.temperature.temperature == 1) {
            self.localizedMessage = [NSString stringWithFormat:@"%@ %@.", self.localizedMessage, NSLocalizedString(@"vote_cool", nil)];
        }else{
            self.localizedMessage = [NSString stringWithFormat:@"%@ %@.", self.localizedMessage, NSLocalizedString(@"vote_funny", nil)];
        }
    }
    else if ([self.topic_type isEqualToString:@"Tag"]) {
        if ([self.tag.taggable_type isEqualToString:@"Bucket"]) {
            self.localizedMessage = [NSString stringWithFormat:@"%@ '%@'.",
                                     self.localizedMessage, self.tag.bucket.title];
        }
    }
    
    else{
        self.localizedMessage = [NSString stringWithFormat:@"%@.", self.localizedMessage];
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
        if ([self.action isEqualToString:@"create_chat_message"]) {
            return self.user;
        }
        return [self.bucket user];
    }
    if (self.subscription != nil) {
        return [self.subscription subscriber2];
    }
    else if (self.tag != nil){
        return [self.tag user];
    }
    return nil;
}

@end
