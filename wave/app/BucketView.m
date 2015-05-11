//
//  BucketView.m
//  wave
//
//  Created by Simen Lie on 11.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "BucketView.h"

@implementation BucketView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
 
    // If the hitView is THIS view, return the view that you want to receive the touch instead:
    if(self.lockArea){
           NSLog(@"HER_______");
        return self.dropView;
    }
    if (hitView == self) {
        return hitView;
    }
    // Else return the hitView (as it could be one of this view's buttons):
    return hitView;
}

@end
