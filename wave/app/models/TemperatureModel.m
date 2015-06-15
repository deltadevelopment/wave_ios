//
//  TemperatureModel.m
//  wave
//
//  Created by Simen Lie on 06.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "TemperatureModel.h"

@implementation TemperatureModel
-(id)initWithDrop:(int)drop_id{
    self =[super init];
    self.drop_id = drop_id;
    return self;
}

-(id)init:(NSMutableDictionary *)dic{
    self.dictionary = dic;
    self =[super init];
    self.Id = [self getIntValueFromString:@"id"];
    self.user_id = [self getIntValueFromString:@"user_id"];
    self.drop_id = [self getIntValueFromString:@"drop_id"];
    self.bucket_id = [self getIntValueFromString:@"bucket_id"];
    self.temperature = [self getIntValueFromString:@"temperature"];
    self.created_at = [self getStringValueFromString:@"created_at"];
    self.updated_at = [self getStringValueFromString:@"updated_at"];
    return self;
}

-(NSDictionary *)asDictionary{
    NSDictionary *dictionary = @{
                                 @"vote": @{
                                         @"temperature": [NSNumber numberWithInt:self.temperature]
                                         }
                                 };
    return dictionary;
}

-(void)saveChanges:(void (^)(ResponseModel *, TemperatureModel *))completionCallback
           onError:(void (^)(NSError *))errorCallback
{
    NSLog([NSString stringWithFormat:@"drop/%d/vote", self.drop_id]);
    [self.applicationController postHttpRequest:[NSString stringWithFormat:@"drop/%d/vote", self.drop_id]
                                           json:[self asJSON:self.asDictionary]
                                   onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         ResponseModel *responseModel = [self responseModelFromData:data];
         TemperatureModel *temperatureModel =[[TemperatureModel alloc] init:[[responseModel data] objectForKey:@"vote"]];
         completionCallback(responseModel, temperatureModel);
     }
                                        onError:errorCallback];
    
}
@end