//
//  ChatTableViewCell.m
//  wave
//
//  Created by Simen Lie on 29.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initalize{
    self.isInitialized = YES;
   // self.layer.shouldRasterize = YES;
    //self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.transform = CGAffineTransformMakeRotation(M_PI);
    self.messageImage.layer.cornerRadius = 15;
    self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.messageImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.message.layer.cornerRadius = 2;
    self.message.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    self.message.clipsToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
