//
//  InfoView.m
//  wave
//
//  Created by Simen Lie on 14/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "InfoView.h"
#import "UIHelper.h"
#import "BucketViewController.h"
#import "ScrollController.h"
@implementation InfoView
float height;
@synthesize button;
UIButton *infoButton;
NSLayoutConstraint *infoButtonConstraint;
ScrollController *bucketViewController;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithSuperViewController:(ScrollController *) superViewController
                      withButton:(UIButton *)infoButtonLocal
                  withConstraint:(NSLayoutConstraint *) constraint
{
    bucketViewController = superViewController;
    infoButtonConstraint = constraint;
    infoButton = infoButtonLocal;
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
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
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

-(void)show{
    CGRect frame = self.frame;
    frame.origin.y = [UIHelper getScreenHeight] - height;
    
    self.viewHidden = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frame = frame;
                         infoButtonConstraint.constant = 115;
                         [infoButton layoutIfNeeded];
                     }
                     completion:nil];
    [bucketViewController setInfoViewMode:NO];
    [bucketViewController setInfoViewMode:YES];
    [infoButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"arrow-down-icon.png"] withSize:150] forState:UIControlStateNormal];
}

-(void)hide{
    [infoButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"arrow-up-icon.png"] withSize:150] forState:UIControlStateNormal];
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
                     completion:^(BOOL finished){
                         [bucketViewController setInfoViewMode:NO];
                         
                     }];
    
    
    self.viewHidden = YES;
}

-(void)swipeDown:(UISwipeGestureRecognizer *)sender {
    [self hide];
}

-(void)dragInfoView:(UIPanGestureRecognizer *)gesture{
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    CGRect frame = self.frame;
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        
    }
    self.frame = CGRectMake(0, self.frame.origin.y + (translation.y*1.4), [UIHelper getScreenWidth], self.frame.size.height);
    
    if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        
    }
    [gesture setTranslation:CGPointZero inView:label];
}

@end
