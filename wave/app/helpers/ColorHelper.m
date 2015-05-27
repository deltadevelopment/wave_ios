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
static UIColor *whiteColor;
static UIColor *blueColor;
static UIColor *darkBlueColor;
static UIColor *magenta;
+(void)initialize{
    purpleColor = [UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1];
    greenColor = [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1];
    redColor = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1];
    whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    blueColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1];
    darkBlueColor = [UIColor colorWithRed:0.204 green:0.286 blue:0.369 alpha:1];
    magenta = [UIColor colorWithRed:0.051 green:0.875 blue:0.843 alpha:1];
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
+(UIColor*)whiteColor{
    return whiteColor;
}
+(UIColor*)blueColor{
    return blueColor;
}

+(UIColor*)darkBlueColor{
    return darkBlueColor;
}
+(UIColor *)magenta{
    return magenta;
}
@end
