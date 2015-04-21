//
//  PartialTransparentView.h
//  wave
//
//  Created by Simen Lie on 21/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartialTransparentView : UIView
- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)color andTransparentRects:(NSArray*)rects;

@end
