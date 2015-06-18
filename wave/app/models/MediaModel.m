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
    self.endpoint = @"drop";
    return self;
};

-(void)generateUploadURL:(void (^)(ResponseModel*, MediaModel*))completionCallback onError:(void(^)(NSError *))errorCallback{
   
}

-(void)uploadMedia:(void (^)(NSNumber*))progression
      onCompletion:(void (^)(MediaModel*))completionCallback
           onError:(void(^)(NSError *))errorCallback{
    
    NSLog(@"media model laster");
    NSString *stringUrl = [NSString stringWithFormat:@"%@/generate_upload_url", self.endpoint];
    [self.applicationController getHttpRequest:stringUrl
                                   onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                       NSLog(@"done");
                                       //Parsing av data som returneres
                                       NSMutableDictionary *dic = [ParserHelper parse:data];
                                       ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                                       self.upload_url =  [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"url"];
                                       self.media_key = [[[responseModel data] objectForKey:@"upload_url"] objectForKey:@"media_key"];
                                       [mediaController putHttpRequestWithImage:self.media
                                                                          token:self.upload_url onProgress:^(NSNumber *percentage)
                                        {
                                            progression(percentage);
                                        }
                                                                   onCompletion:^
                                        {
                                            completionCallback(self);
                                        }];
                                       
                                   } onError:errorCallback];
    
    
    
}

@end
