//
//  TemperatureView.m
//  wave
//
//  Created by Simen Lie on 02.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "TemperatureView.h"
#import "UIHelper.h"
@implementation TemperatureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    frame.origin.y -=32;
    self = [super initWithFrame:frame];
    self.temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -32, [UIHelper getScreenWidth] -20, [UIHelper getScreenHeight])];
    self.temperatureLabel.text = @"0°";
    [self.temperatureLabel setTextAlignment:NSTextAlignmentCenter];
    [self.temperatureLabel setMinimumScaleFactor:12.0/17.0];
    self.temperatureLabel.adjustsFontSizeToFitWidth = YES;
    [UIHelper applyLayoutOnLabel:self.temperatureLabel withSize:100];
    //[UIHelper applyThinLayoutOnLabel:self.temperatureLabel withSize:100];
    
    [self addSubview:self.temperatureLabel];
    [self addSubview:self.temperatureImageView];
    self.hidden = YES;
    self.alpha = 0.0;
    return self;
}

-(void)setBackgroundColorWithPercentage:(float)percentage{
 
    [self setBackgroundColor:[self mixGreenAndRed:percentage/100]];
}

-(UIColor *)mixGreenAndRed:(float)percentageGreen {
    return [UIColor colorWithRed:percentageGreen green:0.0 blue:(1.0 - percentageGreen) alpha:1.0];
}

-(UIColor*)mix:(float)percentageGreen{
    return [UIColor colorWithHue:percentageGreen / 1 saturation:1.0 brightness:1.0 alpha:1.0];
}

-(void)setTemperature:(NSString *) temperature{
    self.temperatureLabel.text = temperature;
}

@end
