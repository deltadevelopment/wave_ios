//
//  BucketTypeModel.m
//  wave
//
//  Created by Simen Lie on 26.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "BucketTypeModel.h"

@implementation BucketTypeModel

-(id)initWithProperties:(int) Id withDescription:(NSString *) description withIconPath:(NSString *) iconPath{
    self = [super init];
    self.Id = Id;
    self.type_description = description;
    self.icon_path = iconPath;
    return self;
}

@end
