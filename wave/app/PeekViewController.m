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
#import "AbstractFeedViewController.h"

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
    self.profilePicture.userInteractionEnabled = YES;
    self.profilePicture.frame = CGRectMake(([UIHelper getScreenWidth]/2) - 50, 50, 100, 100);
    self.displayName.userInteractionEnabled = YES;
    UITapGestureRecognizer *showProfileGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile)];
    UITapGestureRecognizer *showProfileGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile)];
    [self.profilePicture addGestureRecognizer:showProfileGesture];
     [self.displayName addGestureRecognizer:showProfileGesture2];
    self.availability.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor clearColor];
    self.availability.clipsToBounds = YES;
    self.availability.hidden = YES;
    self.subscribeButton.alpha = 0.0;
    self.view.userInteractionEnabled = YES;
    [UIHelper applyThinLayoutOnLabel:self.displayName withSize:20.0];
    [UIHelper applyThinLayoutOnLabel:self.location withSize:17.0];
    [[self.subscribeButton layer] setBorderWidth:1.0f];
    [[self.subscribeButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.subscribeButton.layer.cornerRadius = 10;
    self.subscribeButton.clipsToBounds = YES;
    [self.subscribeButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    //[self.subscribeButton setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    
    [self.subscribeButton setTitle:NSLocalizedString(@"subscribe_txt", nil) forState:UIControlStateNormal];
    self.location.alpha = 0.0;
    //40 150
    
    self.profilePicture.translatesAutoresizingMaskIntoConstraints = YES;
     // self.subscribeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.subscribeButton.imageView.frame.size.width, 0, self.subscribeButton.imageView.frame.size.width);
     //self.subscribeButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.subscribeButton.titleLabel.frame.size.width, 0, -self.subscribeButton.titleLabel.frame.size.width);
    
    //[self.view addSubview:self.profilePicture];
    
   
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

    
    self.location.text = [NSString stringWithFormat:@"%d %@", [user subscribers_count],NSLocalizedString(@"subscriptions_txt", nil)];
    self.displayName.text = [user display_name] != nil ? [user display_name] : [user usernameFormatted];
    if(user.Id == [[authHelper getUserId] intValue]){
       // self.subscribeButton.hidden = YES;
        self.location.hidden = YES;
    }else{
        self.location.hidden = NO;
        self.subscribeButton.hidden = NO;
    }
}

-(void)requestProfilePic{
    [self.user requestProfilePic:^(NSData *data){
        [self.profilePicture setImage:[UIImage imageWithData:data]];
    }];
}


-(void)checkSubscription{
    UserModel *deviceUser =[[UserModel alloc] initWithDeviceUser];
    self.subscribeModel = [[SubscribeModel alloc] initWithSubscriber:deviceUser withSubscribee:self.user];
    if (self.subscribeModel.isSubscriberLocal) {
        isSubscriber = YES;
        [self changeSubscribeUI];
    }else{
        isSubscriber = NO;
        [self changeSubscribeUI];
    }
}



-(void)showProfile{
    [self.parentController stopAllVideo];
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AbstractFeedViewController *profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"activity"];
    [profileController setViewMode:1];
    [profileController setIsDeviceUser:NO];
    [profileController setAnotherUser:self.user];
    [profileController hidePeekFirst];
  
    [self.view insertSubview:profileController.view atIndex:0];
    [self addChildViewController:profileController];
    CGRect frame = profileController.view.frame;
    frame.origin.y = -[UIHelper getScreenHeight];
    profileController.view.frame = frame;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = profileController.view.frame;
                         frame.origin.y = 0;
                         profileController.view.frame = frame;
                         CGRect frame2 = self.pageViewController.view.frame;
                         frame2.origin.y = [UIHelper getScreenHeight];
                         self.pageViewController.view.frame = frame2;
                     }
                     completion:^(BOOL finished){
                         CGRect frame2 = self.pageViewController.view.frame;
                         frame2.origin.y = 0;
                         self.pageViewController.view.frame = frame2;
                         [profileController.view removeFromSuperview];
                         [profileController layOutPeek];
                         [[ApplicationHelper getMainNavigationController] pushViewController:profileController animated:NO];
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
        //[self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
        [self.subscribeButton setTitle:NSLocalizedString(@"subscribe_txt", nil) forState:UIControlStateNormal];
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
