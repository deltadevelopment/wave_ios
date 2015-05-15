//
//  MediaController.h
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaController : NSObject<NSURLConnectionDataDelegate>
{
 NSURLConnection *connection;

}
-(void)putHttpRequestWithImage:(NSData *) imageData token:(NSString *) token onCompletion:(void (^)(NSNumber*))callback;
-(void)getMedia:(NSString *) urlPath
   onCompletion:(void (^)(NSData*))completionCallback
        onError:(void(^)(NSError *))errorCallback;
@end
