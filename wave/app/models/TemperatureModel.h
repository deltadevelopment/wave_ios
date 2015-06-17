//
//  TemperatureModel.h
//  wave
//
//  Created by Simen Lie on 06.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"

@interface TemperatureModel : SuperModel
@property (nonatomic) int temperature;
@property (nonatomic) int Id;
@property (nonatomic) int user_id;
@property (nonatomic) int drop_id;
@property (nonatomic) int bucket_id;

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;
-(id)init:(NSMutableDictionary *)dic;

-(id)initWithDrop:(int)drop_id;
-(void)saveChanges:(void (^)(ResponseModel *, TemperatureModel *))completionCallback
           onError:(void (^)(NSError *))errorCallback;
@end
