//
//  PartialTransparentView.m
//  wave
//
//  Created by Simen Lie on 21/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "PartialTransparentView.h"
#import "UIHelper.h"
@implementation PartialTransparentView{
    UIColor *backgroundColor;
    NSArray *rectsArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)color andTransparentRects:(NSArray*)rects
{
    backgroundColor = color;
    rectsArray = rects;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
     NSLog(@"did normal init");
    self.opaque = NO;
    [self setBackgroundColor:[UIColor clearColor]];
    backgroundColor = [UIColor colorWithRed:0.051 green:0.875 blue:0.843 alpha:0.9];
    rectsArray = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(50, 50, 30, 30)],
                  [NSValue valueWithCGRect:CGRectMake(100, 150, 30, 30)],
                  nil];
    return self;
}


- (void)drawRect:(CGRect)rect
{
 
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    UIColor *theFillColor = [UIColor redColor];
    CGContextSetFillColorWithColor(context, theFillColor.CGColor);
    
    CGRect rectangle = CGRectMake(([UIHelper getScreenWidth]/2) - 125,([UIHelper getScreenHeight]/2) - 125 - 30,250,250);
    CGContextBeginPath(context);

    CGContextAddEllipseInRect(context, rectangle);
    UIImage *img = [UIImage imageNamed:@"bucket.png"];
    CGImageRef maskImage = [img CGImage];
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rectangle, maskImage);
    CGContextClearRect(context,rectangle);

   UIGraphicsGetImageFromCurrentImageContext();
     */
    [self drawTimeLine:rect];
    
}

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};




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
