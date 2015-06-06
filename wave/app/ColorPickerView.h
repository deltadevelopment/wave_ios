//
//  ColorPickerView.h
//  wave
//
//  Created by Simen Lie on 06.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptionTextField.h"
@interface ColorPickerView : UIView
@property (strong, nonatomic) UIImageView *colorPicker;
@property (strong, nonatomic) UIButton *colorPickerButton;
@property (strong, nonatomic) UIColor *currentColor;
@property (strong, nonatomic) CaptionTextField *captionField;
-(id)initWithCaptionField:(CaptionTextField *)field;
@end
