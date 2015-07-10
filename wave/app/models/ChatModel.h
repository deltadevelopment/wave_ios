//
//  ChatModel.h
//  wave
//
//  Created by Simen Lie on 26.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"

@interface ChatModel : SuperModel
@property (nonatomic, strong) NSString  *uuid;
@property (nonatomic) int sender;
@property (nonatomic) int bucket;
@property (nonatomic, strong) NSString  *when;
@property (nonatomic, strong) NSString  *message;
-(id)init:(NSMutableDictionary *)dic;


//Client
@property (nonatomic) bool empty;

@end
