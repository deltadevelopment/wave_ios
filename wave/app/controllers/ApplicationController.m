//
//  ApplicationController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "NotificationHelper.h"
#import "StartViewController.h"
#import "AppDelegate.h"
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
    NSLog(@"GET : %@", urlFromString);
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
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                   //NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                   NSInteger statuscode = [httpResponse statusCode];
                                   if(statuscode < 300){
                                       callback(response,data,error);
                                   }else{
                                       [self handleError:response withError:error withData:data];
                                       callback(response,data,error);
                                   }
                               }
                               else
                               {
                                   [self handleError:response withError:error withData:data];
                                   // NSLog([error localizedDescription]);
                                   NSMutableDictionary *errors;
                                   if (data != nil) {
                                       errors = [ParserHelper parse:data];
                                   }
                                   NSError *httpError = [NSError errorWithDomain:@"world" code:200 userInfo:errors];
                                   errorCallback(httpError);
                               }
                           }];
}

-(void)handleError:(NSURLResponse *) response
         withError:(NSError *) error
          withData:(NSData *) data
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSInteger statuscode = [httpResponse statusCode];
    NSLog(@"-------------------------");
    //NSURL *URLER = ;
    NSLog(@"URL: %@", [[response URL] absoluteString]);
    NSLog(@"response status code: %ld", (long)statuscode);
    //NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@", strdata);
    ResponseModel *responseModel;
    if (data != nil) {
        responseModel = [[ResponseModel alloc] init:[ParserHelper parse:data]];
        NSLog(@"Model message: %@", responseModel.message);
    }

    if((error.code == NSURLErrorUserCancelledAuthentication && statuscode == 0) || statuscode == 401){
        NSLog(@"Logg ut her");
        statuscode = 401;
        [authHelper resetCredentials];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        StartViewController *navigation =[mainStoryboard instantiateViewControllerWithIdentifier:@"startNav"];
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        appDelegateTemp.window.rootViewController = navigation;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Network error %ld", (long)statuscode]
                                                       message:[NSString stringWithFormat:@"Message: %@ \n URL: %@", responseModel.message, [[response URL] absoluteString]]
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    // NSLog(@"-------------------------");
}
/*
-(void)showNotification:(NSObject *) view withData: (NSData *) data{
    notificationHelper =[[NotificationHelper alloc] initNotification];
    UIViewController *viewController = (UIViewController *) view;
    [notificationHelper setNotificationMessage:data];
    [notificationHelper addNotificationToView:viewController.navigationController.view];
}
*/
@end
