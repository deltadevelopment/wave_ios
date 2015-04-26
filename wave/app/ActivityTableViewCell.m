//
//  ActivityTableViewCell.m
//  wave
//
//  Created by Simen Lie on 20.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "UIHelper.h"
@implementation ActivityTableViewCell{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initialize{
    
    
    self.isInitialized = YES;
    self.bucketImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bucketImage.clipsToBounds = YES;
    [self insertSubview:self.topBar aboveSubview:self.bucketImage];
    [self insertSubview:self.bottomBar aboveSubview:self.bucketImage];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.displayNameText.text = [feed objectAtIndex:indexPath.row];
    
    [self.bucketImage setUserInteractionEnabled:YES];
    [self setUserInteractionEnabled:YES];
    [UIHelper applyThinLayoutOnLabel:self.displayNameText withSize:18 withColor:[UIColor blackColor]];
    [UIHelper roundedCorners:self.profilePictureIcon withRadius:15];
    [UIHelper roundedCorners:self.availabilityIcon withRadius:7.5];
    self.topBar.alpha = 0.9;
    self.bottomBar.alpha = 0.9;

}

@end
