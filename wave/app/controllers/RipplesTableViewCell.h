//
//  RipplesTableViewCell.h
//  wave
//
//  Created by Simen Lie on 16/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RipplesTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *notificationLabel;
@property (nonatomic) bool isInitialized;
-(void)initalize;
@property (strong, nonatomic)  UILabel *NotificationTimeLabel;
@property (strong, nonatomic)  UIImageView *profilePictureImage;
@property (strong, nonatomic)  UIButton *actionButton;
@property (strong, nonatomic) UIButton *userButton;
@property (strong, nonatomic)  UIButton *userButtonAction;
- (IBAction)actionButtonAction:(id)sender;
-(void)calculateHeight;
@end
