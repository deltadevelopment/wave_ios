//
//  ChatFeed.h
//  wave
//
//  Created by Simen Lie on 26.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"

@interface ChatFeed : SuperModel<NSStreamDelegate>
@property (nonatomic, strong) NSMutableArray *messages;
@end
