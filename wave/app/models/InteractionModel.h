//
//  InteractionModel.h
//  wave
//
//  Created by Simen Lie on 22.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"
#import "BucketModel.h"
#import "DropModel.h"
#import "TemperatureModel.h"
#import "SubscribeModel.h"
#import "UserModel.h"
@interface InteractionModel : SuperModel
@property(nonatomic) int Id;
@property(nonatomic) int topic_id;
@property(nonatomic, strong) NSString * topic_type;
@property(nonatomic) int user_id;
@property(nonatomic, strong) NSString *action;
-(id)init:(NSMutableDictionary *)dic;

@property (nonatomic, strong) DropModel *drop;
@property (nonatomic, strong) BucketModel *bucket;
@property (nonatomic, strong) TemperatureModel *temperature;
@property (nonatomic, strong) SubscribeModel *subscription;
@property (nonatomic, strong) UserModel *user;

-(UserModel *)GetCurrentUser;




@end
