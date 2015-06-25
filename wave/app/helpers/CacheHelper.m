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
/*
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
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
*/

+(NSDate *) expirationDate:(NSDate *) date{
    NSTimeInterval secondsInEightHours = 25 * 60 * 60;
    NSDate *expirationTime = [date dateByAddingTimeInterval:secondsInEightHours];
    return expirationTime;
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

+(NSDate *)getTimeWithFormatForDate:(NSDate *) date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    NSString *resultString = [dateFormatter stringFromDate: date];
    return [dateFormatter dateFromString:resultString];
}

+(NSString *)dateToString:(NSDate *) date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
    return [dateFormatter stringFromDate:date];
}


#pragma UserDefaults
+(void)storeFilenameWithDate:(NSString *) key{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self StoreToArray:key];
    //Kan sla opp pa filnavnet og fa datoen.
}

+(void)StoreToArray:(NSString *) filePath{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSMutableArray *users = [NSMutableArray arrayWithArray:[userData objectForKey:@"filepaths"]];
    [users addObject:filePath];
    [userData setObject:[NSArray arrayWithArray:users] forKey:@"filepaths"];
}

+(void)cleanUpCashMap{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSMutableArray *filePaths = [NSMutableArray arrayWithArray:[userData objectForKey:@"filepaths"]];
    NSMutableArray *filePathsNew = [[NSMutableArray alloc] init];
    for (NSString *filePath in filePaths) {
        NSDate *date = [userData objectForKey:filePath];
        NSDate *expire = [self expirationDate:[self getTimeWithFormatForDate:date]];
        NSLog(@"Date expires %@ date now %@", [self dateToString:expire], [self dateToString:[self getCurrentTime]]);
        if ([expire compare:[self getCurrentTime]] == NSOrderedAscending) {
            //Remove from the list
            //NSLog(@"Should remove");
            // [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheModel.key];
            [self removeFileWithFilePath:filePath];
            [userData removeObjectForKey:filePath];
            //File is removed
           // NSLog(@"Removed file with key %@", filePath);
            
        }else{
            [filePathsNew addObject:filePath];
        }
    }
    [userData setObject:[NSArray arrayWithArray:filePathsNew] forKey:@"filepaths"];
}

+(void)printCashMap{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSMutableArray *filePaths = [NSMutableArray arrayWithArray:[userData objectForKey:@"filepaths"]];
    NSLog(@"---------");
    NSLog(@"CacheMap");
    NSLog(@"Size of CacheMap %lu", (unsigned long)[filePaths count]);
    NSLog(@"---------");
    
}

+(void)removeFileWithFilePath:(NSString *) filePath{
   // NSLog(@"Trying to remove file at path %@", filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePathFull = [documentsPath stringByAppendingPathComponent:filePath];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePathFull error:&error];
    if (success) {
        NSLog(@"removed file");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

@end
