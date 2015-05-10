//
//  TestSuperViewController.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMenuViewController.h"
@interface NavigationControlViewController : UIViewController
@property (strong, nonatomic) UIBarButtonItem *menuItem;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) SlideMenuViewController *superController;
@property (strong, nonatomic) NSLayoutConstraint *bottomContstraintInMenu;
@property (nonatomic, copy) void (^onDrawerTap)(void);
-(void)addViewController:(SlideMenuViewController *) viewController;
-(void)didGainFocus;
-(void)setBucket:(UIImage *) bucket;
@end
