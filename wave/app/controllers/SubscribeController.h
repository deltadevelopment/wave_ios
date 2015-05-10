//
//  SubscribeController.h
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"

@interface SubscribeController : ApplicationController

-(void)subscribeToUser:(int) user_id
      withSubscribeeId:(int) subscribee_id
          onCompletion:(void (^)(ResponseModel*))completionCallback;

-(void)unSubscribeToUser:(int) user_id
        withSubscribeeId:(int) subscribee_id
            onCompletion:(void (^)(ResponseModel*))completionCallback;
@end
