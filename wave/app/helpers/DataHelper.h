//
//  DataHelper.h
//  wave
//
//  Created by Simen Lie on 11/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataHelper : UIView
@property (nonatomic, strong) NSData *data;

+(void)storeData:(NSData*) recievedData;

+(NSData *)getData;


+(void)storeBucketId:(int)Id;
+(int)getBucketId;
+(void)setCurrentBucketId:(int)bucketId;
+(int)getCurrentBucketId;
@end
