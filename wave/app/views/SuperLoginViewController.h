//
//  SuperLoginViewController.h
//  wave
//
//  Created by Simen Lie on 13/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldWrapper.h"
@interface SuperLoginViewController : UIViewController{
    CGSize keyboardSize;
    NSLayoutConstraint* verticalSpaceConstraintButton;    
}
-(CALayer *)addLine:(UITextField *) textField;
-(CALayer *)addLineWithNoPadding:(UITextField *)textField;
-(void)setTextFieldStyle:(UITextField *) textField;
-(void)errorAnimation;
-(void)setPlaceholderFont:(UITextField *) textField;

@end
