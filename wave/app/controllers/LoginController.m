//
//  LoginController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginController.h"
@implementation LoginController
-(void)login:(NSString *) username
        pass:(NSString *) password
onCompletion:(void (^)(UserModel*,ResponseModel*))callback;
{
    NSLog(@"Device Id sending: %@", [authHelper getDeviceId]);
    NSDictionary *credentials = [self loginBody:username pass:password];
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:credentials];
    [self postHttpRequest:@"login" json:jsonData onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){

        NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strdata);
        NSMutableDictionary *dic = [parserHelper parse:data];
        ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
        UserModel *user = [[UserModel alloc] init:[[dic objectForKey:@"data"] objectForKey:@"user"]];
        [self storeCredentials:[responseModel.data objectForKey:@"user_session"]];
        callback(user, responseModel);
    }];

}

-(NSDictionary *) loginBody:(NSString *) username
                       pass:(NSString *) password
{
    NSDictionary *body;
    if([authHelper getDeviceId] == nil){
        body = @{
                 @"user" : @{
                         @"username" : username,
                         @"password" : password
                         }
                 };
    }else{
        NSLog(@"test");
        body= @{
                @"user" :@{
                        @"username" : username,
                        @"password" : password,
                        @"device_id" : [authHelper getDeviceId],
                        @"device_type":@"ios"
                        }
                };
    }
    return body;
}

-(void)storeCredentials:(NSMutableDictionary *) dic
{
    [authHelper storeCredentials:dic];
}
@end
