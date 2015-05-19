//
//  BucketModel.m
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "BucketModel.h"

@implementation BucketModel
-(id)init:(NSMutableDictionary *)dic{
    self.dictionary = dic;
    self.Id = [self getIntValueFromString:@"id"];
    
    
    
    self.temperature = [self getIntValueFromString:@"temperature"];
    self.visibility = [self getBoolValueFromString:@"visibility"];
    self.visibility = [self getBoolValueFromString:@"locked"];
    self.user_id = [self getIntValueFromString:@"user_id"];
    self.drops_count = [self getIntValueFromString:@"drops_count"];

    self.title= [self getStringValueFromString:@"title"];
    self.bucket_description= [self getStringValueFromString:@"description"];
    self.when_datetime= [dic objectForKey:@"when_datetime"];
    self.created_at= [dic objectForKey:@"created_at"];
    self.updated_at= [dic objectForKey:@"updated_at"];
    self.drops = [[NSMutableArray alloc] init];
    self.user = [[UserModel alloc] init:[dic objectForKey:@"user"]];
    self.bucket_type = [dic objectForKey:@"bucket_type"];
    if([dic objectForKey:@"drop"] != nil){
        NSLog(@"adding drop");
        DropModel *drop = [[DropModel alloc] init:[dic objectForKey:@"drop"]];
        [self addDrop:drop];
    }
   
    NSMutableArray *rawDrops = [dic objectForKey:@"drops"];
    for(NSMutableDictionary *rawDrop in rawDrops){
        DropModel *drop = [[DropModel alloc] init:rawDrop];
        [self addDropToFirst:drop];
    }
    return self;
};


-(void)addDrop:(DropModel *) drop{
    [self.drops addObject:drop];
}

-(void)addDropToFirst:(DropModel *) drop{
    [self.drops insertObject:drop atIndex:0];
}

-(id)init{
    self =[super init];
    self.drops = [[NSMutableArray alloc] init];
    self.isInitalized = NO;
    return self;
}
@end
