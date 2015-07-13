//
//  VoteInfoView.h
//  wave
//
//  Created by Simen Lie on 13.07.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteInfoView : UITableViewCell
@property (strong, nonatomic) UIButton *exitButton;
-(void)animateInfoIn;
@end
