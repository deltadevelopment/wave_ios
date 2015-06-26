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
@property (nonatomic, strong) NSString  *when;
@property (nonatomic, strong) NSString  *message;
@end
