//
//  DropModel.m
//  wave
//
//  Created by Simen Lie on 05/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DropModel.h"
#import "MediaController.h"

@implementation DropModel
MediaController *mediaController;
-(id)init:(NSMutableDictionary *)dic{
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
    
    self.user = [[UserModel alloc]init:[dic objectForKey:@"user"]];
    
    return self;
};

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

-(void)requestPhoto:(void (^)(NSData*))completionCallback{
    if(self.media_tmp == nil){
        [self downloadImage:completionCallback];
    }else{
        completionCallback(self.media_tmp);
    }
}


@end
