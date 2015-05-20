//
//  BucketModel.m
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "BucketModel.h"
#import "ApplicationHelper.h"

@implementation BucketModel
-(id)init:(NSMutableDictionary *)dic{
    self =[super init];
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


-(NSString *)toJSON{
    DropModel *drop = [[self drops] objectAtIndex:0];
    NSDictionary *body = @{
                           @"bucket":@{
                                   @"title" : self.title
                                   },
                           @"drop":@{
                                   @"media_key" : drop.media_key,
                                   @"caption" : drop.caption,
                                   @"media_type" : [NSNumber numberWithInt:drop.media_type]
                                   }
                           };
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:body];
    return jsonData;
}


-(void)saveChanges:(void (^)(ResponseModel*, BucketModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
    if(self.Id > 0){
        [self update:completionCallback onError:errorCallback];
    }
    else{
        [self create:completionCallback onError:errorCallback];
    }
}

-(void)create:(void (^)(ResponseModel*, BucketModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
    if(self.applicationController == nil){
    }
    [self.applicationController postHttpRequest:@"bucket" json:self.toJSON onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         ResponseModel *responseModel = [self responseModelFromData:data];
         BucketModel *bucket = [self bucketFromResponseModel:responseModel];
         completionCallback(responseModel, bucket);
     } onError:errorCallback];
}

-(DropModel *)getDrop:(int)index{
    return [self.drops objectAtIndex:index];
}

-(void)update:(void (^)(ResponseModel*, BucketModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
    NSDictionary *body = @{
                           @"bucket":@{
                                   @"title" : self.title,
                                   }
                           };
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:body];
    
    [self.applicationController putHttpRequest:[NSString stringWithFormat:@"bucket/%d", self.Id]
                                     json:jsonData
                             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                 ResponseModel *responseModel = [self responseModelFromData:data];
                                 BucketModel *bucket = [self bucketFromResponseModel:responseModel];
                                 completionCallback(responseModel, bucket);
                             } onError:errorCallback];
}

#pragma helpers

-(BucketModel *)bucketFromResponseModel:(ResponseModel *)responseModel{
    BucketModel *bucket = [[BucketModel alloc] init:[[responseModel data] objectForKey:@"bucket"]];
    DropModel *drop = [[DropModel alloc] init:[[responseModel data] objectForKey:@"drop"]];
    [bucket addDrop:drop];
    return bucket;
}

#pragma not implemented methods

+(void)delete{

}

+(BucketModel*)find:(int) bucket_id{
    BucketModel *bucket = [[BucketModel alloc] init];
    return bucket;
}


@end
