//
//  UserModel.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "UserModel.h"
#import "AuthHelper.h"
@implementation UserModel{
    AuthHelper *authHelper;
}
-(id)init:(NSMutableDictionary *)dic{
    [self refresh:dic];
    return self;
};

-(id)initWithDeviceUser{
    self = [super init];
    authHelper = [[AuthHelper alloc] init];
    self.Id = [[authHelper getUserId] intValue];
    [self find:^{} onError:^(NSError *error){}];
    return self;
}

-(void)refresh:(NSMutableDictionary *)dic{
    self.dictionary = dic;
    _username  = [dic objectForKey:@"username"];
    _email  = [dic objectForKey:@"email"];
    if((NSNull*)[dic objectForKey: @"phone_number"] != [NSNull null]){
        _phone_number  = [[dic objectForKey:@"phone_number"] intValue];
    }
    _display_name  = [self getStringValueFromString:@"display_name"];
    _availability  = [[dic objectForKey:@"availability"] intValue];
    _created_at  = [dic objectForKey:@"created_at"];
    _updated_at  = [dic objectForKey:@"updated_at"];
    _password_hash  = [dic objectForKey:@"password_hash"];
    _password_salt  = [dic objectForKey:@"password_salt"];
    _private_profile  = [[dic objectForKey:@"private_profile"] boolValue];
    _Id  = [[dic objectForKey:@"id"] intValue];
    _subscribers_count = [self getIntValueFromString:@"subscribers_count"];
    // NSLog(@"Subscribers count = %d", [[dic objectForKey:@"subscribers_count"] intValue]);
    if((NSNull*)[dic objectForKey:@"is_followee"] != [NSNull null]){
        _is_followee = [[dic objectForKey:@"is_followee"] boolValue];
    }
    _usernameFormatted =[NSString stringWithFormat:@"@%@", _username];
}

-(void)find:(void (^)(void))completionCallback
    onError:(void(^)(NSError *))errorCallback{
    __weak typeof(self) weakSelf = self;
    [self.applicationController getHttpRequest:[NSString stringWithFormat:@"user/%d", self.Id]
                                  onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                      ResponseModel *responseModel = [self responseModelFromData:data];
                                      [weakSelf refresh:[[responseModel data] objectForKey:@"user"]];
                                      NSLog(@"NOT NULL NOW?");
                                      completionCallback();
                                  } onError:errorCallback];
}
@end
