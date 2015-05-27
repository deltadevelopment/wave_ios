//
//  ImageEditorView.h
//  wave
//
//  Created by Simen Lie on 26.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CaptionTextField.h"
@interface ImageEditorView : UIView<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) CaptionTextField *captionLabel;

@end
