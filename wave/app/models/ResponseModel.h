//
//  ErrorModel.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseModel : NSObject
@property (nonatomic) BOOL success;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *message_id;
@property (nonatomic,strong) NSDictionary *error;
-(id)init:(NSMutableDictionary *)dic;
@end
