//
//  DropModel.m
//  wave
//
//  Created by Simen Lie on 05/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DropModel.h"

@implementation DropModel
-(id)init:(NSMutableDictionary *)dic{
    
    
    self.media_key = [dic objectForKey:@"media_key"];
    self.caption = [dic objectForKey:@"caption"];
    self.created_at = [dic objectForKey:@"created_at"];
    self.updated_at = [dic objectForKey:@"updated_at"];
    
    self.parent_id = [self getIntValueFromString:@"parent_id" withDic:dic];
    self.Id = [self getIntValueFromString:@"id" withDic:dic];
    self.bucket_id = [self getIntValueFromString:@"bucket_id" withDic:dic];
    
    self.user_id = [self getIntValueFromString:@"user_id" withDic:dic];
    self.lft = [self getIntValueFromString:@"lft" withDic:dic];
    self.rgt = [self getIntValueFromString:@"rgt" withDic:dic];
    
    
    
    return self;
};

-(int)getIntValueFromString:(NSString *) stringValue withDic:(NSMutableDictionary *) dic{
    int value;
    if((NSNull*)[dic objectForKey: stringValue] != [NSNull null]){
       value  = [[dic objectForKey:stringValue] intValue];
    }else{
        return -1;
    }
    return value;
}

-(id)initWithTestData:(NSString *) media withName:(NSString *) username{
    
    _media  = media;
    _username = username;
    /*
     if((NSNull*)[dic objectForKey: @"phone_number"] != [NSNull null]){
     _phone_number  = [[dic objectForKey:@"phone_number"] intValue];
     }
     */
    
    
    return self;
};
@end
