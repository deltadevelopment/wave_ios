//
//  MediaModel.m
//  wave
//
//  Created by Simen Lie on 20.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MediaModel.h"
#import "MediaController.h"
@implementation MediaModel{
    MediaController *mediaController;
}
-(id)init:(NSData *) media{
    self =[super init];
    mediaController = [[MediaController alloc] init];
    self.media = media;
    return self;
};

-(void)generateUploadURL:(void (^)(ResponseModel*, MediaModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
   
}

-(void)uploadMedia:(void (^)(NSNumber*))progression
      onCompletion:(void (^)(MediaModel*))completionCallback
           onError:(void(^)(NSError *))errorCallback{
    
    
    
    [self.applicationController postHttpRequest:@"drop/generate_upload_url"
                                           json:nil
                                   onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                       
                                       //Parsing av data som returneres
                                       NSMutableDictionary *dic = [ParserHelper parse:data];
                                       ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                                       self.upload_url =  [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"url"];
                                       self.media_key = [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"media_key"];
                                       
                                       [mediaController putHttpRequestWithImage:self.media
                                                                          token:self.upload_url onProgress:^(NSNumber *percentage)
                                        {
                                            NSLog(@"HER:::_________PROG");
                                            progression(percentage);
                                        }
                                                                   onCompletion:^
                                        {
                                            completionCallback(self);
                                        }];
                                       
                                   } onError:errorCallback];
    
    
    
}

@end
