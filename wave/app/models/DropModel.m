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
#import "UIHelper.h"
#import "GraphicsHelper.h"

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
        self.thumbnail_url = [self getStringValueFromString:@"thumbnail_url"];
        self.user = [[UserModel alloc]init:[dic objectForKey:@"user"]];
    }
    return self;
};

-(id)init{
self =[super init];
    return  self;
}
-(void)saveChanges:(void (^)(void))completionCallback
        onProgress:(void (^)(NSNumber*))progression
           onError:(void(^)(NSError *))errorCallback
{
    if(self.media_type == 1){
        UIImage *thumbnail = [UIHelper thumbnailFromVideo:[self.mediaModel media]];
        CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
        NSData *thumbnailData = UIImagePNGRepresentation([GraphicsHelper imageByScalingAndCroppingForSize:size img:thumbnail]);
        MediaModel *thumbnailModel = [[MediaModel alloc] init:thumbnailData];
        
        [thumbnailModel uploadMedia:^(NSNumber *number){}
                       onCompletion:^(MediaModel *thumbnailModel){
                           [self.mediaModel uploadMedia:progression
                                           onCompletion:^(MediaModel *mediaModel){
                                               self.media_key = mediaModel.media_key;
                                               self.thumbnail_key = thumbnailModel.media_key;
                                               completionCallback();
                                           }
                                                onError:errorCallback];
                       }
                            onError:errorCallback];
        
        
    }else{
        [self.mediaModel uploadMedia:progression
                        onCompletion:^(MediaModel *mediaModel){
                            self.media_key = mediaModel.media_key;
                            completionCallback();
                        }
                             onError:errorCallback];
    }

}

-(void)saveChangesToDrop:(void (^)(ResponseModel*, DropModel*))completionCallback
 onProgress:(void (^)(NSNumber*))progression
    onError:(void(^)(NSError *))errorCallback{
    [self saveChanges:^{
        NSDictionary *body = @{
                               @"drop":[self asDictionary]
                               };
        [self.applicationController postHttpRequest:[NSString stringWithFormat:@"bucket/%d/drop", self.bucket_id]
                                               json:[self asJSON:body]
                                       onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
         {
             NSMutableDictionary *dic = [ParserHelper parse:data];
             ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
             DropModel *drop = [[DropModel alloc] init:[[responseModel data] objectForKey:@"drop"]];
             completionCallback(responseModel, drop);
         } onError:errorCallback];
    
    } onProgress:progression onError:errorCallback];
    
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

-(void)downloadThumbnail:(void (^)(NSData*))completionCallback
{
    [mediaController getMedia:self.thumbnail_url
                 onCompletion:^(NSData *data){
                     self.thumbnail_tmp = data;
                     completionCallback(data);
                 }
                      onError:^(NSError *error){
                      }];
}

-(NSDictionary *)asDictionary
{
    NSDictionary *dictionary = nil;
    if(self.media_type == 1){
        dictionary = @{
                       @"media_key" : self.media_key,
                       @"caption" : self.caption,
                       @"media_type" : [NSNumber numberWithInt:self.media_type],
                       @"thumbnail_key": self.thumbnail_key
                       };
    }
    else{
        dictionary = @{
                       @"media_key" : self.media_key,
                       @"caption" : self.caption,
                       @"media_type" : [NSNumber numberWithInt:self.media_type]
                       };
    }
    
    return dictionary;
}

-(void)requestPhoto:(void (^)(NSData*))completionCallback{
    if(self.media_tmp == nil){
        NSLog(@"image is not here already");
        [self downloadImage:completionCallback];
    }else{
        NSLog(@"image is here already");
        completionCallback(self.media_tmp);
    }
}

-(void)requestThumbnail:(void (^)(NSData*))completionCallback{
    if(self.thumbnail_tmp == nil){
        [self downloadThumbnail:completionCallback];
    }else{
        completionCallback(self.thumbnail_tmp);
    }
}




@end
