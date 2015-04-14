//
//  ErrorModel.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ResponseModel.h"

@implementation ResponseModel
-(id)init:(NSMutableDictionary *)dic{
    _success = [[dic objectForKey:@"success"] boolValue];
    _message = [dic objectForKey:@"message"];
    _message_id = [dic objectForKey:@"message_id"];
    _error = [[dic objectForKey:@"data"] objectForKey:@"error"];
    return self;
};

-(void)translate{

}

@end