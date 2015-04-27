//
//  SlideMenuViewController.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpace;
-(void)showDrawer;
-(void)addRootViewController:(NSString *) storyboardId;
-(void)addBucketAsRoot:(NSString *) storyboardId;
-(void)removeBucketAsRoot;
@end
