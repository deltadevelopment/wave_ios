//
//  SuperButton.m
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperButton.h"
static int const MIN_POS = 30;
static int const MAX_POS = 549;
@implementation SuperButton
{
    UIButton *button;
    NSLayoutConstraint *buttonXConstraint;
    NSLayoutConstraint *buttonXConstraintMiddle;
    CGFloat buttonXConstraintDefault;
    NSLayoutConstraint *buttonYConstraint;
    CGFloat buttonYConstraintDefault;
    UIViewController* superViewController;
    bool dragY;
    CGRect screenBound;
    CGSize screenSize;
    CGFloat screenWidth;// = screenSize.width;
    CGFloat screenHeight;// = screenSize.height;
    bool dragXEnabled;
    bool dragYEnabled;
}

- (id)init:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        superViewController = viewController;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self initUI:superViewController.view];
        [self addConstraints:superViewController.view];
        screenBound = [[UIScreen mainScreen] bounds];
        screenSize = screenBound.size;
        screenWidth = screenSize.width;
        screenHeight = screenSize.height;
    }
    return self;
}

-(void)enableDragX{
    dragXEnabled = YES;
}
-(void)enableDragY{
    dragYEnabled = YES;
}

-(void)initUI:(UIView *)view{
    button.layer.cornerRadius = 25;
    [button setImage:[UIImage imageNamed:@"camera-icon.png"] forState:UIControlStateNormal];
    button.backgroundColor = [ColorHelper purpleColor];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(buttonDragged:)];
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
                                                      constant:20.0];

    
    buttonYConstraint = [NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:button
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:30.0];
    
    buttonXConstraintMiddle = [NSLayoutConstraint constraintWithItem:superViewController.view
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
                             [superViewController.view removeConstraint:buttonXConstraintMiddle];
                             [superViewController.view addConstraint:buttonXConstraint];
                         
                         }else{
                             [superViewController.view removeConstraint:buttonXConstraint];
                             [superViewController.view addConstraint:buttonXConstraintMiddle];
                         }
                       
                         
                         [superViewController.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                     }];

}

-(bool)superViewHasConstraint{
    for(NSLayoutConstraint *constraint in [superViewController.view constraints])
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
    
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        dragY = translation.y != 0 ? YES : NO;
        if(dragY){
           self.onDragStartedY();
        }else{
           self.onDragStartedX();
        }
     
    }
    else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        if(dragY && dragYEnabled){
            self.onDragEndedY();
            [self fadeOutStatusButton];
        }else{
            if(!dragY && dragXEnabled){
                self.onDragEndedX();
                [self fadeOutStatusButton];
            }
        }
        
    }
    else{
        if(dragY && dragYEnabled){
            translation.y < 0 ? [self moveUp:newY withTranslation:translation] :[self moveDown:newY withTranslation:translation];
            self.onDragY([NSNumber numberWithFloat:newX]);
            
        }else
        {
            if(dragXEnabled){
                translation.x < 0 ? [self moveLeft:newX withTranslation:translation] :[self moveRight:newX withTranslation:translation];
                self.onDragX([NSNumber numberWithFloat:newX]);
            }

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
    if(xPos >= (screenWidth - 100))
    {
        xPos = (screenWidth - 100);
        buttonXConstraint.constant = xPos;
        
    }else
    {
        buttonXConstraint.constant -= translation.x;
    }
}
-(void)moveRight:(float)xPos withTranslation:(CGPoint)translation
{
    if(xPos <= (MIN_POS))
    {
        xPos = MIN_POS;
        buttonXConstraint.constant = xPos;
        
    }else
    {
        buttonXConstraint.constant -= translation.x;
    }
}

-(void)moveUp:(float)yPos withTranslation:(CGPoint)translation
{
    if(yPos >= (screenHeight - 100))
    {
        yPos = (screenHeight - 100);
        buttonYConstraint.constant = yPos;
        
    }else
    {
        buttonYConstraint.constant -= translation.y;
    }
    
}

-(void)moveDown:(float)yPos withTranslation:(CGPoint)translation
{

    if(yPos <= MIN_POS)
    {
        yPos = MIN_POS;
        buttonYConstraint.constant = yPos;
        
    }else
    {
        buttonYConstraint.constant -= translation.y;
    }
}



@end
