//
//  ApplicationController.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthHelper.h"
#import "ParserHelper.h"
#import "NotificationHelper.h"
#import "ApplicationHelper.h"
#import "ResponseModel.h"
#import "MediaController.h"
@interface ApplicationController : NSObject{
    AuthHelper *authHelper;
    ParserHelper *parserHelper;
    ApplicationHelper *applicationHelper;
    BOOL isErrors;
    NSURLConnection *connection;
    SEL mediaUploadSuccess;
    NSObject *mediaUploadSuccessObject;
    NSObject *mediaUploadSuccessArg;
    NotificationHelper *notificationHelper;
    MediaController *mediaController;
}
-(void)getHttpRequest:(NSString *) url
         onCompletion:(void (^)(NSURLResponse*, NSData *, NSError*))callback;

-(void) postHttpRequest:(NSString *) url
                   json:(NSString *) data
           onCompletion:(void (^)(NSURLResponse*, NSData *, NSError*))callback;

-(void) deleteHttpRequest:(NSString *) url
             onCompletion:(void (^)(NSURLResponse*, NSData *, NSError*))callback;

-(void) putHttpRequest:(NSString *) url
                  json:(NSString *) data
          onCompletion:(void (^)(NSURLResponse*, NSData *, NSError*))callback;

@end
