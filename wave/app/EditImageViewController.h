//
//  EditImageViewController.h
//  wave
//
//  Created by Simen Lie on 03.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditImageViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *colorPicker;
@property (weak, nonatomic) IBOutlet UILabel *colorTracker;

@end
