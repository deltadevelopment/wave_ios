//
//  SimpleListCell.m
//  wave
//
//  Created by Simen Lie on 24.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SimpleListCell.h"
#import "UIHelper.h"
@implementation SimpleListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initialize{
    //self.frame = CGRectMake(0, 0, 100, 50);
    self.isInitialized = YES;
    self.userLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, [UIHelper getScreenWidth] -120, self.frame.size.height -20)];
   // [self.userLabel setText:@"simenlie"];
    //[self.usernameLabel setBackgroundColor:[UIColor redColor]];
    [UIHelper applyThinLayoutOnLabel:self.userLabel];
    
    self.profilePictureImage =[[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height /2) -15, 30, 30)];
    self.profilePictureImage.layer.cornerRadius = 15;
    self.profilePictureImage.clipsToBounds = YES;
    [self.profilePictureImage setImage:[UIImage imageNamed:@"user-icon-gray.png"]];
    
    [self addSubview:self.userLabel];
    [self addSubview:self.profilePictureImage];
    [self setBackgroundColor:[UIColor clearColor]];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)updateUI:(SubscribeModel *) subscriber
{
    [self.profilePictureImage setImage:[UIImage imageNamed:@"user-icon-gray.png"]];
    self.subscriber = subscriber;
    [self.userLabel setText:[[subscriber subscribee] usernameFormatted]];
    [[self.subscriber subscribee] requestProfilePic:^(NSData *data){
        [self.profilePictureImage setImage:[UIImage imageWithData:data]];
    }];
}

@end
