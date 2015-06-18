//
//  PartialTransparentBlurView.m
//  wave
//
//  Created by Simen Lie on 18.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "PartialTransparentBlurView.h"

@implementation PartialTransparentBlurView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor redColor] setFill];
    UIRectFill(rect);
    
    // clear the background in the given rectangles
    
    CGRect holeRect = CGRectMake(200, 200, 100, 100);
        CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
        [[UIColor clearColor] setFill];
        UIRectFill(holeRectIntersection);
    
}





-(void)drawTimeLine:(CGRect) rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    UIColor *theFillColor = [UIColor redColor];
    CGContextSetFillColorWithColor(context, theFillColor.CGColor);
    
    CGRect rectangle = CGRectMake(17,30,340,30);
    CGContextBeginPath(context);
    
    CGContextAddEllipseInRect(context, rectangle);
    UIImage *img = [UIImage imageNamed:@"the-bar-x-v2.png"];
    CGImageRef maskImage = [img CGImage];
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rectangle, maskImage);
    CGContextClearRect(context,rectangle);
    
    UIGraphicsGetImageFromCurrentImageContext();
}

@end
