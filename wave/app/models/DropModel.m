//
//  DropModel.m
//  wave
//
//  Created by Simen Lie on 05/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DropModel.h"
#import "MediaController.h"
#import "MediaModel.h"

@implementation DropModel
MediaController *mediaController;
-(id)init:(NSMutableDictionary *)dic{
    
    if((NSNull*)dic != [NSNull null]){
        self =[super init];
        self.dictionary = dic;
        mediaController = [[MediaController alloc] init];
        self.media_key = [dic objectForKey:@"media_key"];
        self.media_url = [dic objectForKey:@"media_url"];
        self.caption = [dic objectForKey:@"caption"];
        self.created_at = [dic objectForKey:@"created_at"];
        self.updated_at = [dic objectForKey:@"updated_at"];
        self.media_type = [self getIntValueFromString:@"media_type"];
        self.parent_id = [self getIntValueFromString:@"parent_id"];
        self.Id = [self getIntValueFromString:@"id"];
        self.bucket_id = [self getIntValueFromString:@"bucket_id"];
        self.user_id = [self getIntValueFromString:@"user_id"];
        self.lft = [self getIntValueFromString:@"lft"];
        self.rgt = [self getIntValueFromString:@"rgt"];
        self.temperature = [self getIntValueFromString:@"temperature"];
        
        self.user = [[UserModel alloc]init:[dic objectForKey:@"user"]];
    }


    
    return self;
};

-(void)saveChanges:(void (^)(void))completionCallback
        onProgress:(void (^)(NSNumber*))progression
           onError:(void(^)(NSError *))errorCallback
{
    [self.mediaModel uploadMedia:progression
               onCompletion:^(MediaModel *mediaModel){
                   self.media_key = mediaModel.media_key;
                   completionCallback();
               }
                    onError:errorCallback];
}

-(void)downloadImage:(void (^)(NSData*))completionCallback
{
    [mediaController getMedia:self.media_url
                 onCompletion:^(NSData *data){
                     self.media_tmp = data;
                     completionCallback(data);
                 }
                      onError:^(NSError *error){
                          
                          
                      }];
    
}

-(NSDictionary *)asDictionary
{
    NSDictionary *dictionary = @{
                                 @"media_key" : self.media_key,
                                 @"caption" : self.caption,
                                 @"media_type" : [NSNumber numberWithInt:self.media_type]
                                 };
    return dictionary;
}

-(void)requestPhoto:(void (^)(NSData*))completionCallback{
    if(self.media_tmp == nil){
        [self downloadImage:completionCallback];
    }else{
        completionCallback(self.media_tmp);
    }
}




@end
