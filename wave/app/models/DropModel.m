//
//  DropModel.m
//  wave
//
//  Created by Simen Lie on 05/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DropModel.h"

@implementation DropModel
-(id)init:(NSMutableDictionary *)dic{
    _media  = [dic objectForKey:@"media"];
    /*
    if((NSNull*)[dic objectForKey: @"phone_number"] != [NSNull null]){
        _phone_number  = [[dic objectForKey:@"phone_number"] intValue];
    }
     */
  
    
    return self;
};

-(id)initWithTestData:(NSString *) media withName:(NSString *) username{
    
    _media  = media;
    _username = username;
    /*
     if((NSNull*)[dic objectForKey: @"phone_number"] != [NSNull null]){
     _phone_number  = [[dic objectForKey:@"phone_number"] intValue];
     }
     */
    
    
    return self;
};
@end
