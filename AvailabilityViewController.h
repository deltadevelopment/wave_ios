//
//  AvailabilityViewController.h
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
@interface AvailabilityViewController : OverlayViewController
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *availabilityText;

@end
