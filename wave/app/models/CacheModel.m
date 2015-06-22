//
//  CacheModel.m
//  wave
//
//  Created by Simen Lie on 22.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CacheModel.h"

@implementation CacheModel
-(id)initWithKey:(NSString *) key withDate:(NSDate *) time{
    self.key = key;
    self.timeStored = time;
    self =[super init];
    return self;
}


-(NSDate *) expirationDate{
    NSTimeInterval secondsInEightHours = 25 * 60 * 60;
    NSDate *expirationTime = [self.timeStored dateByAddingTimeInterval:secondsInEightHours];
    return expirationTime;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.key forKey:@"cache_key"];
    [aCoder encodeObject:self.timeStored forKey:@"cache_time"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.key = [aDecoder decodeObjectForKey:@"cache_key"];
        self.timeStored = [aDecoder decodeObjectForKey:@"cache_time"];
    }
    return self;
}
@end
