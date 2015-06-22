//
//  CacheModel.h
//  wave
//
//  Created by Simen Lie on 22.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"

@interface CacheModel : SuperModel<NSCoding>
@property (nonatomic, strong) NSDate *timeStored;
@property (nonatomic, strong) NSString *key;
-(id)initWithKey:(NSString *) key withDate:(NSDate *) time;

-(NSDate *) expirationDate;
@end
