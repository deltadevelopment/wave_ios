//
//  ApplicationHelper.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigHelper.h"
#import <UIKit/UIKit.h>
@interface ApplicationHelper : NSObject
-(NSString*) generateUrl:(NSString*) relativePath;
+(NSString*) generateJsonFromDictionary:(NSDictionary *) dictionary;
-(void)setIndex:(NSIndexPath *) path;
-(NSIndexPath*)getIndex;
-(NSString*)getAvailableText;
-(NSString*)getUnAvailableText;
-(void)addAvailableTexts;
-(void)addUnAvailableTexts;
//-(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar;
//-(void)alertUser:(NSString *) text;
+(NSMutableArray *)bucketTestData;
+(UINavigationController *)getMainNavigationController;
+(void)setMainNavigationController:(UINavigationController *) naivgationController;
+(void)setBlock:(void (^)())completionCallback;
+(void)executeBlock;
+(int)userBucketId;
@end
