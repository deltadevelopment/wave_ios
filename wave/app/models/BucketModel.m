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

-(id)init{
    self =[super init];
    self.drops = [[NSMutableArray alloc] init];
    self.isInitalized = NO;
    return self;
}

-(id)initWithSelf:(BucketModel *)bucket{
    self = bucket;
    return self;
}

-(id)init:(NSMutableDictionary *)dic{
    self =[super init];
    [self refresh:dic];
    return self;
};

-(void)refresh:(NSMutableDictionary *) dic{
    self.dictionary = dic;
    self.Id = [self getIntValueFromString:@"id"];
    self.temperature = [self getIntValueFromString:@"temperature"];
    self.visibility = [self getBoolValueFromString:@"visibility"];
    self.visibility = [self getBoolValueFromString:@"locked"];
    self.user_id = [self getIntValueFromString:@"user_id"];
    self.drops_count = [self getIntValueFromString:@"drops_count"];
    self.watching = [self getBoolValueFromString:@"watching"];
    self.title= [self getStringValueFromString:@"title"];
    self.bucket_description= [self getStringValueFromString:@"description"];
    self.when_datetime= [dic objectForKey:@"when_datetime"];
    self.created_at= [dic objectForKey:@"created_at"];
    self.updated_at= [dic objectForKey:@"updated_at"];
    self.drops = [[NSMutableArray alloc] init];
    self.user = [[UserModel alloc] init:[dic objectForKey:@"user"]];
    self.bucket_type = [dic objectForKey:@"bucket_type"];
    if([dic objectForKey:@"drop"] != nil){
        DropModel *drop = [[DropModel alloc] init:[dic objectForKey:@"drop"]];
        [self addDrop:drop];
    }
    
    NSMutableArray *rawDrops = [dic objectForKey:@"drops"];
    for(NSMutableDictionary *rawDrop in rawDrops){
        DropModel *drop = [[DropModel alloc] init:rawDrop];
        [self addDropToFirst:drop];
       // [self addDrop:drop];
    }
}

-(void)addDrop:(DropModel *) drop{
    [self.drops addObject:drop];
}

-(void)addDropToFirst:(DropModel *) drop{
    [self.drops insertObject:drop atIndex:0];
}

-(DropModel *)getLastDrop{
    if([self.drops count] > 0){
    return [self.drops objectAtIndex:[self.drops count] -1];
    }
    return nil;
}

-(void)removeLastDrop{
    [self.drops removeLastObject];
}

-(NSDictionary *)asDictionary{
    NSDictionary *dictionary = @{
                                 @"title": self.title
                                 };
    return dictionary;
}

-(DropModel *)firstDrop{
   return [self.drops objectAtIndex:0];
}

#pragma data persistence

-(void)saveChanges:(void (^)(ResponseModel *, BucketModel *))completionCallback
           onError:(void (^)(NSError *))errorCallback
        onProgress:(void (^)(NSNumber*))progression
{
    [[self firstDrop] saveChanges:^{
        [self saveChanges:completionCallback
                  onError:errorCallback];
    }
                       onProgress:progression
                          onError:errorCallback];
}
-(void)saveChanges:(void (^)(ResponseModel*, BucketModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
    if(self.Id > 0){
        [self update:completionCallback onError:errorCallback];
    }
    else{
        [self create:completionCallback onError:errorCallback];
    }
}

#pragma CRUD operations

-(void)create:(void (^)(ResponseModel*, BucketModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
    NSDictionary *body = @{
                           @"bucket":[self asDictionary],
                           @"drop":[[self firstDrop] asDictionary]
                           };
        NSLog(@"the body is %@", body);
    [self.applicationController postHttpRequest:@"bucket"
                                           json:[self asJSON:body]
                                   onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         [self showResponseFromData:data withCallback:completionCallback];
     }
                                        onError:errorCallback];
}


-(void)watch:(void (^)(ResponseModel *))completionCallback
     onError:(void (^)(NSError *))errorCallback
{
    [self.applicationController postHttpRequest:[NSString stringWithFormat:@"bucket/%d/watch", self.Id]
                                           json:nil
                                   onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         //[self showResponseFromData:data withCallback:completionCallback];
         ResponseModel *responseModel = [self responseModelFromData:data];
         completionCallback(responseModel);
     }
                                        onError:errorCallback];
}

-(void)unwatch:(void (^)(ResponseModel *))completionCallback
     onError:(void (^)(NSError *))errorCallback
{
    [self.applicationController deleteHttpRequest:[NSString stringWithFormat:@"bucket/%d/watch", self.Id]
                                   onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         //[self showResponseFromData:data withCallback:completionCallback];
         ResponseModel *responseModel = [self responseModelFromData:data];
         completionCallback(responseModel);
     }
                                        onError:errorCallback];
}



-(void)find:(int) bucketId
onCompletion:(void (^)(ResponseModel*, BucketModel*))completionCallback
    onError:(void(^)(NSError *))errorCallback
{
    [self.applicationController getHttpRequest:[NSString stringWithFormat:@"bucket/%d", bucketId]
            onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                [self showResponseFromData:data withCallback:completionCallback];
            } onError:errorCallback];
}

-(void)find:(void (^)(void))completionCallback
    onError:(void(^)(NSError *))errorCallback
{
     __weak typeof(self) weakSelf = self;
    [self.applicationController getHttpRequest:[NSString stringWithFormat:@"bucket/%d", self.Id]
                                  onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                      ResponseModel *responseModel = [self responseModelFromData:data];
                                      [weakSelf refresh:[[responseModel data] objectForKey:@"bucket"]];
                                      completionCallback();
                                  } onError:errorCallback];
}

-(void)update:(void (^)(ResponseModel*, BucketModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
    [self.applicationController putHttpRequest:[NSString stringWithFormat:@"bucket/%d", self.Id]
                                          json:[self asJSON:[self asDictionary]]
                                  onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                     [self showResponseFromData:data withCallback:completionCallback];
                                  } onError:errorCallback];
}

-(void)delete:(void (^)(ResponseModel*, BucketModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
    [self.applicationController deleteHttpRequest:[NSString stringWithFormat:@"bucket/%d", self.Id]
               onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                   [self showResponseFromData:data withCallback:completionCallback];
               } onError:errorCallback];
}

-(void)removeDrop:(DropModel *) drop{
  [self.drops removeObject:drop];
}

-(DropModel *)getDrop:(int)index{
    return [self.drops objectAtIndex:index];
}

#pragma helpers

-(void)showResponseFromData:(NSData *) data
               withCallback:(void (^)(ResponseModel*, BucketModel*))completionCallback
{
    ResponseModel *responseModel = [self responseModelFromData:data];
    BucketModel *bucket = [self bucketFromResponseModel:responseModel];
    completionCallback(responseModel, bucket);
}

-(BucketModel *)bucketFromResponseModel:(ResponseModel *)responseModel
{
    BucketModel *bucket = [[BucketModel alloc] init:[[responseModel data] objectForKey:@"bucket"]];
    if([[responseModel data] objectForKey:@"drop"] != nil){
        DropModel *drop = [[DropModel alloc] init:[[responseModel data] objectForKey:@"drop"]];
        [bucket addDrop:drop];
    }
    return bucket;
}

#pragma not implemented methods




@end
