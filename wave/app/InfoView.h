//
//  InfoView.h
//  wave
//
//  Created by Simen Lie on 14/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIVisualEffectView<UIGestureRecognizerDelegate>
-(void)show:(UIButton *) button withConstraint:(NSLayoutConstraint *) constraint;
-(void)hide;
@property (nonatomic) bool viewHidden;
@property (nonatomic, strong) UIButton *button;
@end
