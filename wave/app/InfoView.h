//
//  InfoView.h
//  wave
//
//  Created by Simen Lie on 14/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIVisualEffectView<UIGestureRecognizerDelegate>
-(void)show;
-(void)hide;
-(id)initWithSuperViewController:(UIViewController *) superViewController
                      withButton:(UIButton *)infoButtonLocal
                  withConstraint:(NSLayoutConstraint *) constraint;
@property (nonatomic) bool viewHidden;
@property (nonatomic, strong) UIButton *button;
@end
