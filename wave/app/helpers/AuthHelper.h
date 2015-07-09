//
//  AuthHelper.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthHelper : NSObject
- (void) storeCredentials:(NSMutableDictionary *) credentials;
- (void) resetCredentials;
- (NSString*) getAuthToken;
- (NSString *) getUserId;
- (NSString *)getDeviceId;
- (void)storeDeviceId:(NSString *) deviceId;

-(void) storeCredentialsDebug:(NSString *) username withPassword:(NSString *) password;
-(NSString *)getUsernameDebug;
-(NSString *)getPasswordDebug;
@end
