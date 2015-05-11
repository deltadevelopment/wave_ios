//
//  BucketController.h
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "BucketModel.h"
@interface BucketController : ApplicationController
-(void)createNewBucket:(NSData *)media
       withBucketTitle:(NSString *) bucketTitle
 withBucketDescription:(NSString *) bucketDescription
       withDropCaption:(NSString *) dropCaption
            onProgress:(void (^)(NSNumber*))progression
          onCompletion:(void (^)(ResponseModel*))completionCallback
               onError:(void(^)(NSError *))errorCallback;

-(void)updateBucket:(BucketModel *) bucket
       onCompletion:(void (^)(ResponseModel*))completionCallback
            onError:(void(^)(NSError *))errorCallback;

-(void)deleteBucket:(BucketModel *) bucket
       onCompletion:(void (^)(ResponseModel*))completionCallback
            onError:(void(^)(NSError *))errorCallback;
@end
