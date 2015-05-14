//
//  ConstraintHelper.h
//  wave
//
//  Created by Simen Lie on 05/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ConstraintHelper : NSObject
+(void)leftConstraint:(UIView *)parentView withChild:(UIView *) childView withConstant:(float) constant;

+(void)rightConstraint:(UIView *)parentView withChild:(UIView *) childView withConstant:(float) constant;


+(void)TopConstraint:(UIView *)parentView withChild:(UIView *) childView withConstant:(float) constant;


+(void)BottomConstraint:(UIView *)parentView withChild:(UIView *) childView withConstant:(float) constant;
+(NSLayoutConstraint *)addConstraintsToButton:(UIView *)view withButton:(UIButton *) button withPoint:(CGPoint) xy fromLeft:(bool) left fromTop:(bool) top;

@end
