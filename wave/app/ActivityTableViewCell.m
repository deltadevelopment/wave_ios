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
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    float center = ([UIHelper getScreenHeight] - 64)/2;
    spinner.center = CGPointMake([UIHelper getScreenWidth]/2-10, center/2-10);
    
    spinner.hidesWhenStopped = YES;
    spinner.hidden = YES;
    
    
    
    self.bucketImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bucketImage.clipsToBounds = YES;
    [self insertSubview:self.topBar aboveSubview:self.bucketImage];
    [self insertSubview:self.bottomBar aboveSubview:self.bucketImage];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.displayNameText.text = [feed objectAtIndex:indexPath.row];
    
    [self.bucketImage setUserInteractionEnabled:YES];
    [self setUserInteractionEnabled:YES];
    [UIHelper applyThinLayoutOnLabel:self.displayNameText withSize:18 withColor:[UIColor whiteColor]];
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

-(void)startSpinnerAnimtation{
    [spinner startAnimating];
}
-(void)stopSpinnerAnimation{
    [spinner stopAnimating];
}
-(void)update:(BucketModel *) bucket{
        DropModel *drop = [[bucket drops] objectAtIndex:0];
    /*
        if(drop.media_img != nil){
             self.bucketImage.image = drop.media_img;
          
        }
        else if(drop.media_tmp != nil){
            
        }
     */
   
    
    /*
        else if(drop){
             self.bucketImage.image = [UIImage imageNamed:drop.media];
        }
    */
    [drop requestPhoto:^(NSData *media){
        if([drop media_type] == 0){
            //BILDE
            [self.bucketImage setImage:[UIImage imageWithData:media]];
        }else{
            [self.bucketImage setImage:[UIHelper thumbnailFromVideo:media]];
            //VIDEO
        }
        
    }];
    
    NSLog(@"%@", bucket.title);
    if([bucket.bucket_type isEqualToString:@"user"]){
        self.displayNameText.text = [NSString stringWithFormat:@"@%@", [[bucket user] username]];
    }else{
        self.displayNameText.text = bucket.title;
    }
        
        //
}

-(void)updateDropImage:(UIImage *) image{
    self.bucketImage.image = image;
}

@end
