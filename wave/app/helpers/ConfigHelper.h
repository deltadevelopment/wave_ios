//
//  ConfigHelper.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigHelper : NSObject
@property (nonatomic,strong) NSString * baseUrl;
@property (nonatomic,strong) NSString * chatUrl;
@property (nonatomic) int chatPort;
@end
