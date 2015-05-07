//
//  ActivityTableViewCell.h
//  wave
//
//  Created by Simen Lie on 20.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bucketImage;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *availabilityIcon;
@property (weak, nonatomic) IBOutlet UILabel *displayNameText;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureIcon;
@property (nonatomic) bool isInitialized;
-(void)initialize;
-(void)update:(NSString *)name;
-(void)updateDropImage:(UIImage *) image;

@end
