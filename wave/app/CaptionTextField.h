//
//  CaptionTextField.h
//  wave
//
//  Created by Simen Lie on 26.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptionTextField : UITextField<UIGestureRecognizerDelegate, UITextFieldDelegate>
-(NSString *)getCaptionText;
@property (nonatomic, copy) void (^onKeyboardShow)(CaptionTextField*(textfield));
@property (nonatomic, copy) void (^onKeyboardHide)(CaptionTextField*(textfield));
@property (nonatomic) bool hasBox;
@property (strong, nonatomic) UIColor *currentColor;
-(void)toggleBox;

@end
