//
//  LoginController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginController.h"
#import "DataHelper.h"
@implementation LoginController
-(void)login:(NSString *) username
        pass:(NSString *) password
onCompletion:(void (^)(UserModel*,ResponseModel*))callback
 onError:(void(^)(NSError *))errorCallback;
{
    NSDictionary *credentials = [self loginBody:username pass:password];
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:credentials];
    [self postHttpRequest:@"login" json:jsonData onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){

        NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = [ParserHelper parse:data];
        ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
        UserModel *user = [[UserModel alloc] init:[[dic objectForKey:@"data"] objectForKey:@"user"]];
        [self storeCredentials:[responseModel.data objectForKey:@"user_session"]];
        int bucketId = [[[responseModel.data objectForKey:@"bucket"] objectForKey:@"id"] intValue];
        [DataHelper storeBucketId:bucketId];
        callback(user, responseModel);
    } onError:errorCallback];

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
        body= @{
                @"user" :@{
                        @"username" : username,
                        @"password" : password,
                        @"device_id" : [authHelper getDeviceId],
                        @"device_type":@"ios"
                        }
                };
    }
    
    NSLog(@"my dic us %@", body);
    return body;
}

-(void)storeCredentials:(NSMutableDictionary *) dic
{
    [authHelper storeCredentials:dic];
}
@end
