//
//  TagController.h
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"

@interface TagController : ApplicationController
-(void)addTagToBucket:(NSString*) tag
         withBucketId:(int) bucket_id
         onCompletion:(void (^)(ResponseModel*))completionCallback
              onError:(void(^)(NSError *))errorCallback;
-(void)deleteTag:(int)tag_id
    onCompletion:(void (^)(ResponseModel*))completionCallback
         onError:(void(^)(NSError *))errorCallback;
@end
