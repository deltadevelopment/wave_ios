//
//  SuperModel.h
//  wave
//
//  Created by Simen Lie on 15/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//
#define VariableName(arg) (@""#arg)
#import <Foundation/Foundation.h>
#import "ApplicationController.h"
#import "ParserHelper.h"
#import "ResponseModel.h"
#import "ApplicationHelper.h"
@interface SuperModel : NSObject
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) ApplicationController *applicationController;
@property (nonatomic) bool markedForDelete;
//@property (nonatomic, strong) ResponseModel *responseModel;
-(int)getIntValueFromString:(NSString *) stringValue;
-(NSString *)getStringValueFromString:(NSString *) stringValue;
-(bool)getBoolValueFromString:(NSString *) stringValue;
-(ResponseModel *)responseModelFromData:(NSData *) data;
-(NSDictionary *)asDictionary;
-(NSString *)asJSON:(NSDictionary *) dictionary;
@end
