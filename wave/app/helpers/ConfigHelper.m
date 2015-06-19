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
            _baseUrl = @"http://ddev-wave-staging.herokuapp.com";
        }
        NSLog(@"baseURL: %@", _baseUrl);
    }
    
    return self;
}
@end
