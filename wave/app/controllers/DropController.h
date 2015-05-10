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
            onProgress:(void (^)(NSNumber*))onProgression
          onCompletion:(void (^)(ResponseModel*))completionCallback;

-(void)deleteDrop:(int)drop_id
     onCompletion:(void (^)(ResponseModel*))completionCallback;
@end
