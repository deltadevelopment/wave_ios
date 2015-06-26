//
//  LoginController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginController.h"
#import "DataHelper.h"
#import "SubscribeModel.h"
#import "UserFeed.h"
@implementation LoginController
-(void)login:(NSString *) username
        pass:(NSString *) password
onCompletion:(void (^)(UserModel*,ResponseModel*))callback
 onError:(void(^)(NSError *))errorCallback;
{
    self.isLoggingIn = YES;
    NSDictionary *credentials = [self loginBody:username pass:password];
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:credentials];
    [self postHttpRequest:@"login" json:jsonData onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
        NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = [ParserHelper parse:data];
        ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
        UserModel *user = [[UserModel alloc] init:[[dic objectForKey:@"data"] objectForKey:@"user"]];
        BucketModel *bucket = [[BucketModel alloc] init:[[dic objectForKey:@"data"] objectForKey:@"bucket"]];
        [self storeBucketId:bucket];
        [self storeCredentials:[responseModel.data objectForKey:@"user_session"]];
        int bucketId = [[[responseModel.data objectForKey:@"bucket"] objectForKey:@"id"] intValue];
        [DataHelper storeBucketId:bucketId];
        callback(user, responseModel);
        
        int userId =  [[[responseModel.data objectForKey:@"user_session"] objectForKey:@"user_id"] intValue];
        [self fetchSubscriptionsForId:userId];
    } onError:errorCallback];
}

-(void)fetchSubscriptionsForId:(int) Id{
    UserFeed *userFeed = [[UserFeed alloc] initWithUserId:Id];
    [userFeed getFeed:^{
        for (SubscribeModel *subscriber in userFeed.feed) {
            [subscriber storeSubscriberLocal];
        }
    } onError:^(NSError *error){
    
    }];
}

-(void)storeBucketId:(BucketModel *) bucket{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:bucket.Id] forKey:@"user-bucket-id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    NSLog(@"My dic is %@", body);
    return body;
}

-(void)storeCredentials:(NSMutableDictionary *) dic
{
    [authHelper storeCredentials:dic];
}
@end
