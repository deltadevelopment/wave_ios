//
//  MenuTableViewController.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *buttonOne;
@property (nonatomic, copy) void (^onCellSelection)(NSString*(storyboardId));
@property (weak, nonatomic) IBOutlet UIImageView *bucketImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *availabilityLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UIView *profileView;


@end
