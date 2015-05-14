//
//  InfoView.m
//  wave
//
//  Created by Simen Lie on 14/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "InfoView.h"
#import "UIHelper.h"
@implementation InfoView
float height;
@synthesize button;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)init{
    height = [UIHelper getScreenHeight]/4;
    CGRect frame = CGRectMake(0, [UIHelper getScreenHeight], [UIHelper getScreenWidth], height);
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self = [super initWithEffect:blurEffect];
    self.frame = frame;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20,20, 70, 70);
    [UIHelper applyUIOnButton:button];
    [button setImage:[UIHelper iconImage:[UIImage imageNamed:@"people-icon-white.png"] withSize:150] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
   // self.backgroundColor = [UIColor whiteColor];
    self.viewHidden = YES;
    return self;
}

-(void)tapButton{

}



-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}

-(void)show{
    NSLog(@"showing");
    CGRect frame = self.frame;
    frame.origin.y = [UIHelper getScreenHeight] - height;
   
    self.viewHidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                      self.frame = frame;
                     }
                     completion:nil];
}

-(void)hide{
    CGRect frame = self.frame;
    frame.origin.y = [UIHelper getScreenHeight];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frame = frame;
                     }
                     completion:nil];
    self.viewHidden = YES;
}

@end
