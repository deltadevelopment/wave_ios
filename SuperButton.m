//
//  SuperButton.m
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperButton.h"
#import <AudioToolbox/AudioToolbox.h>
static int const MIN_POS = 20;
static float const MIN_POS_X = 4.0;
static float const MIN_POS_Y = 20.0;
static int const MAX_POS = 549;
static float MAX_POS_Y = 135;
static float MAX_POS_X = 80;
static int const FUDGE_FACTOR = 10;

@implementation SuperButton
{
    UIButton *button;
    NSLayoutConstraint *buttonXConstraint;
    NSLayoutConstraint *buttonXConstraintMiddle;
    CGFloat buttonXConstraintDefault;
    NSLayoutConstraint *buttonYConstraint;
    CGFloat buttonYConstraintDefault;
    UIView* superView;
    bool dragY;
    bool dragX;
    CGRect screenBound;
    CGSize screenSize;
    CGFloat screenWidth;// = screenSize.width;
    CGFloat screenHeight;// = screenSize.height;
    bool dragXEnabled;
    bool dragYEnabled;
    bool toggleDragDirection;
    bool dragDirection;
    bool xViewIsShowing;
    bool startPosition;
    bool startX;
    bool startY;
    bool startedDrag;
}

-(UIButton *)getButton{
    return button;
}

- (id)init:(UIView *)view
{
    self = [super init];
    if (self) {
        superView = view;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self initUI:superView];
        [self addConstraints:superView];
        screenBound = [[UIScreen mainScreen] bounds];
        screenSize = screenBound.size;
        screenWidth = screenSize.width;
        screenHeight = screenSize.height;
    }
    return self;
}
-(void)changeIcon:(UIImage *)img{
    [button setImage:[UIHelper iconImage:img withSize:100] forState:UIControlStateNormal];
}
-(void)enableDragX{
    dragXEnabled = YES;
}
-(void)enableDragY{
    dragYEnabled = YES;
}

-(void)initUI:(UIView *)view{
    button.layer.cornerRadius = 25;
    [button setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
    button.backgroundColor = [ColorHelper purpleColor];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(buttonDragged:)];
   // gesture.cancelsTouchesInView = NO;
    [button addGestureRecognizer:gesture];
    [button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}


-(void)addConstraints:(UIView *)view{
    button.translatesAutoresizingMaskIntoConstraints = NO;
    buttonXConstraint = [NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailingMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:button
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:MIN_POS_X];

    
    buttonYConstraint = [NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:button
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:MIN_POS_Y];
    
    buttonXConstraintMiddle = [NSLayoutConstraint constraintWithItem:superView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:button
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0
                                                             constant:0.0];
    
    buttonXConstraintDefault = buttonXConstraint.constant;
    buttonYConstraintDefault = buttonYConstraint.constant;
    [view addConstraint:buttonXConstraint];
    [view addConstraint:buttonYConstraint];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(button)]];
}

-(void)tap{
    //animate
    self.onTap();
    [self animateButtonToMiddle];
}

-(void)animateButtonToMiddle{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         if([self superViewHasConstraint])
                         {
                             [superView removeConstraint:buttonXConstraintMiddle];
                             [superView addConstraint:buttonXConstraint];
                         
                         }else{
                             [superView  removeConstraint:buttonXConstraint];
                             [superView  addConstraint:buttonXConstraintMiddle];
                         }
                       
                         
                         [superView  layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                     }];

}

-(bool)superViewHasConstraint{
    for(NSLayoutConstraint *constraint in [superView constraints])
    {
        if(constraint == buttonXConstraintMiddle)
        {
            return YES;
            break;
        }
    }
    return NO;
}


- (void)buttonDragged:(UIPanGestureRecognizer *)gesture
{
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    float newX = buttonXConstraint.constant;
    float newY = buttonYConstraint.constant;
    if(newX != MIN_POS_X && newY != MIN_POS_Y){
    //SJEKK for å fjerne bugs
        newX = MIN_POS_X;
        newY = MIN_POS_Y;
    }
    
    
    if(newX == MIN_POS_X && newY == MIN_POS_Y){
        //SWITCH HERE
        [button setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
        [button layoutIfNeeded];
        // button.backgroundColor = [ColorHelper purpleColor];
        if(toggleDragDirection){
            //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            startPosition = YES;
            if(xViewIsShowing){
                //self.onDragEndedX();
                self.onDragSwitchedFromX();
            }else{
                //self.onDragEndedY();
                self.onDragSwitchedFromY();
            }
            startY = NO;
            startX = NO;
        }
        toggleDragDirection = NO;
    }
    else{
        startPosition = NO;
    }
    
    if(newX == MIN_POS_X){
        //KAN dra Y
        dragY = YES;
    }
    else if(newX <= MIN_POS_X + FUDGE_FACTOR){
        //VIS INFO
        self.onDragInStartArea();
          [button setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
        if(xViewIsShowing){
            //self.onDragEndedX();
            self.onDragSwitchedFromX();
        }else{
            //self.onDragEndedY();
            self.onDragSwitchedFromY();
        }
        startX = NO;
       
    }
    else{
        //Kan ikke dra Y
        //NSLog(@"X SKAL STARTE");
        if(!startX){
            self.onDragInStartAreaEnded();
            self.onDragStartedX();
            xViewIsShowing = YES;
            startX = YES;
        }
        dragY = NO;
    }
    if(newY == MIN_POS_Y){
        //KAN dra X
        dragX = YES;
    }
    else if(newY <= MIN_POS_Y + FUDGE_FACTOR){
        //VIS INFO
        self.onDragInStartArea();
          [button setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
        if(xViewIsShowing){
            //self.onDragEndedX();
            self.onDragSwitchedFromX();
        }else{
            //self.onDragEndedY();
            self.onDragSwitchedFromY();
        }
        startY = NO;
    }
    else{
        //Kan ikke dra x
        // NSLog(@"Y SKAL STARTE");
        if(!startY){
            self.onDragInStartAreaEnded();
            self.onDragStartedY();
            xViewIsShowing = NO;
            startY = YES;
        }
        dragX = NO;
    }
    
    if(newX != MIN_POS_X || newY != MIN_POS_Y){
        toggleDragDirection = YES;
    }
    if(gesture.state == UIGestureRecognizerStateBegan){
        dragDirection = translation.y != 0 ? YES : NO;
        NSLog(@"XPOS: %f, YPOS: %f", translation.x, translation.y);
        NSLog(@"newX: %f, newY: %f", newX, newY);
        startedDrag = YES;
       // button.alpha = 0.0;
    }
    else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        self.onDragInStartAreaEnded();
        
        if(dragY && dragYEnabled){
            if(newY > MIN_POS_Y + FUDGE_FACTOR){
                self.onDragEndedY();
                [self fadeOutStatusButton];
            }else{
                self.onDragSwitchedFromY();
            }
            
        }
        
        else if(dragX && dragXEnabled){
            if(newX > MIN_POS_X + FUDGE_FACTOR){
                self.onDragEndedX();
                [self fadeOutStatusButton];
            }else{
                self.onDragSwitchedFromX();
            }
           
        }
    }
    else{
        if(dragY && dragYEnabled){
            translation.y < 0 ? [self moveUp:newY withTranslation:translation] :[self moveDown:newY withTranslation:translation];
            self.onDragY([NSNumber numberWithFloat:newY]);
        }
        if(dragXEnabled && dragX){
            translation.x < 0 ? [self moveLeft:newX withTranslation:translation] :[self moveRight:newX withTranslation:translation];
            self.onDragX([NSNumber numberWithFloat:newX]);
        }
        [gesture setTranslation:CGPointZero inView:label];
    }
}

-(void)fadeOutStatusButton{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                        button.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [button setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
                         buttonXConstraint.constant = buttonXConstraintDefault;
                         buttonYConstraint.constant = buttonYConstraintDefault;
                         
                         [UIView animateWithDuration:0.4f
                                               delay:0.4f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              button.alpha = 1.0f;
                                          }
                                          completion:nil];
                     }];
}

-(void)moveLeft:(float)xPos withTranslation:(CGPoint)translation{
    if(xPos >= (screenWidth - MAX_POS_X))
    {
        xPos = (screenWidth - MAX_POS_X);
        buttonXConstraint.constant = xPos;
    }else
    {
        buttonXConstraint.constant -= translation.x;
    }
}
-(void)moveRight:(float)xPos withTranslation:(CGPoint)translation
{
    if(xPos <= (MIN_POS_X))
    {
        xPos = MIN_POS_X;
        buttonXConstraint.constant = xPos;
    }else
    {
        buttonXConstraint.constant -= translation.x;
    }
}

-(void)moveUp:(float)yPos withTranslation:(CGPoint)translation
{
    if(yPos >= (screenHeight - MAX_POS_Y))
    {
        yPos = (screenHeight - MAX_POS_Y);
        buttonYConstraint.constant = yPos;
    }else
    {
        buttonYConstraint.constant -= translation.y;
    }
}

-(void)moveDown:(float)yPos withTranslation:(CGPoint)translation
{
    if(yPos <= MIN_POS_Y)
    {
        yPos = MIN_POS_Y;
        buttonYConstraint.constant = yPos;
    }else
    {
        buttonYConstraint.constant -= translation.y;
    }
}



@end
