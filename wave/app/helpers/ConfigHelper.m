//
//  ConfigHelper.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ConfigHelper.h"

@implementation ConfigHelper
- (id)init
{
    self = [super init];
    if (self) {
       //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentServer"];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"currentServer"] != nil) {
            NSString *storedBaseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentServer"];
            _baseUrl = storedBaseUrl;
            
        }else{
            //_baseUrl = @"http://w4ve.herokuapp.com";
            _baseUrl = @"https://ddev-wave-staging.herokuapp.com";
           // _baseUrl = @"https://ddev-wave-production.herokuapp.com";
        }
       // NSLog(@"baseURL: %@", _baseUrl);
        //Chat config
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"currentChatServer"] != nil) {
            NSString *storedChatUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentChatServer"];
            int storedChatPort = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentChatServerPort"] intValue];
            _chatUrl = storedChatUrl;
            _chatPort = storedChatPort;
            
        }else{
            _chatUrl = @"52.18.5.223";
            _chatPort = 1234;
        }
    }
    
    return self;
}
@end
