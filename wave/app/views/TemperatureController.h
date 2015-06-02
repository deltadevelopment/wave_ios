//
//  TemperatureController.h
//  wave
//
//  Created by Simen Lie on 02.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "OverlayViewController.h"

@interface TemperatureController : OverlayViewController
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureImageView;

@end
