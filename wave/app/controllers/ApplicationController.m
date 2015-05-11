//
//  ApplicationController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "NotificationHelper.h"
@implementation ApplicationController

- (id)init
{
    self = [super init];
    if (self) {
        //viewController = [[UIViewController alloc] init];
        authHelper = [[AuthHelper alloc] init];
        parserHelper = [[ParserHelper alloc] init];
        applicationHelper = [[ApplicationHelper alloc] init];
        mediaController = [[MediaController alloc] init];
    }
    return self;
}

-(void)getHttpRequest:(NSString *) url
         onCompletion:(void (^)(NSURLResponse*, NSData *, NSError*))callback
              onError:(void(^)(NSError *))errorCallback
{
    NSURL *urlFromString = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlFromString cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1200.0];
    [request setValue:@"text" forHTTPHeaderField:@"Content-type"];
    [request addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [request setHTTPMethod:@"GET"];
    [self sendRequestAsync:request onCompletion:callback onError:errorCallback];
}

-(void) postHttpRequest:(NSString *) url
                   json:(NSString *) data
           onCompletion:(void (^)(NSURLResponse*, NSData *, NSError*))callback
                onError:(void(^)(NSError *))errorCallback
{
    NSURL * urlFromString = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:urlFromString];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",[request URL]);
    [self sendRequestAsync:request onCompletion:callback onError:errorCallback];
};

-(void) deleteHttpRequest:(NSString *) url
             onCompletion:(void (^)(NSURLResponse*, NSData *, NSError*))callback
                  onError:(void(^)(NSError *))errorCallback
{
    NSURL *urlFromString = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:urlFromString];
    [request setValue:@"text" forHTTPHeaderField:@"Content-type"];
    [request addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [request setHTTPMethod:@"DELETE"];
    [self sendRequestAsync:request onCompletion:callback onError:errorCallback];
    
};
-(void) putHttpRequest:(NSString *) url
                  json:(NSString *) data
          onCompletion:(void (^)(NSURLResponse*, NSData *, NSError*))callback
               onError:(void(^)(NSError *))errorCallback
{
    NSURL *urlFromString = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:urlFromString];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    [self sendRequestAsync:request onCompletion:callback onError:errorCallback];
    
    
    
};

-(void)sendRequestAsync:(NSMutableURLRequest *)request
           onCompletion:(void (^)(NSURLResponse*, NSData *, NSError*))callback
                onError:(void(^)(NSError *))errorCallback
{
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               
                               if (data != nil && error == nil)
                               {
                                   //Ferdig lastet ned
                                   callback(response,data,error);
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                   NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                   NSInteger statuscode = [httpResponse statusCode];
                                   if(statuscode < 300){
                                       //[view performSelector:success withObject:data];
                                       
                                   }else{
                                       
                                       /*
                                        NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                        [applicationHelper alertUser:[NSString stringWithFormat:@"%ld on %@",(long)statuscode, strdata]];
                                        
                                        [self showNotification:view withData:data];
                                        if(statuscode == 403){
                                        [self logoutUser:view];
                                        }
                                        NSMutableDictionary *errors = [parserHelper parse:data];
                                        NSError *httpError = [NSError errorWithDomain:@"world" code:200 userInfo:errors];
                                        [view performSelector:errorAction withObject:httpError];
                                        */
                                   }
                               }
                               else
                               {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                   NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                   errorCallback(error);
                                   // There was an error, alert the user
                                   //[self showNotification:view withData:data];
                                   //[view performSelector:errorAction withObject:error];
                                   
                               }
                           }];
}

-(void)showNotification:(NSObject *) view withData: (NSData *) data{
    notificationHelper =[[NotificationHelper alloc] initNotification];
    UIViewController *viewController = (UIViewController *) view;
    [notificationHelper setNotificationMessage:data];
    [notificationHelper addNotificationToView:viewController.navigationController.view];
}

@end
