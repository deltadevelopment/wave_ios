//
//  PeekViewModule.m
//  wave
//
//  Created by Simen Lie on 25.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "PeekViewModule.h"
#import "UIHelper.h"
#import "SettingsTableViewController.h"
@implementation PeekViewModule{
    UIViewController *superController;
}

-(id)initWithView:(UIView *) view withSubview:(UIView *)subview withController:(UIViewController *) controller{
    self = [super init];
    superController = controller;
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.userInteractionEnabled = NO;
    self.backgroundView.alpha = 0.5;
    
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth]/2 - (100/2), 50, 100, 100)];
    self.profilePicture.image = [UIImage imageNamed:@"miranda-kerr.jpg"];
    self.profilePicture.layer.cornerRadius = 50;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    
    float labelWidth = [UIHelper getScreenWidth] - 40;
    self.usernameLabel =[[UILabel alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth]/2 - (labelWidth/2), 165, labelWidth, 30)];
    [UIHelper applyThinLayoutOnLabel:self.usernameLabel withSize:20];
    self.usernameLabel.text = @"simenlie";
    self.usernameLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    self.subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.subscribeButton.frame = CGRectMake([UIHelper getScreenWidth]/2 - (150/2), [UIHelper getScreenHeight] - 64 - 130, 150, 40);
    self.settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingsButton.frame = CGRectMake([UIHelper getScreenWidth] - 50, 50, 20, 20);
    [self.settingsButton addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton setImage:[UIImage imageNamed:@"settings-icon-white.png"] forState:UIControlStateNormal];
    
    [[self.subscribeButton layer] setBorderWidth:1.0f];
    [[self.subscribeButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
    self.subscribeButton.layer.cornerRadius = 10;
    self.subscribeButton.clipsToBounds = YES;
    [self.subscribeButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.subscribersCountLabel =[[UILabel alloc] initWithFrame:
                                 CGRectMake([UIHelper getScreenWidth]/2 - (labelWidth/2), [UIHelper getScreenHeight] - 64 - 70, labelWidth, 30)];
    [UIHelper applyThinLayoutOnLabel:self.subscribersCountLabel withSize:17];
    self.subscribersCountLabel.text = @"550 others already do";
    self.subscribersCountLabel.textAlignment = NSTextAlignmentCenter;
    [view insertSubview:self.backgroundView belowSubview:subview];
    [view insertSubview:self.profilePicture belowSubview:subview];
    [view insertSubview:self.usernameLabel belowSubview:subview];
    [view insertSubview:self.subscribeButton belowSubview:subview];
    [view insertSubview:self.subscribersCountLabel belowSubview:subview];
     [view insertSubview:self.settingsButton belowSubview:subview];
    
    NSLog(@"ADDDING");
    
    return self;
}

-(void)updateText:(UserModel *) user
{
    self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d others already do", user.subscribers_count];
    self.usernameLabel.text = user.usernameFormatted;

}

-(void)showSettings{
    /*
    NSLog(@"SERTTIN");
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SettingsTableViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"settings"];
    [superController.view.window.rootViewController presentViewController:vc animated:YES completion:nil];
   // [self.view.window.rootViewController presentViewController:viewController animated:YES completion:nil];
*/
}

-(void)fadeOut{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.backgroundView.alpha = 0.0;
                         self.profilePicture.alpha = 0.0;
                         self.usernameLabel.alpha = 0.0;
                         self.subscribeButton.alpha = 0.0;
                         self.subscribersCountLabel.alpha = 0.0;
                         self.settingsButton.alpha = 0.0;
                     }
                     completion:nil];
}

-(void)fadeIn{
    [UIView animateWithDuration:0.3f
                          delay:0.5f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                        self.backgroundView.alpha = 0.5;
                         self.profilePicture.alpha = 1.0;
                         self.usernameLabel.alpha = 1.0;
                         self.subscribeButton.alpha = 1.0;
                         self.subscribersCountLabel.alpha = 1.0;
                           self.settingsButton.alpha = 1.0;
                     }
                     completion:nil];
}

-(void)subscribeAction{
    NSLog(@"subscribing");
}
@end
