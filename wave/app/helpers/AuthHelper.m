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
    NSLog(@"the devi id is: %@", deviceId);
    [SSKeychain setPassword:deviceId forService:@"deviceId" account:@"AnyUser"];
}

- (void) storeCredentials:(NSMutableDictionary *) credentials{
    NSString *userIdInt = credentials[@"user_id"];
    NSString *userId = [NSString stringWithFormat: @"%@", userIdInt];
    NSString *authToken = credentials[@"auth_token"];
    NSLog(@"storing credentials");
    [SSKeychain setPassword:userId forService:@"userId" account:@"AnyUser"];
    [SSKeychain setPassword:authToken forService:@"authToken" account:@"AnyUser"];
    NSLog(@"crdentials stored");
    NSLog(@"userID: %@", userId);
    NSLog(@"authToken: %@", authToken);
};

-(void) resetCredentials{
    [SSKeychain deletePasswordForService:@"userId" account:@"AnyUser"];
    [SSKeychain deletePasswordForService:@"authToken" account:@"AnyUser"];
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
