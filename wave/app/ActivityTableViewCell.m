//
//  ActivityTableViewCell.m
//  wave
//
//  Created by Simen Lie on 20.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "UIHelper.h"
#import "BucketModel.h"
#import "DropModel.h"
@implementation ActivityTableViewCell{
    UIView *shadowView;
    UIView *shadowViewBottom;
    UIActivityIndicatorView *spinner;
    UIActivityIndicatorView *spinnerForUpload;
    int viewMode;
    UIViewController *superController;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initializeWithMode:(int) mode withSuperController:(UIViewController *) controller{
    self.isInitialized = YES;
    self.displayNameText.text = @"";
    [self setBackgroundColor:[UIColor whiteColor]];
    superController = controller;
    viewMode = mode;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    float center = ([UIHelper getScreenHeight] - 64)/2;
    spinner.center = CGPointMake([UIHelper getScreenWidth]/2-10, center/2-10);
    
    spinner.hidesWhenStopped = YES;
    spinner.hidden = YES;
    
    spinnerForUpload = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinnerForUpload.center = CGPointMake([UIHelper getScreenWidth]/2-10, center/2-10);
    
    spinnerForUpload.hidesWhenStopped = YES;
    spinnerForUpload.hidden = YES;
    
    if(mode == 1){
        //UIButton *settings = [UIButton buttonWithType:UIButtonTypeCustom];
       // settings.frame = CGRectMake([UIHelper getScreenWidth] - 30, 20, 20, 20);
       // [settings addTarget:self action:@selector(showActions) forControlEvents:UIControlEventTouchUpInside];
        //[settings setImage:[UIImage imageNamed:@"dots-icon"] forState:UIControlStateNormal];
        //[self addSubview:settings];
    }
 
    
    
    self.bucketImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bucketImage.clipsToBounds = YES;
    [self insertSubview:self.topBar aboveSubview:self.bucketImage];
    [self insertSubview:self.bottomBar aboveSubview:self.bucketImage];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.displayNameText.text = [feed objectAtIndex:indexPath.row];
    
    [self.bucketImage setUserInteractionEnabled:YES];
    [self setUserInteractionEnabled:YES];
    [UIHelper applyThinLayoutOnLabel:self.displayNameText withSize:19 withColor:[UIColor whiteColor]];
    [UIHelper applyThinLayoutOnLabel:self.usernameText withSize:19 withColor:[UIColor whiteColor]];
    [UIHelper roundedCorners:self.profilePictureIcon withRadius:15];
    [UIHelper roundedCorners:self.availabilityIcon withRadius:7.5];
    self.availabilityIcon.hidden = YES;
    self.topBar.alpha = 1.0;
    self.topBar.backgroundColor = [UIColor clearColor];
    self.bottomBar.alpha = 1.0;
    self.bottomBar.hidden = YES;
    
    shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]/4)];
    [UIHelper addShadowToView:shadowView];
    self.bucketImage.frame = CGRectOffset(self.frame, 50, 50);
    [self.bucketImage addSubview:shadowView];
    
    float vi = ([UIHelper getScreenHeight])/2 - [UIHelper getScreenHeight]/4 - 30;
    shadowViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0,vi, [UIHelper getScreenWidth], [UIHelper getScreenHeight]/4)];
    [UIHelper addShadowToViewBottom:shadowViewBottom];
    [self.bucketImage addSubview:shadowViewBottom];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:spinner];
    [self addSubview:spinnerForUpload];
}

-(void)hideShowShadow{
    shadowViewBottom.hidden = !shadowViewBottom.hidden;
}

-(void)showActions{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* delete = [UIAlertAction
                         actionWithTitle:@"Delete bucket"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* tag = [UIAlertAction
                         actionWithTitle:@"Tag people"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [view addAction:tag];
    [view addAction:delete];
    
    [view addAction:cancel];
    [superController presentViewController:view animated:YES completion:nil];
}


-(void)animateBucketTitleIn{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.usernameText setAlpha:1.0f];
                         [shadowViewBottom setAlpha:0.38f];
                    
                     }
                     completion:nil];

}

-(void)animateBucketTitleOut{
    [self.usernameText setAlpha:0.0f];
    [shadowViewBottom setAlpha:0.0f];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         
                     }
                     completion:nil];
    
}

-(void)startSpinnerAnimtation{
    spinner.hidden = NO;
    [spinner startAnimating];
}
-(void)stopSpinnerAnimation{
    [spinner stopAnimating];
}

-(void)startSpinnerForUploadAnimtation{
    spinnerForUpload.hidden = NO;
    [spinnerForUpload startAnimating];
}
-(void)stopSpinnerForUploadAnimation{
    [spinnerForUpload stopAnimating];
}

-(void)update:(BucketModel *) bucket{
    self.bucket = bucket;
    self.profilePictureIcon.hidden = YES;
   [self.bucketImage setImage:nil];
    
    [[bucket user] requestProfilePic:^(NSData *data){
        [self.profilePictureIcon setImage:[UIImage imageWithData:data]];
        self.profilePictureIcon.hidden = NO;
    }];
    /*
    if([bucket.bucket_type isEqualToString:@"user"]){
       
    }else{
        [self.profilePictureIcon setBackgroundColor:[ColorHelper purpleColor]];
        self.profilePictureIcon.hidden = NO;
        [self.profilePictureIcon setImage:nil];
    }
    */
    
    DropModel *drop = [bucket getLastDrop];
    if([bucket Id] >0){
        [spinner startAnimating];
        if([drop media_type] == 0){
            [drop requestPhoto:^(NSData *media){
                [spinner stopAnimating];
                [self.bucketImage setImage:[UIImage imageWithData:media]];
            }];
        }else{
            [drop requestThumbnail:^(NSData *media){
                [spinner stopAnimating];
               // [self.bucketImage setImage:[UIHelper thumbnailFromVideo:media]];
                 [self.bucketImage setImage:[UIImage imageWithData:media]];
            }];
        }
        
    }
    if([bucket.bucket_type isEqualToString:@"user"]){
        if(viewMode == 1){
            self.displayNameText.text = NSLocalizedString(@"my_drops_txt", nil);
            self.profilePictureIcon.hidden = YES;
            self.bucketTitleHoriConstraint.constant = 10;
        }else{
            self.displayNameText.text = [NSString stringWithFormat:@"@%@", [[bucket user] username]];
            self.profilePictureIcon.hidden = NO;
        }
        self.usernameText.hidden = YES;
        self.profilePictureTopConstraint.constant = 8;
    }else{
        self.usernameText.text = bucket.title;
        self.usernameText.hidden = NO;
        self.usernameVerticalConstraint.constant = [UIHelper getScreenHeight]/2 - 70;//260;
        self.bucketUsernameHoriConstraint.constant = 10;
        self.usernameWidthConstraint.constant = [UIHelper getScreenWidth] - 20;
        [self.usernameText setTextAlignment:NSTextAlignmentRight]; //<-- THIS IS THE LINE TO COMMENT OUT
        //[self.usernameText setTextAlignment:NSTextAlignmentLeft]; // <--- THIS IS THE LINE TO UNCOMMENT
        [UIHelper applyThinLayoutOnLabel:self.usernameText withSize:21 withColor:[UIColor whiteColor]];
        if (bucket.user != nil) {
            //self.displayNameText.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"by_txt", nil), [[bucket user] username]];
            self.displayNameText.text = [[bucket user] usernameFormatted];
        }else{
            self.usernameText.text = @"";
        }
    }
}

-(void)updateAfterUpload{
    self.usernameText.hidden = NO;
    
}
-(void)updateDropImage:(UIImage *) image{
    self.bucketImage.image = image;
}

@end
