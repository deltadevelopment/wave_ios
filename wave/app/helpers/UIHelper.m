//
//  UIHelper.m
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "UIHelper.h"
#import "ColorHelper.h"
static CGRect screenBound;
static CGSize screenSize;
static CGFloat screenWidth;
static CGFloat screenHeight;
@implementation UIHelper

+(void)initialize{
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
}

+(CGFloat)getScreenWidth
{
    return screenWidth;
}

+(CGFloat)getScreenHeight
{
    return screenHeight;
}

+(void)applyLayoutOnButton:(UIButton *) button{
    [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    [[button titleLabel] setTextColor:[ColorHelper whiteColor]];
}

@end
