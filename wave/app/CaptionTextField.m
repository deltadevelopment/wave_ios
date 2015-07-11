//
//  CaptionTextField.m
//  wave
//
//  Created by Simen Lie on 26.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CaptionTextField.h"
#import "UIHelper.h"
#import "ColorHelper.h"
const int PADDING = 20;
const int MIN_WIDTH = 100;
@implementation CaptionTextField{
    CGAffineTransform startingTransform;
    float fontSize;
    float lastRotation;
    float lastScale;
    CGFloat pointSize;
    CGFloat temp;
    bool isRotating;
    bool isMoving;
    bool isPinching;
    bool editTextMode;
    CGAffineTransform lastTransform;
    CGPoint lastPointOnScreen;
    CGSize lastSizeOnScreen;
    UIFont *lastFont;
    bool firstTimeEditing;
    NSTimer *searchTimer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)init{
    self =[super init];
    firstTimeEditing = YES;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.currentColor = [ColorHelper magenta];
    self.backgroundColor = self.currentColor;
    self.delegate = self;
    self.hasBox = YES;
    //[UIHelper applyThinLayoutOnLabel:self.captionLabel withSize:30];
    [UIHelper applyCaptionLayoutOnTextField:self withSize:30];
    
    //self.text = @"caption this it the cap!";
    self.placeholder = NSLocalizedString(@"caption_placeholder_txt", nil);

    
    self.textAlignment = NSTextAlignmentCenter;
    if([self getWidth]< MIN_WIDTH){
        self.frame = CGRectMake(10, 10, MIN_WIDTH + PADDING, 50);
    }else{
        self.frame = CGRectMake(10, 10, [self getWidth] + PADDING, 50);
    }
    self.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGestureRecognizer.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [rotationRecognizer setDelegate:self];
    [self addGestureRecognizer:rotationRecognizer];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(labelDragged:)];
    [self addGestureRecognizer:gesture];
    
  
   // [self addKeyboardObservers];
    
    [self sizeToFit];
    //[self addPadding];
    
   [self addTarget:self.delegate action:@selector(textField1Active) forControlEvents:UIControlEventEditingDidBegin];
    
    
    //[self addSubview:self];
    self.center = CGPointMake([UIHelper getScreenWidth]/2 - (self.frame.size.height/2), [UIHelper getScreenHeight]/2 - (self.frame.size.height/2));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self];
    
    [self setKeyboardType:UIKeyboardTypeEmailAddress];
    return self;
}

-(void)textField1Active{
    self.onKeyboardGainFocus(self);
    [self addKeyboardObservers];
}


-(void)removeKeyboardObservers{
   [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)addKeyboardObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(float)getWidth{
    float widthIs =
    [self.text
     boundingRectWithSize:self.frame.size
     options:NSStringDrawingUsesLineFragmentOrigin
     attributes:@{ NSFontAttributeName:self.font }
     context:nil]
    .size.width;
    return widthIs;
}

-(void)keyboardWillShow:(NSNotification *)note {
    self.onKeyboardShow(self);
    NSDictionary* info = [note userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    self.keyboardSize = [aValue CGRectValue].size;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIHelper getScreenWidth], 50);
    self.center = CGPointMake([UIHelper getScreenWidth]/2, [UIHelper getScreenHeight] - self.keyboardSize.height - (self.frame.size.height/2));
    [self setFont:[UIFont fontWithName:self.font.fontName size:30]];
        //verticalSpaceConstraintButton.constant += keyboardSize.height;
    
}

-(void)keyboardWillHide {
    self.onKeyboardHide(self);
}

-(void)toggleBox{
    self.hasBox = self.hasBox ? NO : YES;
    if(self.hasBox){
        self.backgroundColor = self.currentColor;
        self.textColor = [UIColor whiteColor];
    }else{
        self.textColor = self.currentColor;
        self.backgroundColor = [UIColor clearColor];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(isRotating || isMoving || isPinching){
        return NO;
    }else{
        editTextMode = YES;
        lastTransform = self.transform;
        lastPointOnScreen = self.center;
        lastSizeOnScreen = self.frame.size;
        lastFont = self.font;
        self.transform = CGAffineTransformIdentity;
        return YES;
    }
    
}

- (void)textFieldDidChange:(NSNotification *)notification {
    self.placeholder = @"";
    if ([self.text rangeOfString:@"@"].location == NSNotFound) {
        NSLog(@"string does not contain any alphas");
    } else {

        NSRange range = [self.text rangeOfString:@"@"];
        
        if (searchTimer != nil && [searchTimer isValid]) {
            [searchTimer invalidate];
        }
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                       target:self
                                                     selector:@selector(searchNotify)
                                                     userInfo:nil
                                                      repeats:NO];
        
        
        
        //range.location
    }
    
    //[self sizeToFit];
}

-(void)searchNotify{
    self.onAlphasFound(self);
            NSLog(@"string contains alph!");
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    if(!editTextMode){
        CGFloat pinchScale = recognizer.scale;
        pinchScale = round(pinchScale * 1000) / 1000.0;
        
        if (pinchScale < 1)
            
        {
            
            self.font = [UIFont fontWithName:self.font.fontName size:
                                      
                                      (self.font.pointSize - (pinchScale + 0.2))];
            
            recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
            self.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
            [self sizeToFit];
            recognizer.scale=1;
        }
        else if(pinchScale > 1)
        {
            self.font = [UIFont fontWithName:self.font.fontName size:(self.font.pointSize + pinchScale + 0.2)];
            recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
            self.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
            [self sizeToFit];
            recognizer.scale=1;
        }
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            isPinching = NO;
        }
        else if(recognizer.state == UIGestureRecognizerStateBegan){
            isPinching = YES;
        }
        //currentLabel.adjustsFontSizeToFitWidth = YES;
        
        // [currentLabel sizeToFit];
        // NSLog(@"Font :%@",label.font);
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    editTextMode = NO;
    if(!firstTimeEditing){
        self.transform = lastTransform;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, lastSizeOnScreen.width, lastSizeOnScreen.height);
        [self sizeToFit];
        self.center = lastPointOnScreen;
        self.font = lastFont;
        [self sizeToFit];
        
    }else{
        firstTimeEditing = NO;
        [self sizeToFit];
        self.center = CGPointMake([UIHelper getScreenWidth]/2, [UIHelper getScreenHeight]/2);
    }
    
    [self removeKeyboardObservers];
    return YES;
}

-(void)rotate:(UIRotationGestureRecognizer *)recognizer {
    if(!editTextMode){
        recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
        recognizer.rotation = 0;
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            isRotating = NO;
            
        }
        else if(recognizer.state == UIGestureRecognizerStateBegan){
            isRotating = YES;
        }
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
    
}

- (void)labelDragged:(UIPanGestureRecognizer *)recognizer
{
    if(!editTextMode){
        CGPoint translation = [recognizer translationInView:[recognizer.view superview]];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            isMoving = NO;
        }
        else if(recognizer.state == UIGestureRecognizerStateBegan){
            isMoving = YES;
        }
        
        /*
         if (recognizer.state == UIGestureRecognizerStateEnded) {
         
         CGPoint velocity = [recognizer velocityInView:self.captionLabel];
         CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
         CGFloat slideMult = magnitude / 200;
         NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
         
         float slideFactor = 0.1 * slideMult; // Increase for more of a slide
         CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
         recognizer.view.center.y + (velocity.y * slideFactor));
         finalPoint.x = MIN(MAX(finalPoint.x, 0), self.captionLabel.bounds.size.width);
         finalPoint.y = MIN(MAX(finalPoint.y, 0), self.captionLabel.bounds.size.height);
         
         [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
         recognizer.view.center = finalPoint;
         } completion:nil];
         
         
         }*/
    }
    
}

-(NSString *)getCaptionText{
    return self.text;
}


@end
