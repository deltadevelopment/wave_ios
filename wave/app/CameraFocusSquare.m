//
//  CameraFocusSquare.m
//  wave
//
//  Created by Simen Lie on 25.07.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CameraFocusSquare.h"
#import "ColorHelper.h"
const float squareLength = 80.0f;
@implementation CameraFocusSquare

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setBorderWidth:2.0];
      //  [self.layer setCornerRadius:4.0];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self animate];
    }
    return self;
}

-(void)animate{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = self.frame;
                         frame.size = CGSizeMake(60, 60);
                         frame.origin = CGPointMake(frame.origin.x + 15, frame.origin.y + 15);
                         self.frame = frame;
                     }
                     completion:^(BOOL finished){
                         CABasicAnimation* selectionAnimation = [CABasicAnimation
                                                                 animationWithKeyPath:@"borderColor"];
                         selectionAnimation.toValue = (id)[ColorHelper darkPurpleColor].CGColor;
                         selectionAnimation.repeatCount = 8;
                         [self.layer addAnimation:selectionAnimation
                                           forKey:@"selectionAnimation"];
                     }];
}

@end
