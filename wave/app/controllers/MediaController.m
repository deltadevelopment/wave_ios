//
//  MediaController.m
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MediaController.h"

@implementation MediaController
{
    void (^mediaUploadComplete)(void);
    void (^mediaProgression)(NSNumber*(progress));
}



-(void)getMedia:(NSString *) urlPath
   onCompletion:(void (^)(NSData*))completionCallback
        onError:(void(^)(NSError *))errorCallback
{
    //NSLog(@"downloading image");
    //NSLog(_media_url);
    NSURL *url = [NSURL URLWithString:urlPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    NSString *strdata=[[NSString alloc]initWithData:cachedURLResponse.data encoding:NSUTF8StringEncoding];
    //NSLog(@"cached data %@",strdata);
    //check if has cache
    
    
    //[request setTimeoutInterval: 10.0]; // Will timeout after 10 seconds
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               //NSLog(@"downloading");
                               if (data != nil && error == nil)
                               {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                   
                                   NSInteger statuscode = [httpResponse statusCode];
                                   NSCachedURLResponse *cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
                                   [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:request];
                                   
                                   if(statuscode < 300){
                                       //SUKSESS
                                       completionCallback(data);
                                   }else{
                                       errorCallback(error);
                                   }
                                   
                               }
                               else
                               {
                                   errorCallback(error);
                               }
                               
                           }];
    
}
-(void)test:(void (^)(void))callback
{}

-(void)putHttpRequestWithImage:(NSData *) imageData
                         token:(NSString *) token
                    onProgress:(void (^)(NSNumber*))progression
                  onCompletion:(void (^)(void))callback

{
    //POST/PUT to Amazon
    //STEP 2: Upload image to S3 with generated token from backend
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]];
    
    // Init the URLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"PUT"];
    [request setURL:[NSURL URLWithString:token]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:imageData];
    //[request addData:audioData withFileName:videoName andContentType:@"video/mov" forKey:@"videoFile"];
    
    
    mediaUploadComplete = callback;
    mediaProgression = progression;
    NSURLConnection *connection2 = [[NSURLConnection alloc]
                                    initWithRequest:request
                                    delegate:self startImmediately:NO];
    
    [connection2 scheduleInRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
    [connection2 start];
    if (connection2) {
    };
    
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    long percentageDownloaded = (totalBytesWritten * 100)/totalBytesExpectedToWrite;
    mediaProgression([NSNumber numberWithInt:(int)percentageDownloaded]);
    if(percentageDownloaded == 100){
        mediaUploadComplete();
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //NSLog(@"-----RESPO fra server");
    NSLog(@"%ld", (long)[httpResponse statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL{
}
@end
