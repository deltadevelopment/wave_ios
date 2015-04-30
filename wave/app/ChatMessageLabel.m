//
//  ChatMessageLabel.m
//  wave
//
//  Created by Simen Lie on 29.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ChatMessageLabel.h"

@implementation ChatMessageLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {10, 10, 10, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
