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
    void (^mediaDownloadComplete)(NSData*(data));
    bool isUploading;
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
    
    ;
    /*
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSLog(@"downloading");
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
     */
    
}


-(void)downloadMedia:(NSString *) urlPath
   onCompletion:(void (^)(NSData*))completionCallback
        onError:(void(^)(NSError *))errorCallback
 onProgress:(void (^)(NSNumber*))progression

{
    isUploading = NO;
    NSURL *url = [NSURL URLWithString:urlPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    mediaDownloadComplete = completionCallback;
    mediaProgression = progression;
    
    
    self.theConnection = [[NSURLConnection alloc]
                                    initWithRequest:request
                                    delegate:self startImmediately:NO];
    
    
        [self.theConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                      forMode:NSDefaultRunLoopMode];
        [self.theConnection start];


    
 
   
    
}

-(void)putHttpRequestWithImage:(NSData *) imageData
                         token:(NSString *) token
                    onProgress:(void (^)(NSNumber*))progression
                  onCompletion:(void (^)(void))callback

{
    //POST/PUT to Amazon
    //STEP 2: Upload image to S3 with generated token from backend
    isUploading = YES;
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
        if (isUploading) {
            mediaUploadComplete();
        }else{
            
        }
        
    }
    
    NSLog(@"perce");
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    NSLog(@"response %ld", (long)[httpResponse statusCode]);
    //NSLog(@"Data is %lu", (unsigned long)[array count]);
  
    _data = [[NSMutableData alloc] init];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (_data == nil){
        _data = [[NSMutableData alloc]init];
    }
    [_data appendData:data];
    //[_data appendData:data];
}

-(void)stopConnection{
    if(self.theConnection != nil){
        NSLog(@"Canceled the connection");
        [self.theConnection cancel];
    }
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    mediaDownloadComplete(_data);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"ERROR: %@",  [error localizedDescription]);
}



@end
