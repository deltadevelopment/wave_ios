//
//  SimpleListCell.h
//  wave
//
//  Created by Simen Lie on 24.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscribeModel.h"
@interface SimpleListCell : UITableViewCell
@property(nonatomic, strong) UILabel *userLabel;
@property(nonatomic, strong) UIImageView *profilePictureImage;
@property(nonatomic) bool isInitialized;
@property (nonatomic) SubscribeModel *subscriber;
-(void)initialize;
-(void)updateUI:(SubscribeModel *) subscriber;

@end
