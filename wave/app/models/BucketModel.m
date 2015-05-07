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
    self.bucket_type = [[dic objectForKey:@"bucket_type"] intValue];
    self.temperature = [[dic objectForKey:@"temperature"] intValue];
    self.visibility= [[dic objectForKey:@"visibility"] boolValue];
    self.locked= [[dic objectForKey:@"locked"] boolValue];
    self.user_id= [[dic objectForKey:@"user_id"] intValue];
    self.title= [dic objectForKey:@"title"];
    self.bucket_description= [dic objectForKey:@"description"];
    self.when_datetime= [dic objectForKey:@"when_datetime"];
    self.created_at= [dic objectForKey:@"created_at"];
    self.updated_at= [dic objectForKey:@"updated_at"];
    self.drops = [[NSMutableArray alloc] init];

    return self;
};

-(id)init{
    self =[super init];
    self.drops = [[NSMutableArray alloc] init];
    self.isInitalized = NO;
    return self;
}
@end
