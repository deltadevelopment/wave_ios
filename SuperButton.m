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
//static int const MIN_POS = 20;
//static int const MAX_POS = 549;
static float const MIN_POS_X = 4.0;
static float const MIN_POS_Y = 20.0;
static float MAX_POS_Y = 135;
static float MAX_POS_X = 80;
static int const FUDGE_FACTOR = 10;

typedef enum {
    NONE,
    MIDDLE,
    EDIT,
    UPLOADING
} SuperButtonMode;

@implementation SuperButton
{
    UIButton *cameraButton;
   // UIButton *cancelButton;
   // UIButton *typeButton;
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
    //UILabel *toolTip;
    NSMutableArray *bucketTypes;
    int currentTypeIndex;
    bool pictureIsApproved;
    bool lockButton;
    SuperButtonMode superButtonMode;
    int pixels;
    NSTimer *timer;
}

-(UIButton *)getButton{
    return cameraButton;
}

- (id)init:(UIView *)view
{
    NSLog(@"INIT");
    self = [super init];
    if (self) {
        superView = view;
        bucketTypes = [[NSMutableArray alloc]init];
        cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //toolTip = [[UILabel alloc]init];
        [self initBucketTypes];
        pixels = 2;
        [self initUI];
        [self addConstraints:superView];
        screenBound = [[UIScreen mainScreen] bounds];
        screenSize = screenBound.size;
        screenWidth = screenSize.width;
        screenHeight = screenSize.height;
        superButtonMode = NONE;
    }
    return self;
}

-(void)animateProgress{
    UIImage *buttonImage = [UIHelper iconImage:[UIImage imageNamed:@"triangle.png"] withPoint:CGPointMake(200, 100)];
    UIImage *stretchableButtonImage = [buttonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [cameraButton setImage:nil forState:UIControlStateNormal];
    [cameraButton setImage:stretchableButtonImage forState:UIControlStateNormal];
  // [cameraButton imageView].frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [cameraButton imageView].frame.size.height);
    cameraButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -200);
    [self startTimer];
}

-(void)startTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self
                                           selector:@selector(animate) userInfo:nil repeats:YES];
    
}

-(void)animate{
    CGRect frame = [cameraButton imageView].frame;
    [cameraButton imageView].frame = CGRectMake(frame.origin.x - pixels,frame.origin.y, frame.size.width, frame.size.height);
    if((frame.origin.x - pixels) <= -150){
        [timer invalidate];
        [self animateButtonToRight];
    }
}

-(void)initBucketTypes{
    [bucketTypes addObject:[[BucketTypeModel alloc] initWithProperties:0 withDescription:@"Create new shared bucket" withIconPath:@"bucket-white.png"]];
    [bucketTypes addObject:[[BucketTypeModel alloc] initWithProperties:1 withDescription:@"Update your personal bucket" withIconPath:@"events-icon.png"]];
}

-(void)changeIcon:(UIImage *)img{
    [cameraButton setImage:[UIHelper iconImage:img withSize:100] forState:UIControlStateNormal];
}
-(void)enableDragX{
    dragXEnabled = YES;
}
-(void)enableDragY{
    dragYEnabled = YES;
}

-(void)initUI{
    [self initCameraButton];
   // [self initCancelButton];
    //[self initTypeButton];
    //[self initToolTip];
}

-(void)initCameraButton{
    [self applyUIOnButton:cameraButton];
    [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
    cameraButton.backgroundColor = [ColorHelper purpleColor];
    
    [cameraButton addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(cameraButtonDragged:)]];
    [cameraButton addTarget:self action:@selector(tapCameraButton) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:cameraButton];
}
/*
-(void)initCancelButton{
    [self applyUIOnButton:cancelButton];
    [cancelButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"cross.png"] withSize:150] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [cancelButton addTarget:self action:@selector(tapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:cancelButton];
    [self addConstraintsToButton:superView withButton:cancelButton withPoint:CGPointMake(4, 20) fromLeft:NO];
    cancelButton.hidden = YES;
    cancelButton.alpha = 0.0;

}
-(void)initTypeButton{
    [self applyUIOnButton:typeButton];
    typeButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [typeButton addTarget:self action:@selector(tapTypeButton) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:typeButton];
    [self addConstraintsToButton:superView withButton:typeButton withPoint:CGPointMake(4, 20) fromLeft:YES];
    typeButton.hidden = YES;
    typeButton.alpha = 0.0;

}

-(void)initToolTip{
    [UIHelper applyThinLayoutOnLabel:toolTip];
    [superView addSubview:toolTip];
    toolTip.hidden = YES;
    toolTip.alpha = 0.0;
    [self addTooltipConstraint:superView withLabel:toolTip];
    BucketTypeModel *bucketModel = [bucketTypes objectAtIndex:currentTypeIndex];
    [typeButton setImage:[UIHelper iconImage:[UIImage imageNamed:[bucketModel icon_path]] withSize:150] forState:UIControlStateNormal];
    toolTip.text = [bucketModel type_description];
}

-(void)showToolButtons{
    typeButton.hidden = NO;
    cancelButton.hidden = NO;
    toolTip.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         typeButton.alpha = 1.0;
                         cancelButton.alpha = 1.0;
                         toolTip.alpha = 1.0;
                     }
                     completion:nil];
}

-(void)hideToolButtons{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         typeButton.alpha = 0.0;
                         cancelButton.alpha = 0.0;
                         toolTip.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         typeButton.hidden = YES;
                         cancelButton.hidden = YES;
                         toolTip.hidden = YES;
                     }];
}
 */
-(void)applyUIOnButton:(UIButton *) button{
    button.layer.cornerRadius = 25;
    [button setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    button.clipsToBounds = YES;
}


-(void)addConstraints:(UIView *)view{
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    buttonXConstraint = [NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailingMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:cameraButton
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:MIN_POS_X];

    
    buttonYConstraint = [NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:cameraButton
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:MIN_POS_Y];
    
    buttonXConstraintMiddle = [NSLayoutConstraint constraintWithItem:superView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:cameraButton
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0
                                                             constant:0.0];
    
    buttonXConstraintDefault = buttonXConstraint.constant;
    buttonYConstraintDefault = buttonYConstraint.constant;
    [view addConstraint:buttonXConstraint];
    [view addConstraint:buttonYConstraint];
    [cameraButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cameraButton(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(cameraButton)]];
    [cameraButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cameraButton(==50)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(cameraButton)]];
}

-(void)addConstraintsToButton:(UIView *)view withButton:(UIButton *) button withPoint:(CGPoint) xy fromLeft:(bool) left{
    button.translatesAutoresizingMaskIntoConstraints = NO;
    if(left)
    {
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeadingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:xy.x]];
        
    }else{
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:button
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:xy.x]];
    }
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:button
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:xy.y]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==50)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(button)]];
}

-(void)addTooltipConstraint:(UIView *)view withLabel:(UILabel *) label{
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:label
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottomMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:label
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:90.0]];
    /*
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(button)]];
     */
}

-(void)tapCameraButton{
    [self test];
}

-(void)test{
    switch (superButtonMode) {
        case NONE:
            [self animateButtonToMiddle];
            [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
            superButtonMode = MIDDLE;
            self.onTap([NSNumber numberWithInt:1]);
            break;
        case MIDDLE:
            //animateToEdit
            [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:150] forState:UIControlStateNormal];
            self.onTap([NSNumber numberWithInt:2]);
            self.lockActions = YES;
            superButtonMode = EDIT;
            break;
        case EDIT:
            if(!self.lockActions){
                superButtonMode = NONE;
                [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
                self.onTap([NSNumber numberWithInt:0]);
                [self animateButtonToRight];
            }
            break;
        default:
            break;
    }
}

-(void)tapCancelButton{
    superButtonMode = NONE;
    [self animateButtonToRight];
    [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
    self.onCancelTap();

}
-(void)discard{
    superButtonMode = MIDDLE;
    [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
}

/*
-(void)tapTypeButton{
    currentTypeIndex ++;
    if(currentTypeIndex == [bucketTypes count]){
        currentTypeIndex = 0;
    }
    BucketTypeModel *bucketModel = [bucketTypes objectAtIndex:currentTypeIndex];
    [typeButton setImage:[UIHelper iconImage:[UIImage imageNamed:[bucketModel icon_path]] withSize:150] forState:UIControlStateNormal];
    toolTip.text = [bucketModel type_description];
}
*/
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
                     completion:^(BOOL finished){
                    
                             //[self showToolButtons];
                        
                        
                     }];

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
                     }
                     completion:^(BOOL finished){
                      
                             //[self hideToolButtons];
                         
                         
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


- (void)cameraButtonDragged:(UIPanGestureRecognizer *)gesture
{
    if(!lockButton){
       [self dragSuperbutton:gesture];
    }

}

-(void)dragSuperbutton:(UIPanGestureRecognizer *) gesture{
    
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
        [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
       // [cameraButton layoutIfNeeded];
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
        [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
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
        [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
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
        
        
        //
    }

}

-(void)fadeOutStatusButton{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                        cameraButton.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [cameraButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"camera-icon.png"] withSize:150] forState:UIControlStateNormal];
                         buttonXConstraint.constant = buttonXConstraintDefault;
                         buttonYConstraint.constant = buttonYConstraintDefault;
                         
                         [UIView animateWithDuration:0.4f
                                               delay:0.4f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              cameraButton.alpha = 1.0f;
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
