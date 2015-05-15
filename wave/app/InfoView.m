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
UIButton *infoButton;
NSLayoutConstraint *infoButtonConstraint;
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
    
    //UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragInfoView:)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDowns:)];
    swipe.delegate = self;
    [swipe setDirection:(UISwipeGestureRecognizerDirectionDown)];
    swipe.cancelsTouchesInView = NO;
    swipe.numberOfTouchesRequired = 1;

    // pan.delegate = self;
    [self addGestureRecognizer:swipe];
    return self;
}

-(void)tapButton{

}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return  YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}

-(void)show:(UIButton *) infoButtonLocal withConstraint:(NSLayoutConstraint *) constraint{
    infoButton = infoButtonLocal;
    infoButtonConstraint = constraint;
    CGRect frame = self.frame;
    frame.origin.y = [UIHelper getScreenHeight] - height;
    
    self.viewHidden = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frame = frame;
                         constraint.constant = 115;
                         [infoButton layoutIfNeeded];
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
                         infoButtonConstraint.constant = 15;
                         [infoButton layoutIfNeeded];
                     }
                     completion:nil];

    self.viewHidden = YES;
}

-(void)swipeDowns:(UISwipeGestureRecognizer *)sender {
    NSLog(@"swiping");
    [self hide];
}

-(void)dragInfoView:(UIPanGestureRecognizer *)gesture{

    
   
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    CGRect frame = self.frame;
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        
    }
    
    NSLog(@"%d", frame.origin.y <= -44 - translation.y);
    
    
        self.frame = CGRectMake(0, self.frame.origin.y + (translation.y*1.4), [UIHelper getScreenWidth], self.frame.size.height);
        
    
    
    
    if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
      
        
    }
    [gesture setTranslation:CGPointZero inView:label];
    
    

}

@end
