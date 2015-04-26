//
//  BucketTypeModel.h
//  wave
//
//  Created by Simen Lie on 26.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BucketTypeModel : NSObject
@property (nonatomic) int Id;
@property (nonatomic,strong) NSString *type_description;
@property (nonatomic,strong) NSString *icon_path;
-(id)initWithProperties:(int) Id withDescription:(NSString *) description withIconPath:(NSString *) iconPath;

@end
