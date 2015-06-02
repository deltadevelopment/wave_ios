//
//  PeekViewController.m
//  wave
//
//  Created by Simen Lie on 27.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "PeekViewController.h"
#import "UIHelper.h"
#import "AuthHelper.h"

@interface PeekViewController ()

@end

@implementation PeekViewController
{
    bool isSubscriber;
    UIActivityIndicatorView *activityIndicator;
}
AuthHelper *authHelper;
- (void)viewDidLoad {
    [super viewDidLoad];
    authHelper = [[AuthHelper alloc] init];
    // Do any additional setup after loading the view.
    self.location.text = @"Kristiansand";
    // self.displayName.text = @"Anna Holm";
    self.profilePicture.layer.cornerRadius = 50;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    self.availability.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor clearColor];
    self.availability.clipsToBounds = YES;
    self.availability.hidden = YES;
    self.subscribeButton.alpha = 0.0;
    self.view.userInteractionEnabled = YES;
    [UIHelper applyThinLayoutOnLabel:self.displayName withSize:24.0];
    [UIHelper applyThinLayoutOnLabel:self.location withSize:17.0];
    [[self.subscribeButton layer] setBorderWidth:1.0f];
    [[self.subscribeButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.subscribeButton.layer.cornerRadius = 10;
    self.subscribeButton.clipsToBounds = YES;
    [self.subscribeButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.subscribeButton setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    
    [self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
    self.location.alpha = 0.0;
    //40 150
    
    
     // self.subscribeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.subscribeButton.imageView.frame.size.width, 0, self.subscribeButton.imageView.frame.size.width);
     //self.subscribeButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.subscribeButton.titleLabel.frame.size.width, 0, -self.subscribeButton.titleLabel.frame.size.width);
     
   
}



-(void)initActivityIndicator{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.subscribeButton addSubview:activityIndicator];

    activityIndicator.center = CGPointMake(self.subscribeButton.frame.size.width / 2, self.subscribeButton.frame.size.height / 2);
    activityIndicator.hidden = NO;
    activityIndicator.hidesWhenStopped = YES;
}



-(void)subscribeAction{
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

-(void)removeInsetsFromButton{
    [self.subscribeButton setImage: nil forState:UIControlStateNormal];
    [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.subscribeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.subscribeButton sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideSubscribeButton{
    if(self.subscribeButton.alpha == 1.0){
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.subscribeButton.alpha = 0.0;
                             self.location.alpha = 0.0;
                             self.subscribeVerticalconstraint.constant += 60;
                             [self.view layoutIfNeeded];
                             [self.view updateConstraintsIfNeeded];
                         }
                         completion:nil];
    }
    
}

-(void)animatePeekViewIn{
                             [self resetToSubscription];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = 0;
                         frame.size.height -=64;
                         frame.size.height = [UIHelper getScreenHeight];
                         self.view.frame = frame;
                         self.subscribeButton.alpha = 1.0;
                         self.location.alpha = 1.0;
                         self.subscribeVerticalconstraint.constant -= 60;
                         [self.view layoutIfNeeded];
                         [self.view updateConstraintsIfNeeded];
                     }
                     completion:^(BOOL finished){

                          [self checkSubscription];
                     }];
    
}

-(void)resetToSubscription{
    [self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
    [self removeInsetsFromButton];
}

-(void)updatePeekView:(UserModel *) user{
    self.user = user;
    self.location.text = [NSString stringWithFormat:@"%d others already do", [user subscribers_count]];
    self.displayName.text = [user display_name] != nil ? [user display_name] : [user username];
    if(user.Id == [[authHelper getUserId] intValue]){
        self.subscribeButton.hidden = YES;
        self.location.hidden = YES;
    }else{
        self.location.hidden = NO;
    }
}


-(void)checkSubscription{
    UserModel *deviceUser =[[UserModel alloc] initWithDeviceUser];
    self.subscribeModel = [[SubscribeModel alloc] initWithSubscriber:deviceUser withSubscribee:self.user];
    [self.subscribeModel isSubscriber:^(ResponseModel *response){
        NSLog(@"HERE");
        if(response.success){
            isSubscriber = YES;
            [self changeSubscribeUI];
        }else{
            isSubscriber = NO;
            [self changeSubscribeUI];
        }
    } onError:^(NSError *error){
        NSLog(@"ERRORR");
    }];
}

-(void)changeSubscribeUI{
    if(isSubscriber){
        [self.subscribeButton setTitle:@"Unsubscribe" forState:UIControlStateNormal];
        self.subscribeButton.imageView.frame = CGRectMake(0, 0, 40, 40);
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
        [[self.subscribeButton imageView] setTintColor:[UIColor whiteColor]];
        [self.subscribeButton setTintColor:[UIColor whiteColor]];
        [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 130)];
        [self.subscribeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
        [self.subscribeButton sizeToFit];
        //top left bottom right

    }else{
        [self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
        [self removeInsetsFromButton];
    }
    
}

-(void)showAllDetails{
    self.subscribeButton.alpha = 1.0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
