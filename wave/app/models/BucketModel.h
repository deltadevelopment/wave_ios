//
//  BucketModel.h
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropModel.h"
@interface BucketModel : NSObject
-(id)init:(NSMutableDictionary *)dic;
@property (nonatomic) int Id;
@property (nonatomic) int bucket_type;
@property (nonatomic) int temperature;
@property (nonatomic) int visibility;
@property (nonatomic) BOOL locked;
@property (nonatomic) int user_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *bucket_description;
@property (nonatomic,strong) NSDate *when_datetime;
@property (nonatomic,strong) NSDate *created_at;
@property (nonatomic,strong) NSDate *updated_at;

//Client properties
@property (nonatomic,strong) DropModel *rootDrop;
@property (nonatomic,strong) NSMutableArray *drops;

@end
