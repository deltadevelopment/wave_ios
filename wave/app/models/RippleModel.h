//
//  RippleModel.h
//  wave
//
//  Created by Simen Lie on 16/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"
#import "BucketModel.h"
#import "DropModel.h"
#import "TemperatureModel.h"
#import "SubscribeModel.h"
#import "UserModel.h"
@interface RippleModel : SuperModel
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *trigger_type;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic) int trigger_id;
@property (nonatomic) int triggee_id;
@property (nonatomic, strong) DropModel *drop;
@property (nonatomic, strong) BucketModel *bucket;
@property (nonatomic, strong) TemperatureModel *temperature;
@property (nonatomic, strong) SubscribeModel *subscription;
@property (nonatomic, strong) UserModel *user;





//Old values for push notification
@property (nonatomic) int Id;
@property (nonatomic) int bucket_id;
@property (nonatomic) int drop_id;
-(id)init:(NSMutableDictionary *)dic;
-(id)initFromPushNotification:(NSMutableDictionary *)dic;
-(NSArray *)getComputedString;

@end
