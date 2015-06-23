//
//  CacheHelper.m
//  wave
//
//  Created by Simen Lie on 22.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CacheHelper.h"
#import "CacheModel.h"
static NSMutableArray *localCacheMap;
@implementation CacheHelper


-(id)init{
    self = [super init];
    
    return self;
}

+(NSMutableArray *)getCacheMap{
    if (localCacheMap == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *myDecodedObject = [defaults objectForKey: [NSString stringWithFormat:@"cacheMap"]];
        @try {
            localCacheMap = [[NSMutableArray alloc] initWithArray:[[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject] mutableCopy]];
        }
        @catch (NSException *exception) {
            NSLog(@"Error: %@", [exception name]);
            
        }
        @finally {
            NSLog(@"trying");
        }
        
        return localCacheMap;
    }
    return localCacheMap;
    
}

+(void)storeInCashMap:(NSString *) key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self getCacheMap];
    if (localCacheMap == nil) {
        localCacheMap = [[NSMutableArray alloc] init];
    }
    
    CacheModel *cacheModel = [self createCacheForKey:key];
    
    [localCacheMap addObject:cacheModel];
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:localCacheMap];
    [defaults setObject:myEncodedObject forKey:[NSString stringWithFormat:@"cacheMap"]];
    [defaults synchronize];
}


+(void)cleanUpCashMap{
    NSArray *cacheMap = [self getCacheMap];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    NSDate *currentTime = [self getCurrentTime];
    
    if (cacheMap != nil) {
        NSLog(@"Cache Size %lu", (unsigned long)cacheMap.count);
        NSLog(@"--------------------------");
        for (CacheModel *cacheModel in cacheMap) {
            //NSLog(@"expire %@", cacheModel.expirationDate);
            if ([cacheModel.expirationDate compare:currentTime] == NSOrderedAscending) {
                //Remove from the list
                //NSLog(@"Should remove");
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheModel.key];
            }else{
                [newArray addObject:cacheModel];
            }
        }
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:newArray];
        [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:[NSString stringWithFormat:@"cacheMap"]];
    }
}

+(CacheModel *)createCacheForKey:(NSString *) key{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    //NSString *resultString = [dateFormatter stringFromDate: currentTime];
    return [[CacheModel alloc] initWithKey:key withDate:currentTime];
}

+(NSDate *)getCurrentTime{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    return [dateFormatter dateFromString:resultString];
}



@end
