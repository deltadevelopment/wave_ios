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
#import "CacheModel.h"


@implementation DropModel

-(id)init:(NSMutableDictionary *)dic{
    self.cacheHelper = [[CacheHelper alloc] init];
    if((NSNull*)dic != [NSNull null]){
        self =[super init];
        self.dictionary = dic;
        self.mediaController = [[MediaController alloc] init];
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
        self.thumbnail_key = [self getStringValueFromString:@"thumbnail_key"];
        self.user = [[UserModel alloc]init:[dic objectForKey:@"user"]];
        self.most_votes = [self getIntValueFromString:@"most_votes"];
        self.total_votes_count = [self getIntValueFromString:@"total_votes_count"];
        if((NSNull*)[self.dictionary objectForKey:@"originator"] != [NSNull null]){
            self.originator = [[UserModel alloc]init:[dic objectForKey:@"originator"]];
        }
        
    }
    return self;
};

-(id)init{
    self =[super init];
    self.cacheHelper = [[CacheHelper alloc] init];
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
        NSLog(@"the body is %@", body);
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
    if (!self.isDownloading) {
        self.isDownloading = YES;
        [self.mediaController downloadMedia:self.media_url
                               onCompletion:^(NSData *data){
                                   self.media_tmp = data;
                                   self.isDownloading = NO;
                                   [self storeMediaInCache:data];
                                   completionCallback(data);
                               }
                                    onError:^(NSError *error){
                                        
                                    }
                                 onProgress:^(NSNumber *progress){
                                     
                                 }];
    }
}

-(void)cancelDownload{
    [self.mediaController stopConnection];
}

-(void)downloadThumbnail:(void (^)(NSData*))completionCallback
{
    [self.mediaController downloadMedia:self.thumbnail_url
                           onCompletion:^(NSData *data){
                               self.thumbnail_tmp = data;
                               [self storeThumbnailInCache:data];
                               completionCallback(data);
                           }
                                onError:^(NSError *error){
                                    
                                }
                             onProgress:^(NSNumber *progress){
                                 
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
    self.media_tmp = self.media_tmp == nil ? [self mediaFromCache] : self.media_tmp;
    if(self.media_tmp == nil){
        [self downloadImage:completionCallback];
    }else{
        completionCallback(self.media_tmp);
    }
}

-(void)requestThumbnail:(void (^)(NSData*))completionCallback{
    self.thumbnail_tmp = self.thumbnail_tmp == nil ? [self thumbnailFromCache] : self.thumbnail_tmp;
    if(self.thumbnail_tmp == nil){
        [self downloadThumbnail:completionCallback];
    }else{
        completionCallback(self.thumbnail_tmp);
    }
}


-(void)redrop:(void (^)(ResponseModel *))completionCallback
     onError:(void (^)(NSError *))errorCallback
{
    [self.applicationController postHttpRequest:[NSString stringWithFormat:@"drop/%d/redrop", self.Id]
                                           json:nil
                                   onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     {
         //[self showResponseFromData:data withCallback:completionCallback];
         ResponseModel *responseModel = [self responseModelFromData:data];
         completionCallback(responseModel);
     }
                                        onError:errorCallback];
}

-(void)delete:(void (^)(ResponseModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
    [self.applicationController deleteHttpRequest:[NSString stringWithFormat:@"drop/%d", self.Id]
                                     onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                         ResponseModel *responseModel = [self responseModelFromData:data];
                                         completionCallback(responseModel);
                                     } onError:errorCallback];
}

-(void)storeMediaInCache:(NSData *) data{
    //1 - First store the image or video to documents
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * dataFileName;
    if (self.media_type == 0) {
        dataFileName = [NSString stringWithFormat:@"%@.png",[self media_key]]; // Create unique iD
    }else{
        dataFileName = [NSString stringWithFormat:@"%@.mp4",[self media_key]]; // Create unique iD
    }
    NSString * dataFile = [documentsDirectory stringByAppendingPathComponent:dataFileName];
    if ([data writeToFile:dataFile atomically:YES])
    {
        //2 - If the media was stored successfully, store the filename as a key with the current date stored
        [CacheHelper storeFilenameWithDate:dataFileName];
        NSLog(@"Wrote to documents sucessfully");
    }
}

-(NSData *)mediaFromCache{
    if (self.media_key != nil) {
        NSData *data = [self dataFromDocumentCache];
        if (data == nil) {
            return nil;
        }else{
            return data;
        }
    }
    return nil;
}

-(NSData *)dataFromDocumentCache{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * dataFileName;
    if (self.media_type == 0) {
        dataFileName = [NSString stringWithFormat:@"%@.png",[self media_key]]; // Create unique iD
    }else{
        dataFileName = [NSString stringWithFormat:@"%@.mp4",[self media_key]]; // Create unique iD
    }
    NSString * dataFile = [documentsDirectory stringByAppendingPathComponent:dataFileName];
    
    NSData *data = [NSData dataWithContentsOfFile:dataFile];
    return data;
}


-(void)storeThumbnailInCache:(NSData *) data{
    if (self.thumbnail_key != nil) {
        NSData *cacheData = [self dataThumbnailFromDocumentCache];
        if (cacheData == nil) {
            //1 - First store the image or video to documents
            NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * documentsDirectory = [paths objectAtIndex:0];
            NSString * dataFileName = [NSString stringWithFormat:@"%@.png",self.thumbnail_key]; // Create unique iD
            
            NSString * dataFile = [documentsDirectory stringByAppendingPathComponent:dataFileName];
            if ([data writeToFile:dataFile atomically:YES])
            {
                //2 - If the media was stored successfully, store the filename as a key with the current date stored
                [CacheHelper storeFilenameWithDate:dataFileName];
                NSLog(@"Wrote to documents sucessfully");
            }
        }
    }
}

-(NSData *)thumbnailFromCache{
    if (self.thumbnail_key != nil) {
        NSData *data = [self dataThumbnailFromDocumentCache];
        if (data == nil) {
            return nil;
        }else{
            return data;
        }
    }
    return nil;
}



-(NSData *)dataThumbnailFromDocumentCache{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * dataFileName = [NSString stringWithFormat:@"%@.png",[self thumbnail_key]]; // Create unique iD
   
    NSString * dataFile = [documentsDirectory stringByAppendingPathComponent:dataFileName];
    
    NSData *data = [NSData dataWithContentsOfFile:dataFile];
    return data;
}

-(void)fetchVotes:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback{
    self.funnyVotes = [[NSMutableArray alloc] init];
    self.coolVotes = [[NSMutableArray alloc] init];
    [self.applicationController getHttpRequest:[NSString stringWithFormat:@"drop/%d/votes", self.Id]
                                  onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                      NSMutableDictionary *dic = [ParserHelper parse:data];
                                      ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                                      [self feedFromResponseModel:responseModel];
                                      completionCallback();
                                      
                                  } onError:errorCallback];
}

-(void)feedFromResponseModel:(ResponseModel *) response{
    NSMutableArray *rawVotes = [[response data] objectForKey:@"votes"];
    for(NSMutableDictionary *rawVote in rawVotes){
        TemperatureModel *temperatureModel = [[TemperatureModel alloc] init:rawVote];
        if (temperatureModel.temperature ==0) {
            //Funny
            [self.funnyVotes addObject:temperatureModel];
        }else{
            [self.coolVotes addObject:temperatureModel];
        }
    }
}

-(void)cacheVote{
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"vote-%d", self.Id]];
}

-(BOOL)hasVotedAlready{
  BOOL hasVoted = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"vote-%d", self.Id]];
    return hasVoted;
}






@end
