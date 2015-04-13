//
//  ViewController.h
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface ViewController : SuperViewController
@property (weak, nonatomic) IBOutlet UIButton *testButton;
- (IBAction)actionTest:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *camView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *testButton2;

@end

