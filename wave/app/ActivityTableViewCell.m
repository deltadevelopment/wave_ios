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
    UIActivityIndicatorView *spinner;
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
    superController = controller;
    viewMode = mode;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    float center = ([UIHelper getScreenHeight] - 64)/2;
    spinner.center = CGPointMake([UIHelper getScreenWidth]/2-10, center/2-10);
    
    spinner.hidesWhenStopped = YES;
    spinner.hidden = YES;
    
    if(mode == 1){
        UIButton *settings = [UIButton buttonWithType:UIButtonTypeCustom];
        settings.frame = CGRectMake([UIHelper getScreenWidth] - 30, 20, 20, 20);
        [settings addTarget:self action:@selector(showActions) forControlEvents:UIControlEventTouchUpInside];
        [settings setImage:[UIImage imageNamed:@"dots-icon"] forState:UIControlStateNormal];
        [self addSubview:settings];
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
        [UIHelper applyThinLayoutOnLabel:self.usernameText withSize:15 withColor:[UIColor whiteColor]];
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
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:spinner];
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

-(void)startSpinnerAnimtation{
    [spinner startAnimating];
}
-(void)stopSpinnerAnimation{
    [spinner stopAnimating];
}
-(void)update:(BucketModel *) bucket{
   [self.bucketImage setImage:nil];
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
            self.displayNameText.text = @"My drops";
            self.profilePictureIcon.hidden = YES;
        }else{
            self.displayNameText.text = [NSString stringWithFormat:@"@%@", [[bucket user] username]];
            self.profilePictureIcon.hidden = NO;
        }
        self.usernameText.hidden = YES;
    }else{
        self.displayNameText.text = bucket.title;
        self.usernameText.hidden = NO;
        self.usernameText.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"by_txt", nil), [[bucket user] username]];
    }
}

-(void)updateDropImage:(UIImage *) image{
    self.bucketImage.image = image;
}

@end
