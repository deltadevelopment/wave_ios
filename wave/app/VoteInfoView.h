//
//  VoteInfoView.h
//  wave
//
//  Created by Simen Lie on 13.07.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropModel.h"
@interface VoteInfoView : UITableViewCell
@property (strong, nonatomic) UIButton *exitButton;
@property (strong, nonatomic) DropModel *drop;
-(void)animateInfoIn;
-(id)initWithDrop:(DropModel *) drop;
@end
