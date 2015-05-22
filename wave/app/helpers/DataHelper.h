//
//  DataHelper.h
//  wave
//
//  Created by Simen Lie on 11/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BucketModel.h"
@interface DataHelper : UIView
@property (nonatomic, strong) NSData *data;

+(void)storeData:(NSData*) recievedData withMediaType:(int) media_ty;

+(NSData *)getData;


+(void)storeBucketId:(int)Id;
+(int)getBucketId;
+(void)setCurrentBucketId:(int)bucketId;
+(int)getCurrentBucketId;
+(int)getMediaType;

@end
