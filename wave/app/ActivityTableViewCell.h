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
@property (nonatomic, strong) BucketModel *bucket;
-(void)update:(BucketModel *) bucket;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bucketNameConstraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bucketConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePictureWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePictureHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePictureTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bucketTitleHoriConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bucketUsernameHoriConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bucketTitleVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *displayNameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameWidthConstraint;
-(void)hideShowShadow;
-(void)animateBucketTitleIn;
-(void)animateBucketTitleOut;

@end
