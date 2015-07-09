//
//  AuthHelper.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "AuthHelper.h"
#import "SSKeychain.h"
@implementation AuthHelper
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)storeDeviceId:(NSString *) deviceId{
    [SSKeychain setPassword:deviceId forService:@"deviceId" account:@"AnyUser"];
}

- (void) storeCredentials:(NSMutableDictionary *) credentials{
    NSString *userIdInt = credentials[@"user_id"];
    NSString *userId = [NSString stringWithFormat: @"%@", userIdInt];
    NSString *authToken = credentials[@"auth_token"];
    [SSKeychain setPassword:userId forService:@"userId" account:@"AnyUser"];
    [SSKeychain setPassword:authToken forService:@"authToken" account:@"AnyUser"];
};

-(void) resetCredentials{
    [SSKeychain deletePasswordForService:@"userId" account:@"AnyUser"];
    [SSKeychain deletePasswordForService:@"authToken" account:@"AnyUser"];
}

-(void) storeCredentialsDebug:(NSString *) username withPassword:(NSString *) password{
    [SSKeychain setPassword:username forService:@"usernameDebug" account:@"AnyUser"];
    [SSKeychain setPassword:password forService:@"passwordDebug" account:@"AnyUser"];
};

-(NSString *)getUsernameDebug{
    NSString *authToken = [SSKeychain passwordForService:@"usernameDebug" account:@"AnyUser"];
    return authToken;
}

-(NSString *)getPasswordDebug{
    NSString *authToken = [SSKeychain passwordForService:@"passwordDebug" account:@"AnyUser"];
    return authToken;
}


- (NSString*) getAuthToken{
    NSString *authToken = [SSKeychain passwordForService:@"authToken" account:@"AnyUser"];
    return authToken;
};
- (NSString *) getUserId{
    NSString *userId = [SSKeychain passwordForService:@"userId" account:@"AnyUser"];
    return userId;
};

-(NSString *)getDeviceId{
    return [SSKeychain passwordForService:@"deviceId" account:@"AnyUser"];
}
@end
