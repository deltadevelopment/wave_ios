//
//  RegisterController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RegisterController.h"


@implementation RegisterController
-(void)registerUser:(NSString *) username
               pass:(NSString *) password
              email:(NSString *) email
       onCompletion:(void (^)(UserModel*,ResponseModel*))callback
 onError:(void(^)(NSError *))errorCallback;

{
    //Logout
    //[authHelper resetCredentials];
    //Create dictionary with username and password
    NSDictionary *credentials = @{
                                  @"user":@{
                                          @"username" : username,
                                          @"password" : password,
                                          @"email": email
                                          }
                                  };
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:credentials];
    
    [self postHttpRequest:@"register"
                     json:jsonData
             onCompletion:^(NSURLResponse *response,NSData *data,NSError *error)
     
     {
         //request finished
         //NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
         //NSInteger statuscode = [httpResponse statusCode];
        // NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        // NSLog(@"%@",strdata);
         NSMutableDictionary *dic = [ParserHelper parse:data];
         ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
         UserModel *user = [[UserModel alloc] init:[[dic objectForKey:@"data"] objectForKey:@"user"]];
         callback(user, responseModel);
     } onError:errorCallback];
    
};

@end
