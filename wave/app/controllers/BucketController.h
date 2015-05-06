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
-(void)createNewBucket:(BucketModel *)bucket
            onProgress:(void (^)(NSNumber*))progression
          onCompletion:(void (^)(BucketModel*,ResponseModel*))completionCallback;

-(void)updateBucket:(BucketModel *) bucket
       onCompletion:(void (^)(ResponseModel*))completionCallback;

-(void)deleteBucket:(BucketModel *) bucket
       onCompletion:(void (^)(ResponseModel*))completionCallback;
@end
