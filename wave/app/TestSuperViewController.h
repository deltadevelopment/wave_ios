//
//  TestSuperViewController.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMenuViewController.h"
@interface TestSuperViewController : UIViewController
@property (strong, nonatomic) UIBarButtonItem *menuItem;
@property (strong, nonatomic) SlideMenuViewController *superController;
@property (nonatomic, copy) void (^onDrawerTap)(void);
-(void)addViewController:(SlideMenuViewController *) viewController;
@end