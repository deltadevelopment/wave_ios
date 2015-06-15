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

+(NSLayoutConstraint *)addConstraintsToButton:(UIView *)view withButton:(UIButton *) button withPoint:(CGPoint) xy fromLeft:(bool) left fromTop:(bool) top{
    button.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *bottom;
    if(left)
    {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeadingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:xy.x]];
        
    }else{
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:xy.x]];
    }
    
    if(top){
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTopMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:xy.y]];
    }
    
    else{
       bottom = [NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeBottomMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:button
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:xy.y];
        [view addConstraint:bottom];
    }
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
    return bottom;
}

+(NSLayoutConstraint *)addConstraintsToButtonWithNoSize:(UIView *)view withButton:(UIButton *) button withPoint:(CGPoint) xy fromLeft:(bool) left fromTop:(bool) top{
    button.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *bottom;
    if(left)
    {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeadingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:xy.x]];
        
    }else{
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:xy.x]];
    }
    
    if(top){
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTopMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:xy.y]];
    }
    
    else{
        bottom = [NSLayoutConstraint constraintWithItem:view
                                              attribute:NSLayoutAttributeBottomMargin
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:button
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                               constant:xy.y];
        [view addConstraint:bottom];
    }
    return bottom;
}

@end
