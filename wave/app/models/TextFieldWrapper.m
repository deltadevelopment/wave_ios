//
//  TextFieldWrapper.m
//  wave
//
//  Created by Simen Lie on 13/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "TextFieldWrapper.h"
#import "ColorHelper.h"
#import "UIHelper.h"

@implementation TextFieldWrapper
{
    UILabel *error;
}
-(id)init:(UITextField *) textField withLayer:(CALayer *) layer withConstraint:(NSLayoutConstraint *) constraint
{
    _constraint = constraint;
    _textField = textField;
    _layer = layer;
    return self;
}

-(id)init:(UITextField *) textField withView:(UIView *) view
{
    _textField = textField;
    _view = view;
    _layer = [CALayer layer];
    _layer.frame = CGRectMake(0.0f,  59, [UIHelper getScreenWidth], 1.0f);
    _layer.backgroundColor = [UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1].CGColor;
    [_view.layer addSublayer:_layer];
    
    return self;
}

-(void)showError:(NSString *)errorMessage{
    if(_layer.hidden == NO){
        _constraint.constant += 40;
        _layer.hidden = YES;
        _textField.textColor = [ColorHelper whiteColor];
        error = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, [UIHelper getScreenWidth] -40, 20)];
        error.text = errorMessage;
        error.textColor = [ColorHelper whiteColor];
        
        [error setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]];
        [_view addSubview:error];
        _view.backgroundColor = [ColorHelper redColor];
        _button = [[UIButton alloc]initWithFrame:CGRectMake([UIHelper getScreenWidth] -40, 40, 20, 20)];
        [_button setImage:[UIImage imageNamed:@"cross-white.png"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(cancelError) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:_button];
    }
 
}

-(void)cancelError{
    [self removeErrorAndText];
    _textField.text = @"";
}

-(void)removeErrorAndText{
    if(_layer.hidden == YES){
        _constraint.constant -= 40;
        [_button removeFromSuperview];
        [error removeFromSuperview];
        _view.backgroundColor = [ColorHelper whiteColor];
        _textField.textColor = [UIColor blackColor];
        _layer.hidden = NO;
        [_textField setNeedsDisplay];
        [_textField setNeedsLayout];
    }
    

}

@end
