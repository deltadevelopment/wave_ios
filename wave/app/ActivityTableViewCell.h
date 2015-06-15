//
//  ActivityTableViewCell.h
//  wave
//
//  Created by Simen Lie on 20.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BucketModel.h"
@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bucketImage;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UILabel *availabilityIcon;
@property (weak, nonatomic) IBOutlet UILabel *displayNameText;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureIcon;
@property (nonatomic) bool isInitialized;

@property (weak, nonatomic) IBOutlet UILabel *usernameText;
-(void)initializeWithMode:(int) mode withSuperController:(UIViewController *) controller;
//-(void)update:(NSString *)name;
-(void)updateDropImage:(UIImage *) image;
-(void)startSpinnerAnimtation;
-(void)stopSpinnerAnimation;
-(void)startSpinnerForUploadAnimtation;
-(void)stopSpinnerForUploadAnimation;
-(void)update:(BucketModel *) bucket;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bucketNameConstraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bucketConstraint;

@end
