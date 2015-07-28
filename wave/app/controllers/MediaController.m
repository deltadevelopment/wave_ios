//
//  MediaController.m
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MediaController.h"
#import "ConfigHelper.h"
#import "AuthHelper.h"
@implementation MediaController
{
    void (^mediaUploadComplete)(void);
    void (^mediaProgression)(NSNumber*(progress));
    void (^mediaDownloadComplete)(NSData*(data));
    void (^searchCompleted)(NSData*(data));
    bool isUploading;
    bool isSearching;
    AuthHelper *authHelper;
    NSInteger statusCode;
    long expectedContentSize;
}

-(void)downloadMedia:(NSString *) urlPath
   onCompletion:(void (^)(NSData*))completionCallback
        onError:(void(^)(NSError *))errorCallback
 onProgress:(void (^)(NSNumber*))progression

{
    isUploading = NO;
    NSURL *url = [NSURL URLWithString:urlPath];
    NSLog(@"GET DOWNLOAD : %@", url);
    NSLog(@"-------------------------");
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


-(void)search:(NSString *) urlPath
        onCompletion:(void (^)(NSData*))completionCallback
             onError:(void(^)(NSError *))errorCallback
{
    isUploading = NO;
    isSearching = YES;
    authHelper = [[AuthHelper alloc] init];
    urlPath = [NSString stringWithFormat:@"%@/%@", [[[ConfigHelper alloc] init] baseUrl], urlPath];
    NSString *urlPathWithSpaces = [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlPathWithSpaces];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    searchCompleted = completionCallback;
    
    
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
            NSLog(@"dd");
            mediaUploadComplete();
        }else{
            
        }
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"response %ld", (long)[httpResponse statusCode]);
    _data = [[NSMutableData alloc] init];
    statusCode = [httpResponse statusCode];
    if (statusCode == 200) {
        expectedContentSize = [response expectedContentLength];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (_data == nil){
        _data = [[NSMutableData alloc]init];
    }
    [_data appendData:data];
    long percentageDownloaded = ([_data length] * 100)/expectedContentSize;
    if (mediaProgression != nil) {
        mediaProgression([NSNumber numberWithInt:(int)percentageDownloaded]);
    }
}

-(void)stopConnection{
    if(self.theConnection != nil){
        NSLog(@"Canceled the connection");
        [self.theConnection cancel];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (isSearching) {
        searchCompleted(_data);
    }
    else if (!isUploading) {
         mediaDownloadComplete(_data);
    }
   
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"ERROR: %@",  [error localizedDescription]);
}



@end
