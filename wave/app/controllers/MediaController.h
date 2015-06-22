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

@property (strong, nonatomic)  NSURLConnection *theConnection;
@property (strong, nonatomic)  NSMutableData *data;

-(void)putHttpRequestWithImage:(NSData *) imageData
                         token:(NSString *) token
                    onProgress:(void (^)(NSNumber*))progression
                  onCompletion:(void (^)(void))callback;


-(void)downloadMedia:(NSString *) urlPath
        onCompletion:(void (^)(NSData*))completionCallback
             onError:(void(^)(NSError *))errorCallback
          onProgress:(void (^)(NSNumber*))progression;

-(void)stopConnection;
@end
