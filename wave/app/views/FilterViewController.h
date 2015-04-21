//
//  FilterViewController.h
//  wave
//
//  Created by Simen Lie on 21/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
@interface FilterViewController : OverlayViewController
@property (weak, nonatomic) IBOutlet UIImageView *filterImage;
@property (weak, nonatomic) IBOutlet UILabel *filterTopText;
@property (weak, nonatomic) IBOutlet UILabel *filterBottomText;
@property (weak, nonatomic) IBOutlet UIView *filterTimeLine;

@end
