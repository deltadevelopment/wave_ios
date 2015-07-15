//
//  SuperButton.m
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperButton.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BucketTypeModel.h"
#import "UIHelper.h"
static float const MIN_POS_X = 4.0;
static float const MIN_POS_Y = 20.0;
static float MAX_POS_Y = 135;
static float MAX_POS_X = 80;
//static int const FUDGE_FACTOR = 10;

typedef enum {
    NONE,
    MIDDLE,
    EDIT,
    UPLOADING
} SuperButtonMode;

typedef enum {
    NA,
    X,
    Y
} DragMode;


@implementation SuperButton
{
    UIButton *superButton;
    NSLayoutConstraint *buttonXConstraint;
    NSLayoutConstraint *buttonXConstraintMiddle;
    CGFloat buttonXConstraintDefault;
    NSLayoutConstraint *buttonYConstraint;
    CGFloat buttonYConstraintDefault;
    UIView* superView;
    bool dragXEnabled;
    bool dragYEnabled;
    bool pictureIsApproved;
    bool lockButton;
    SuperButtonMode superButtonMode;
    DragMode dragMode;
    int pixels;
    NSTimer *timer;
    float impactPointX;
    float impactPointY;
}

- (id)init:(UIView *)view
{
    self = [super init];
    if (self) {
        self.defaultIconPath = @"camera-icon.png";
        superView = view;
        superButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pixels = 2;
        [self initsuperButton];
        [self addConstraints:superView];
        superButtonMode = NONE;
    }
    return self;
}

-(void)initsuperButton{
    [self applyUIOnButton:superButton];
    [self setSuperButtonImage:self.defaultIconPath];
    superButton.backgroundColor = [ColorHelper purpleColor];
    
    [superButton addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(superButtonDragged:)]];
    [superButton addTarget:self action:@selector(tapSuperButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(longPressGesture:)];
    [longGesture setMinimumPressDuration:0.6];
    [superButton addGestureRecognizer:longGesture];
    
    
    [superView addSubview:superButton];
}

#pragma Getters

-(UIButton *)getButton{
    return superButton;
}

#pragma Setters

-(void)enableDragX{
    dragXEnabled = YES;
}
-(void)enableDragY{
    dragYEnabled = YES;
}

-(void)changeIcon:(UIImage *)img{
    [superButton setImage:[UIHelper iconImage:img withSize:100] forState:UIControlStateNormal];
}

-(void)applyUIOnButton:(UIButton *) button{
    button.layer.cornerRadius = 25;
    [button setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    button.clipsToBounds = YES;
}

#pragma SuperButton progress methods

-(void)animateProgress{
    UIImage *buttonImage = [UIHelper iconImage:[UIImage imageNamed:@"triangle.png"] withPoint:CGPointMake(200, 100)];
    UIImage *stretchableButtonImage = [buttonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [superButton setImage:nil forState:UIControlStateNormal];
    [superButton setImage:stretchableButtonImage forState:UIControlStateNormal];
  // [superButton imageView].frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [superButton imageView].frame.size.height);
    superButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -200);
    [self startTimer];
}

-(void)startTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self
                                           selector:@selector(animate) userInfo:nil repeats:YES];
}

-(void)animate{
    CGRect frame = [superButton imageView].frame;
    [superButton imageView].frame = CGRectMake(frame.origin.x - pixels,frame.origin.y, frame.size.width, frame.size.height);
    if((frame.origin.x - pixels) <= -150){
        [timer invalidate];
        [self animateButtonToRight];
    }
}


#pragma public methods /callbacks

-(void)videoRecorded{
    [superButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:150] forState:UIControlStateNormal];
    superButtonMode = EDIT;
    self.lockActions = NO;
}

-(void)tapCancelButton{
    superButtonMode = NONE;
   // [self animateButtonToRight];
    [self animateButtonToRightWithoutOpacity];
       [self setSuperButtonImage:self.defaultIconPath];
    self.onCancelTap();

}
-(void)discard{
    superButtonMode = MIDDLE;
     [self setSuperButtonImage:self.defaultIconPath];
}


# pragma GESTURES

-(void)tapSuperButton{
    if(self.hasError){
        [self showErrorAlert];
    }else{
        if(!self.disabled){
            switch (superButtonMode) {
                case NONE:
                    [self animateButtonToMiddle];
                    [self setSuperButtonImage:self.defaultIconPath];
                    superButtonMode = MIDDLE;
                    self.onTap([NSNumber numberWithInt:1]);
                    break;
                case MIDDLE:
                        //animateToEdit
                        [self setSuperButtonImage:@"tick.png"];
                        
                        self.lockActions = YES;
                        superButtonMode = EDIT;
                    
                    self.onTap([NSNumber numberWithInt:2]);
                    
                    break;
                case EDIT:
                    if(!self.lockActions){
                        if(self.shouldChangeMode){
                            superButtonMode = NONE;
                            [self setSuperButtonImage:self.defaultIconPath];
                            
                            [self animateButtonToRight];
                        }
                       self.onTap([NSNumber numberWithInt:0]);
                    }
                    break;
                default:
                    break;
            }
        }
       
    }
    
}

-(void)setSuperButtonImage:(NSString *) path{
    [superButton setImage:[UIHelper iconImage:[UIImage imageNamed:path] withSize:150] forState:UIControlStateNormal];
}

-(void)longPressGesture:(UILongPressGestureRecognizer *) recognizer{
    if(superButtonMode == MIDDLE){
        if (recognizer.state == UIGestureRecognizerStateBegan)
        {
            self.onLongPressStarted();
            self.lockActions = YES;
        }
        
        if (recognizer.state == UIGestureRecognizerStateCancelled
            || recognizer.state == UIGestureRecognizerStateFailed
            || recognizer.state == UIGestureRecognizerStateEnded)
        {
            self.onLongPressEnded();
        }
    }
}

- (void)superButtonDragged:(UIPanGestureRecognizer *)gesture
{
    if(!lockButton){
        //Only perform gestures if one or more drags is enabled
        if(dragXEnabled || dragYEnabled){
            [self dragSuper:gesture];
        }
    }
}

-(void)dragSuper:(UIPanGestureRecognizer *) gesture{
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    float newX = buttonXConstraint.constant;
    float newY = buttonYConstraint.constant;
    if(gesture.state == UIGestureRecognizerStateBegan){
       //--Implement start code here for telling the user how the superbutton works
    }

    impactPointX -=translation.x;
    impactPointY -= translation.y;
    if(dragMode == X){
        translation.x < 0 ? [self moveLeft:newX withTranslation:translation] :[self moveRight:newX withTranslation:translation];
        self.onDragX([NSNumber numberWithFloat:newX]);
    }
    else if(dragMode == Y){
        translation.y < 0 ? [self moveUp:newY withTranslation:translation] :[self moveDown:newY withTranslation:translation];
        self.onDragY([NSNumber numberWithFloat:newY]);
    }
    if(newY <= MIN_POS_Y && newX <= MIN_POS_X){
        dragMode = NA;
    }
    if(dragMode == NA){
           [self setSuperButtonImage:self.defaultIconPath];
        
        //Checking if the X drag is enabled, to force the Y gesture to work properly if set alone
        dragMode = impactPointX > MIN_POS_X && dragXEnabled ? [self startXDrag] : impactPointY > MIN_POS_Y ? [self startYDrag] : [self endXYDrag];
    }
    
    if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        if(dragMode != NA){
            dragMode == X ? self.onDragEndedX() : self.onDragEndedY();
            [self fadeOutStatusButton];
        }
        else{
        
        }
        dragMode = NA;
        impactPointY = 0;
        impactPointX = 0;
    }
    
    [gesture setTranslation:CGPointZero inView:label];
}

#pragma Drag mode methods
-(DragMode)startXDrag{
    if(dragXEnabled){
        impactPointX = 0;
        self.onDragSwitchedFromY();
        self.onDragStartedX();
        return  X;
    }
    return [self endXYDrag];
    
}

-(DragMode)startYDrag{
    if(dragYEnabled){
        impactPointY = 0;
        self.onDragSwitchedFromX();
        self.onDragStartedY();
        return  Y;
    }
        return [self endXYDrag];
}
-(DragMode)endXYDrag{
    dragYEnabled ? self.onDragSwitchedFromY() : nil;
    dragXEnabled ? self.onDragSwitchedFromX() : nil;
    return NA;
}

#pragma Button movements

-(void)moveLeft:(float)xPos withTranslation:(CGPoint)translation{
    if(xPos >= ([UIHelper getScreenWidth] - MAX_POS_X))
    {
        xPos = ([UIHelper getScreenWidth] - MAX_POS_X);
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
    if(yPos >= ([UIHelper getScreenHeight] - MAX_POS_Y))
    {
        yPos = ([UIHelper getScreenHeight] - MAX_POS_Y);
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



# pragma Animations

-(void)animateButtonToMiddle{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [superView  removeConstraint:buttonXConstraint];
                         [superView  addConstraint:buttonXConstraintMiddle];
                         lockButton = YES;
                         [superView  layoutIfNeeded];
                     }
                     completion:nil];
}

-(void)animateButtonToRight{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [superView removeConstraint:buttonXConstraintMiddle];
                         [superView addConstraint:buttonXConstraint];
                         lockButton = NO;
                         [superView  layoutIfNeeded];
                         superButton.alpha = 0.0;
                     }
                     completion:nil];
}

-(void)animateButtonToRightWithoutOpacity{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [superView removeConstraint:buttonXConstraintMiddle];
                         [superView addConstraint:buttonXConstraint];
                         lockButton = NO;
                         [superView  layoutIfNeeded];
                     }
                     completion:nil];
}

-(void)fadeOutStatusButton{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                        superButton.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [superButton setImage:[UIHelper iconImage:[UIImage imageNamed:self.defaultIconPath] withSize:150] forState:UIControlStateNormal];
                         buttonXConstraint.constant = buttonXConstraintDefault;
                         buttonYConstraint.constant = buttonYConstraintDefault;
                         
                         [UIView animateWithDuration:0.4f
                                               delay:0.4f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              superButton.alpha = 1.0f;
                                          }
                                          completion:nil];
                     }];
}

# pragma Constraints

-(void)addConstraints:(UIView *)view{
    superButton.translatesAutoresizingMaskIntoConstraints = NO;
    buttonXConstraint = [NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailingMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:superButton
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:MIN_POS_X];
    
    
    buttonYConstraint = [NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:superButton
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:MIN_POS_Y];
    
    buttonXConstraintMiddle = [NSLayoutConstraint constraintWithItem:superView
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:superButton
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0.0];
    
    buttonXConstraintDefault = buttonXConstraint.constant;
    buttonYConstraintDefault = buttonYConstraint.constant;
    [view addConstraint:buttonXConstraint];
    [view addConstraint:buttonYConstraint];
    [superButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superButton(==50)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(superButton)]];
    [superButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superButton(==50)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(superButton)]];
}

#pragma ALERTS
-(void)showErrorAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Bucket not saved"
                                                   message:@"Are you sure you want to dismiss the bucket?"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Ok",nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //ikke logg ut
    }else{
        self.hasError = NO;
        [self tapSuperButton];
        self.onErrorDismissed();
    }
}







@end
