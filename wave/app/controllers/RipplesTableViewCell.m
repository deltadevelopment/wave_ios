//
//  RipplesTableViewCell.m
//  wave
//
//  Created by Simen Lie on 16/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RipplesTableViewCell.h"
#import "UIHelper.h"
@implementation RipplesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initalize{
    
    
    self.profilePictureImage =[[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height /2) -15, 30, 30)];
    self.profilePictureImage.layer.cornerRadius = 15;
    self.profilePictureImage.clipsToBounds = YES;
    
    
    self.userButton =[UIButton buttonWithType:UIButtonTypeSystem];
    self.userButton.frame = CGRectMake(45, 10, 100, 30);
    [self.userButton setTitle:@"simenle" forState:UIControlStateNormal];
    
    
    float widthIs =
    [self.userButton.titleLabel.text
     boundingRectWithSize:self.userButton.titleLabel.frame.size
     options:NSStringDrawingUsesLineFragmentOrigin
     attributes:@{ NSFontAttributeName:self.userButton.titleLabel.font }
     context:nil]
    .size.width;
    self.userButton.frame =CGRectMake(self.userButton.frame.origin.x, self.userButton.frame.origin.y, widthIs + 10, self.userButton.frame.size.height);

    
    self.notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake((widthIs + 55),10 , (self.frame.size.width) - 180, 30)];
    self.notificationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.notificationLabel.numberOfLines = 0;
   // self.notificationLabel.backgroundColor = [UIColor redColor];

    self.actionButton =[UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.frame = CGRectMake((self.frame.size.width) -60, (self.frame.size.height /2) -20, 40, 40);
    self.actionButton.backgroundColor =[UIColor redColor];
    [self.userButton setTitle:@"simenle" forState:UIControlStateNormal];
    
 
 
    
    [self addSubview:self.actionButton];
    [self addSubview:self.profilePictureImage];
   [self addSubview:self.userButton];
     [self addSubview:self.notificationLabel];
    
    
    self.isInitialized = YES;
    [UIHelper applyThinLayoutOnLabel:self.notificationLabel withSize:15.0f];
    [self.notificationLabel setTextColor:[UIColor blackColor]];
    [UIHelper applyThinLayoutOnLabel:self.NotificationTimeLabel withSize:15.0f];
    [self.NotificationTimeLabel setTextColor:[UIColor blackColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
    self.NotificationTimeLabel.hidden = YES;
    // self.layer.shouldRasterize = YES;
    //self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    /*
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
     */
    
    
    
    
}

-(float)getHeightForLabel{
 
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:15]};
    CGRect rect = [self.notificationLabel.text boundingRectWithSize:CGSizeMake((self.frame.size.width) - 200, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                     context:nil];
    return rect.size.height;
}

-(void)calculateHeight{
    NSLog(@"HEIGHT IS %f", [self getHeightForLabel]);
    CGRect rect = self.notificationLabel.frame;
    rect.size.height =[self getHeightForLabel];
    self.notificationLabel.frame = rect;
}

- (IBAction)actionButtonAction:(id)sender {
}
@end
