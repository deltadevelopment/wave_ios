//
//  InfoViewController.h
//  wave
//
//  Created by Simen Lie on 22/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "OverlayViewController.h"

@interface InfoViewController : OverlayViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xButtonLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xButtonrightConstraint;
@property (weak, nonatomic) IBOutlet UIView *xLineView;
@property (weak, nonatomic) IBOutlet UIView *yLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yLineTopConstraint;
-(void)addBlur;
@end
