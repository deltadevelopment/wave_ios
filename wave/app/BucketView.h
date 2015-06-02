//
//  BucketView.h
//  wave
//
//  Created by Simen Lie on 31.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketView : UIView
@property (strong, nonatomic) UILabel *uiPageIndicator;
-(void)setPageIndicatorText:(NSString *) page;
@end
