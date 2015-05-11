//
//  BucketView.h
//  wave
//
//  Created by Simen Lie on 11.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropView.h"
@interface BucketView : UIView
@property (nonatomic) bool lockArea;
@property (strong,nonatomic)DropView *dropView;
@end
