//
//  VoteInfoView.m
//  wave
//
//  Created by Simen Lie on 13.07.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "VoteInfoView.h"
#import "UIHelper.h"

@implementation VoteInfoView
{
    UIVisualEffectView *blurEffectView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)init{
    self = [super init];
    self.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitButton.frame = CGRectMake(10, 10, 35, 35);
    //[self.voteButton setBackgroundColor:[UIColor redColor]];
    [self.exitButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.exitButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"cross.png"] withSize:40] forState:UIControlStateNormal];
    
    self.exitButton.userInteractionEnabled = YES;
    [self.exitButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self setAlpha:0.0f];
   // self.exitButton.alpha = 0.5;
    [self addBlur];
    [self addSubview:self.exitButton];
    [self setHidden:YES];
    return self;
}

-(void)dismissView{
  //  [self setHidden:YES];
    [self animateInfoOut];
}


-(void)addBlur{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    // blurEffectView.alpha = 0.9;
    blurEffectView.alpha = 1.0;
    [self addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)animateInfoIn{
    self.hidden = NO;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
}

-(void)animateInfoOut{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         
                         self.hidden = YES;
                     }];
}


@end
