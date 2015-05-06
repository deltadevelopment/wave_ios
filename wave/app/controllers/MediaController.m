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
    void (^mediaStatus)(NSNumber*(xValue));
}



-(void)putHttpRequestWithImage:(NSData *) imageData token:(NSString *) token onCompletion:(void (^)(NSNumber*))callback{
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
    
    NSLog(@"token is --- %@", token);
    
    mediaStatus = callback;
    NSURLConnection *connection2 = [[NSURLConnection alloc]
                                     initWithRequest:request
                                     delegate:self startImmediately:NO];
    
    [connection2 scheduleInRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
    [connection2 start];
    if (connection2) {
        NSLog(@"connection---");
    };
    
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    long percentageDownloaded = (totalBytesWritten * 100)/totalBytesExpectedToWrite;
    mediaStatus([NSNumber numberWithInt:percentageDownloaded]);
    if(percentageDownloaded == 100){
        
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
