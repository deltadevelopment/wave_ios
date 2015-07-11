//
//  ChatTableView.m
//  wave
//
//  Created by Simen Lie on 06/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ChatTableView.h"

@implementation ChatTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSObject * transparent = (NSObject *) [[UIColor colorWithWhite:0 alpha:0] CGColor];
        NSObject * opaque = (NSObject *) [[UIColor colorWithWhite:0 alpha:1] CGColor];
        
        CALayer * maskLayer = [CALayer layer];
        maskLayer.frame = self.bounds;
        
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(self.bounds.origin.x, 0,
                                         self.bounds.size.width, self.bounds.size.height);
        gradientLayer.shadowPath = [UIBezierPath bezierPathWithRect:gradientLayer.bounds].CGPath;
        gradientLayer.colors = [NSArray arrayWithObjects: transparent, opaque,
                                opaque, transparent, nil];
        
        // Set percentage of scrollview that fades at top & bottom
        gradientLayer.locations = [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:0],
                                   [NSNumber numberWithFloat:0.00],
                                   [NSNumber numberWithFloat:1.0 - 0.05],
                                   [NSNumber numberWithFloat:1], nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [maskLayer addSublayer:gradientLayer];
            self.layer.mask = maskLayer;
        });
        
    });
    
        
    
    
    
   
}

@end
