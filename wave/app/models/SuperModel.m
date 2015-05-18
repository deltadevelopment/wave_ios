//
//  SuperModel.m
//  wave
//
//  Created by Simen Lie on 15/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"

@implementation SuperModel
-(int)getIntValueFromString:(NSString *) stringValue{
    int value;
    if((NSNull*)[self.dictionary objectForKey: stringValue] != [NSNull null]){
        value  = [[self.dictionary objectForKey:stringValue] intValue];
    }else{
        return -1;
    }
    return value;
}

-(NSString *)getStringValueFromString:(NSString *) stringValue{
    NSString *value;
    if((NSNull*)[self.dictionary objectForKey: stringValue] != [NSNull null]){
        value = [self.dictionary objectForKey:stringValue];
    }else{
        return nil;
    }
    return value;
}

-(bool)getBoolValueFromString:(NSString *) stringValue{
    bool value;
    if((NSNull*)[self.dictionary objectForKey: stringValue] != [NSNull null]){
        value = [[self.dictionary objectForKey:stringValue] boolValue];
    }else{
        return nil;
    }
    return value;
}
@end
