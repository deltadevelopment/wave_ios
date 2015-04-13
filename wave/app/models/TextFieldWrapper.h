//
//  TextFieldWrapper.h
//  wave
//
//  Created by Simen Lie on 13/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TextFieldWrapper : NSObject
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) CALayer *layer;
@property (strong, nonatomic) NSLayoutConstraint *constraint;
-(id)init:(UITextField *) textField withLayer:(CALayer *) layer withConstraint:(NSLayoutConstraint *) constraint;
-(id)init:(UITextField *) textField withView:(UIView *) view;

-(void)cancelError;
-(void)showError:(NSString *)errorMessage;
-(void)removeErrorAndText;
@end
