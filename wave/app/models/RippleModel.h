//
//  RippleModel.h
//  wave
//
//  Created by Simen Lie on 16/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"

@interface RippleModel : SuperModel
@property (nonatomic) int Id;
@property (nonatomic) int bucket_id;
@property (nonatomic) int drop_id;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *date_recieved;
-(id)init:(NSMutableDictionary *)dic;


@end
