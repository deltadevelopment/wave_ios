//
//  DropViewController.h
//  wave
//
//  Created by Simen Lie on 05/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "AbstractFeedViewController.h"

@interface DropViewController : AbstractFeedViewController
@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UILabel *dropTitle;
@property (strong, nonatomic) UIView *topBar;

@end
