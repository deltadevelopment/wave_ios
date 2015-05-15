//
//  SuperModel.h
//  wave
//
//  Created by Simen Lie on 15/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuperModel : NSObject
@property (nonatomic, strong) NSMutableDictionary *dictionary;
-(int)getIntValueFromString:(NSString *) stringValue;
-(NSString *)getStringValueFromString:(NSString *) stringValue;
-(bool)getBoolValueFromString:(NSString *) stringValue;
@end
