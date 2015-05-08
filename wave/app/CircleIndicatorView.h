//
//  CircleIndicatorView.h
//  wave
//
//  Created by Simen Lie on 08/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleIndicatorView : UIView{
    CGFloat startAngle;
    CGFloat endAngle;
}
@property (nonatomic) float percent;
-(void)setIndicatorWithMaxTime:(float) time;
-(void)incrementSpin;

@end
