//
//  BucketViewController.h
//  wave
//
//  Created by Simen Lie on 27.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationControlViewController.h"
#import "SuperViewController.h"
#import "DropView.h"
@interface BucketViewController : SuperViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureIcon;
@property (weak, nonatomic) IBOutlet UILabel *displayNameText;
@property (weak, nonatomic) IBOutlet UILabel *availabilityIcon;
@property (weak, nonatomic) IBOutlet UILabel *dropsAmount;
@property (weak, nonatomic) IBOutlet UIImageView *dropsIcon;
@property (weak, nonatomic) IBOutlet UILabel *viewsAmount;
@property (nonatomic)     bool infoViewMode;

@property (weak, nonatomic) IBOutlet UIImageView *viewsIcon;

@end
