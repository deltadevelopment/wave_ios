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
#import "ApplicationHelper.h"
#import "AuthHelper.h"
#import "ConstraintHelper.h"
@implementation PeekViewModule{
    UIViewController *superController;
    AuthHelper *authHelper;
    bool isDeviceUser;
    UIView *parentView;
    UIActivityIndicatorView *activityIndicator;
    bool isSubscriber;
}

-(id)initWithView:(UIView *) view withSubview:(UIView *)subview withController:(UIViewController *) controller{
    self = [super init];
    parentView = view;
    superController = controller;
    authHelper = [[AuthHelper alloc] init];
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.userInteractionEnabled = NO;
    self.backgroundView.alpha = 0.5;
    
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth]/2 - (100/2), 50, 100, 100)];
    self.profilePicture.image = [UIImage imageNamed:@"user-icon-gray.png"];
    self.profilePicture.layer.cornerRadius = 50;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    
    float labelWidth = [UIHelper getScreenWidth] - 40;
    self.usernameLabel =[[UILabel alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth]/2 - (labelWidth/2), 166, labelWidth, 30)];
    [UIHelper applyThinLayoutOnLabel:self.usernameLabel withSize:20];
    self.usernameLabel.text = @"simenlie";
    self.usernameLabel.textAlignment = NSTextAlignmentCenter;
   
    self.subscribeButton = [UIButton buttonWithType:UIButtonTypeSystem];
   // self.subscribeButton.frame = CGRectMake([UIHelper getScreenWidth]/2 - (170/2), [UIHelper getScreenHeight] - 64 - 123, 170, 40);
    [UIHelper applyThinLayoutOnButton:self.subscribeButton];
    self.settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingsButton.frame = CGRectMake([UIHelper getScreenWidth] - 50, 10, 40, 40);
    [self.settingsButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.settingsButton addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton setImage:[UIImage imageNamed:@"settings-icon-white.png"] forState:UIControlStateNormal];
    [self.settingsButton showsTouchWhenHighlighted];
    [[self.subscribeButton layer] setBorderWidth:1.0f];
    [[self.subscribeButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    //[self.subscribeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.subscribeButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
  [self.subscribeButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.subscribeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
   // [self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
    [self.subscribeButton setTitle:NSLocalizedString(@"subscribe_txt", nil) forState:UIControlStateNormal];
    self.subscribeButton.layer.cornerRadius = 10;
    self.subscribeButton.clipsToBounds = YES;
    [self.subscribeButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    self.subscribersCountLabel =[[UILabel alloc] initWithFrame:
                                 CGRectMake([UIHelper getScreenWidth]/2 - (labelWidth/2), [UIHelper getScreenHeight] - 64 - 69, labelWidth, 30)];
    [UIHelper applyThinLayoutOnLabel:self.subscribersCountLabel withSize:17];
    //self.subscribersCountLabel.text = @"550 others already do";
    self.subscribersCountLabel.textAlignment = NSTextAlignmentCenter;
    
    
    return self;
}

-(void)layoutElementsWithSubview:(UIView *) subview{
    [parentView insertSubview:self.backgroundView belowSubview:subview];
    [parentView insertSubview:self.profilePicture belowSubview:subview];
    [parentView insertSubview:self.usernameLabel belowSubview:subview];
    [parentView insertSubview:self.subscribeButton belowSubview:subview];
    [parentView insertSubview:self.subscribersCountLabel belowSubview:subview];
    [parentView insertSubview:self.settingsButton belowSubview:subview];
    [ConstraintHelper addConstraintsToButtonWithNoSize:parentView withButton:self.subscribeButton withPoint:CGPointMake(-86, 83) fromLeft:YES fromTop:NO];
    [self AddSizeConstraintToButton:self.subscribeButton];
  
}

-(void)AddSizeConstraintToButton:(UIButton *) button{
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==170)]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(button)]];
    [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==40)]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(button)]];

}

-(void)layoutBackgroundWithSubview:(UIView *)subview{
    [parentView insertSubview:self.backgroundView belowSubview:subview];
}

-(void)updateText:(UserModel *) user
{
    self.user = user;
    [self.user requestProfilePic:^(NSData *data){
        [self.profilePicture setImage:[UIImage imageWithData:data]];
    }];
    if(user.Id == [[authHelper getUserId] intValue]){
        isDeviceUser = YES;
        //self.subscribeButton.hidden = YES;
        self.settingsButton.hidden = NO;
       
        [self.subscribeButton setTitle:NSLocalizedString(@"subscriptions_button_txt", nil) forState:UIControlStateNormal];
        //[self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
        //[[self.subscribeButton layer] setBorderColor:[ColorHelper purpleColor].CGColor];
    }else{
        self.subscribeButton.hidden = NO;
        self.settingsButton.hidden = YES;
        isDeviceUser = NO;
    }
   
    self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d %@", user.subscribers_count, NSLocalizedString(@"subscriptions_txt", nil)];
    self.usernameLabel.text = user.usernameFormatted;
      [self checkSubscription];
   

}

-(void)showSettings{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SettingsTableViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"settings"];
    //[superController.navigationController presentViewController:vc animated:YES completion:nil];
      //[superController.navigationController pushViewController:vc animated:YES];
    
     [[ApplicationHelper getMainNavigationController] pushViewController:vc animated:YES];
   // [self.view.window.rootViewController presentViewController:viewController animated:YES completion:nil];

}

-(void)fadeOut{
    [UIView animateWithDuration:0.1f
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
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.backgroundView.alpha = 0.5;
                         self.profilePicture.alpha = 1.0;
                         self.usernameLabel.alpha = 1.0;
                         self.subscribeButton.alpha = 1.0;
                         self.subscribersCountLabel.alpha = 1.0;
                         self.settingsButton.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
}

-(void)hide{
    self.backgroundView.alpha = 0.0;
    self.profilePicture.alpha = 0.0;
    self.usernameLabel.alpha = 0.0;
    self.subscribeButton.alpha = 0.0;
    self.subscribersCountLabel.alpha = 0.0;
    self.settingsButton.alpha = 0.0;
}

-(void)initActivityIndicator{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.subscribeButton addSubview:activityIndicator];
    
    activityIndicator.center = CGPointMake(self.subscribeButton.frame.size.width / 2, self.subscribeButton.frame.size.height / 2);
    activityIndicator.hidden = NO;
    activityIndicator.hidesWhenStopped = YES;
}

-(void)removeInsetsFromButton{
    [self.subscribeButton setImage: nil forState:UIControlStateNormal];
    [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.subscribeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.subscribeButton sizeToFit];
}

-(void)checkSubscription{
    if(self.user.Id != [[authHelper getUserId] intValue]){
        UserModel *deviceUser =[[UserModel alloc] initWithDeviceUser];
        self.subscribeModel = [[SubscribeModel alloc] initWithSubscriber:deviceUser withSubscribee:self.user];
        if (self.subscribeModel.isSubscriberLocal) {
            isSubscriber = YES;
            [self changeSubscribeUI];
        }
        else{
            isSubscriber = NO;
            [self changeSubscribeUI];
        }
    }
}

-(void)changeSubscribeUI{
    if(isSubscriber){
        [self.subscribeButton setTitle:NSLocalizedString(@"unsubscribe_txt", nil) forState:UIControlStateNormal];
        self.subscribeButton.imageView.frame = CGRectMake(0, 0, 40, 40);
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
        [[self.subscribeButton imageView] setTintColor:[UIColor whiteColor]];
        [self.subscribeButton setTintColor:[UIColor whiteColor]];
          //top left bottom right
        [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 140)];
        [self.subscribeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
        [self.subscribeButton sizeToFit];
    }else{
        //[self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
        [self.subscribeButton setTitle:NSLocalizedString(@"subscribe_txt", nil) forState:UIControlStateNormal];
        [self removeInsetsFromButton];
    }
    
}

-(void)updatePeekView:(UserModel *) user{
    self.user = user;
    NSLog(@"HERE");
    self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d %@", user.subscribers_count, NSLocalizedString(@"subscriptions_txt", nil)];
    self.usernameLabel.text = [user display_name] != nil ? [user display_name] : [user usernameFormatted];
    if(user.Id == [[authHelper getUserId] intValue]){
        //self.subscribeButton.hidden = YES;
        self.subscribersCountLabel.hidden = YES;
    }else{
        self.subscribersCountLabel.hidden = NO;
    }
}

-(void)subscribeAction{
    if (self.user.Id != [[authHelper getUserId] intValue]) {
        if(activityIndicator == nil){
            [self initActivityIndicator];
        }
        activityIndicator.hidden = NO;
        [activityIndicator startAnimating];
        [self.subscribeButton setTitle:@"" forState:UIControlStateNormal];
        [self removeInsetsFromButton];
        if(isSubscriber){
            [self.subscribeModel delete:^(ResponseModel *response){
                isSubscriber = NO;
                [self changeSubscribeUI];
                [activityIndicator stopAnimating];
                [self.user setSubscribers_count:[self.user subscribers_count]-1];
                [self updatePeekView:self.user];
            } onError:^(NSError *error){}];
        }else{
            [self.subscribeModel saveChanges:^(ResponseModel *response){
                isSubscriber = YES;
                [self changeSubscribeUI];
                [activityIndicator stopAnimating];
                [self.user setSubscribers_count:[self.user subscribers_count]+1];
                [self updatePeekView:self.user];
            } onError:^(NSError *error)
             {
                 
                 
             }];
        }
    }
    else {
        //Show Subscribers
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"searchNavigation"];
       // [vc.navigationBar setti]
       [vc.navigationBar setTintColor:[ColorHelper purpleColor]];
        [vc.navigationBar setBackgroundColor:[ColorHelper purpleColor]];
        [vc.navigationBar setBarTintColor:[ColorHelper purpleColor]];
        //[[ApplicationHelper getMainNavigationController] pushViewController:vc animated:YES];
        [[ApplicationHelper getMainNavigationController] presentViewController:vc animated:YES completion:nil];
    }
}

@end
