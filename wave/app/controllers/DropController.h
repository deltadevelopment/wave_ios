//
//  DropController.h
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"

@interface DropController : ApplicationController
-(void)addDropToBucket:(NSString*) caption
             withMedia:(NSData*) media
          withBucketId:(int)bucket_id
         withMediaType:(int)media_type
            onProgress:(void (^)(NSNumber*))onProgression
          onCompletion:(void (^)(ResponseModel*))completionCallback
               onError:(void(^)(NSError *))errorCallback;

-(void)deleteDrop:(int)drop_id
     onCompletion:(void (^)(ResponseModel*))completionCallback
 onError:(void(^)(NSError *))errorCallback;
@end
