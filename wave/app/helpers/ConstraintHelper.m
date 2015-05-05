//
//  ConstraintHelper.m
//  wave
//
//  Created by Simen Lie on 05/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ConstraintHelper.h"

@implementation ConstraintHelper

+(void)leftConstraint:(UIView *)parentView withChild:(UIView *) childView withConstant:(float) constant
{
    [self genericConstraint:NSLayoutAttributeLeading withParent:parentView withChild:childView withConstant:constant];
}
+(void)rightConstraint:(UIView *)parentView withChild:(UIView *) childView withConstant:(float) constant
{
    [self genericConstraint:NSLayoutAttributeTrailing withParent:parentView withChild:childView withConstant:constant];
}

+(void)TopConstraint:(UIView *)parentView withChild:(UIView *) childView withConstant:(float) constant
{
    [self genericConstraint:NSLayoutAttributeTop withParent:parentView withChild:childView withConstant:constant];
}

+(void)BottomConstraint:(UIView *)parentView withChild:(UIView *) childView withConstant:(float) constant
{
    [self genericConstraint:NSLayoutAttributeBottom withParent:parentView withChild:childView withConstant:constant];
}

+(void)genericConstraint:(NSLayoutAttribute) attribute withParent:(UIView *)parentView withChild:(UIView *) childView withConstant:(float) constant{
    [parentView addConstraint:[NSLayoutConstraint constraintWithItem:parentView
                                                           attribute:attribute
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:childView
                                                           attribute:attribute
                                                          multiplier:1.0
                                                            constant:constant]];
}


@end
