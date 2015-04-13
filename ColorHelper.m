//
//  ColorHelper.m
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ColorHelper.h"


@implementation ColorHelper
static UIColor *purpleColor;
static UIColor *greenColor;
static UIColor *redColor;
+(void)initialize{
    purpleColor = [UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1];
    greenColor = [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1];
    redColor = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1];
}

+(UIColor*)purpleColor{
    return purpleColor;
}
+(UIColor*)greenColor{
    return greenColor;
}
+(UIColor*)redColor{
    return redColor;
}
@end
