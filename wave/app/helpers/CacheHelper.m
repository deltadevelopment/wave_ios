//
//  CacheHelper.m
//  wave
//
//  Created by Simen Lie on 22.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CacheHelper.h"
#import "CacheModel.h"
@implementation CacheHelper


-(id)init{
    self = [super init];
    
    return self;
}

-(NSArray *)getCacheMap{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myDecodedObject = [defaults objectForKey: [NSString stringWithFormat:@"cacheMap"]];
    
    NSArray *decodedArray = nil;
    @try {
        decodedArray =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", [exception name]);
        
    }
    @finally {
        NSLog(@"trying");
    }
    
    return decodedArray;
}

-(void)storeInCashMap:(NSString *) key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *cacheMap = [self getCacheMap];
    NSMutableArray *array;
    if (cacheMap == nil) {
        array = [[NSMutableArray alloc] init];
    }
    else{
        array = [[NSMutableArray alloc] initWithArray:cacheMap];
    }
    
    CacheModel *cacheModel = [self createCacheForKey:key];
    
    [array addObject:cacheModel];
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:array];
    [defaults setObject:myEncodedObject forKey:[NSString stringWithFormat:@"cacheMap"]];
}


-(void)cleanUpCashMap{
    NSArray *cacheMap = [self getCacheMap];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    NSDate *currentTime = [self getCurrentTime];
    
    if (cacheMap != nil) {
        for (CacheModel *cacheModel in cacheMap) {
            NSLog(@"THE KEY is %@", cacheModel.key);
            NSLog(@"expire %@", cacheModel.expirationDate);
            if ([cacheModel.expirationDate compare:currentTime] == NSOrderedAscending) {
                //Remove from the list
                NSLog(@"Should remove");
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheModel.key];
            }else{
                [newArray addObject:cacheModel];
            }
        }
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:newArray];
        [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:[NSString stringWithFormat:@"cacheMap"]];
    }
}

-(CacheModel *)createCacheForKey:(NSString *) key{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    return [[CacheModel alloc] initWithKey:key withDate:currentTime];
}

-(NSDate *)getCurrentTime{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    return [dateFormatter dateFromString:resultString];
}



@end
