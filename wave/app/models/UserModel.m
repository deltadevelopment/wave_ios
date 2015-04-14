//
//  UserModel.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(id)init:(NSMutableDictionary *)dic{
    _username  = [dic objectForKey:@"username"];
    _email  = [dic objectForKey:@"email"];
    if((NSNull*)[dic objectForKey: @"phone_number"] != [NSNull null]){
        _phone_number  = [[dic objectForKey:@"phone_number"] intValue];
    }
    
    _display_name  = [dic objectForKey:@"display_name"];
    _availability  = [[dic objectForKey:@"availability"] intValue];
    _created_at  = [dic objectForKey:@"created_at"];
    _updated_at  = [dic objectForKey:@"updated_at"];
    _password_hash  = [dic objectForKey:@"password_hash"];
    _password_salt  = [dic objectForKey:@"password_salt"];
    _private_profile  = [[dic objectForKey:@"private_profile"] boolValue];
    _Id  = [[dic objectForKey:@"id"] intValue];
    if((NSNull*)[dic objectForKey:@"is_followee"] != [NSNull null]){
        _is_followee = [[dic objectForKey:@"is_followee"] boolValue];
    }
    //User
   // NSLog(@"The username is %@", _username);
    return self;
};
@end
