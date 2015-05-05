//
//  DropModel.h
//  wave
//
//  Created by Simen Lie on 05/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DropModel : NSObject
@property (nonatomic,strong) NSDate * created_at;
@property (nonatomic,strong) NSString * media;
@property (nonatomic,strong) NSString * username;
@property (nonatomic) int phone_number;
-(id)initWithTestData:(NSString *) media withName:(NSString *) username;
@end
