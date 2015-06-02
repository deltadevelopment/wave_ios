//
//  TemperatureView.h
//  wave
//
//  Created by Simen Lie on 02.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureView : UIView
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UIImageView *temperatureImageView;
-(void)setTemperature:(NSString *) temperature;
-(void)setBackgroundColorWithPercentage:(float)percentage;
@end
