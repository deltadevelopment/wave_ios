//
//  CacheHelper.h
//  wave
//
//  Created by Simen Lie on 22.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheHelper : NSObject

-(void)storeInCashMap:(NSString *) key;
-(void)cleanUpCashMap;

@end
