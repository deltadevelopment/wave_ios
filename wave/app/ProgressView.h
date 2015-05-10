//
//  ProgressView.h
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
@property (strong, nonatomic) UILabel *progressText;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

-(void)setProgressString:(NSString *) text;
-(void)startProgress;
-(void)stopProgress;
@end
