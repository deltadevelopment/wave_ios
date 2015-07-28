//
//  ProfileViewController.m
//  wave
//
//  Created by Simen Lie on 22.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProfileViewController.h"
#import "AuthHelper.h"
#import "PeekViewController.h"
#import "SettingsTableViewController.h"
#import "ConstraintHelper.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    AuthHelper *authHelper;
    UIBlurEffect *blurEffect;
    PeekViewController *peekViewController;
    ActivityViewController *activityController;
    UIView *profileWrapperScrollView;
    UIActivityIndicatorView *activityIndicator;
    bool isDeviceUser;
    bool isSubscriber;
    BOOL upWard;
    float scrollY;
    UIVisualEffectView *blurEffectView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSLog(@"the scale is %f", [[UIScreen mainScreen] scale]);
    authHelper = [[AuthHelper alloc] init];
    self.profileBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    self.profileBackgroundImage.clipsToBounds = YES;
    [self.profileBackgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:self.profileBackgroundImage];
    [self addBlur];
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth]/2 - (100/2), 30, 100, 100)];
    self.profilePicture.image = [UIImage imageNamed:@"user-icon-gray.png"];
    self.profilePicture.layer.cornerRadius = 50;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    [self.view setUserInteractionEnabled:YES];
    [self.view setBackgroundColor:[ColorHelper purpleColor]];
    
    float labelWidth = [UIHelper getScreenWidth] - 40;
    self.usernameLabel =[[UILabel alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth]/2 - (labelWidth/2), 146, labelWidth, 30)];
    [UIHelper applyThinLayoutOnLabel:self.usernameLabel withSize:20];
    self.usernameLabel.text = @"simenlie";
    self.usernameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.subscribeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //[self.subscribeButton setBackgroundColor:[UIColor redColor]];
    self.subscribeButton.frame = CGRectMake([UIHelper getScreenWidth]/2 - (170/2), ([UIHelper getScreenHeight]/2) - 32 - 90, 170, 40);
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
                                 CGRectMake([UIHelper getScreenWidth]/2 - (labelWidth/2), ([UIHelper getScreenHeight]/2) - 80, labelWidth, 30)];
    [UIHelper applyThinLayoutOnLabel:self.subscribersCountLabel withSize:17];
    //self.subscribersCountLabel.text = @"550 others already do";
    self.subscribersCountLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.usernameLabel];
    [self.view addSubview:self.subscribeButton];
    [self.view addSubview:self.subscribersCountLabel];
    [self.view addSubview:self.settingsButton];
    
    // [ConstraintHelper addConstraintsToButtonWithNoSize:parentView withButton:self.subscribeButton withPoint:CGPointMake(-86, 83) fromLeft:YES fromTop:NO];
    float yPosForButton = ([UIHelper getScreenHeight]/2) - 32 - 90;
  //  [ConstraintHelper addConstraintsToButtonWithNoSize:self.view withButton:self.subscribeButton withPoint:CGPointMake(-86, 143.5 +yPosForButton) fromLeft:YES fromTop:NO];
    
    [self AddSizeConstraintToButton:self.subscribeButton];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.profileBuckets = [mainStoryboard instantiateViewControllerWithIdentifier:@"activity"];
    
    NSLog(@"profileBuckets");
    __weak typeof(self) weakSelf = self;
    self.profileBuckets.onTableViewDrag = ^(UIScrollView*(scrollView)){
        //NSLog(@"content offset %f ", scrollView.contentOffset.y);
        scrollY = scrollView.contentOffset.y;
        if (!weakSelf.canDragTable) {
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    };
    [self.profileBuckets setViewMode:1];
    [self.profileBuckets setSuperButton:self.superButton];
    if (!self.isNotDeviceUser) {
        [self.profileBuckets setIsDeviceUser:YES];
    }
    else{
         [self.profileBuckets setIsDeviceUser:NO];
        [self.profileBuckets setAnotherUser:self.anotherUser];
    }

    [self discovercallbacks];
    
    //Sets the tableview to start at the middle of the screen
    CGRect frame = self.profileBuckets.view.frame;
    frame.size.height -= 64;
    self.profileBuckets.view.frame = frame;

    profileWrapperScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIHelper getScreenHeight]/2) - 32, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    [profileWrapperScrollView setUserInteractionEnabled:YES];
    [profileWrapperScrollView addSubview:self.profileBuckets.view];
    [profileWrapperScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:profileWrapperScrollView];
    
    /*
    self.profileBuckets.view.layer.masksToBounds = NO;
   // self.profileBuckets.view.layer.cornerRadius = 8;
    self.profileBuckets.view.layer.shadowOffset = CGSizeMake(0, -5);
    self.profileBuckets.view.layer.shadowRadius = 5;
    self.profileBuckets.view.layer.shadowOpacity = 0.5;
    self.profileBuckets.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.profileBuckets.view.bounds].CGPath;
    
    */
 
    
    //Drag gesture for profile and table view feed
    UIPanGestureRecognizer *profileDragGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragProfileVertical:)];
    profileDragGesture.delegate = self;
    [profileWrapperScrollView addGestureRecognizer:profileDragGesture];
    
    if(self.isDeviceUser){
        UserModel *userModel =[[UserModel alloc] initWithDeviceUser:^(UserModel *user){
            [self updateText:user];
        } onError:^(NSError *error){}];
    }else{
        [self updateText:[self anotherUser]];
    }
    [self checkScreen];
    
    
    [self.profileBuckets.view setBackgroundColor:[UIColor clearColor]];
    self.profileBuckets.refreshControl.backgroundColor = [UIColor clearColor];
    [self vibrancy];
}

-(void)vibrancy{
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    self.vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [self.vibrancyEffectView setFrame:self.view.bounds];
    
    // Label for vibrant text
    UILabel *vibrantLabel = [[UILabel alloc] init];
    if (self.profileBuckets.isDeviceUser) {
        
        [vibrantLabel setText:NSLocalizedString(@"profile_none_txt", nil)];
    }else{
        
        [vibrantLabel setText:[NSString stringWithFormat:@"%@ %@", self.anotherUser.username, NSLocalizedString(@"profile_none_other_txt", nil)]];
    }
    // [vibrantLabel setMinimumScaleFactor:12.0/17.0];
    [vibrantLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [vibrantLabel sizeToFit];
    //[vibrantLabel setCenter: self.center];
    [vibrantLabel setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    
    // Add label to the vibrancy view
    [[self.vibrancyEffectView contentView] addSubview:vibrantLabel];
    
    // Add the vibrancy view to the blur view
    [[blurEffectView contentView] addSubview:self.vibrancyEffectView];
}


-(void)addBlur{
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    //blurEffectView.alpha = 0.9;
    blurEffectView.alpha = 1.0;
    [self.view addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)updateText:(UserModel *) user
{
    self.user = user;
    [self.user requestProfilePic:^(NSData *data){
        [self.profilePicture setImage:[UIImage imageWithData:data]];
        [self.profileBackgroundImage setImage:[UIImage imageWithData:data]];
        
    }];
    [self updatePeekView:user];
    
}

-(void)showSettings{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SettingsTableViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"settings"];
    //[superController.navigationController presentViewController:vc animated:YES completion:nil];
    //[superController.navigationController pushViewController:vc animated:YES];
    
    [[ApplicationHelper getMainNavigationController] pushViewController:vc animated:YES];
    // [self.view.window.rootViewController presentViewController:viewController animated:YES completion:nil];
    
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)dragProfileVertical:(UIPanGestureRecognizer *)gesture
{
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    CGRect frame = profileWrapperScrollView.frame;
    CGPoint velocity = [gesture velocityInView:label];
    if(gesture.state == UIGestureRecognizerStateBegan){
        
    }
    if (translation.y > 0) {
        //dragging downwards
        //upWard = NO;
        NSLog(@"frame %f", frame.origin.y);
        if (frame.origin.y < ([UIHelper getScreenHeight]/2) - 32) {
           // NSLog(@"%f", frame.origin.y);
            
            if (scrollY > 0){
                
            }else{
                frame = CGRectMake(0, frame.origin.y + translation.y, [UIHelper getScreenWidth], frame.size.height);
                self.canDragTable = NO;
            }
            
        }else{
            frame = CGRectMake(0, ([UIHelper getScreenHeight]/2) - 32, [UIHelper getScreenWidth], frame.size.height);
            self.canDragTable = YES;
        }
        
    }else if (translation.y < 0){
        //dragging upwards
        
        NSLog(@"frame %f", frame.origin.y);
        if (frame.origin.y > 0) {
            if (scrollY < 0) {
                NSLog(@"less than zero");
            }else{
                frame = CGRectMake(0, frame.origin.y + translation.y, [UIHelper getScreenWidth], frame.size.height);
                self.canDragTable = NO;
            }
        }else{
            frame = CGRectMake(0, 0, [UIHelper getScreenWidth], frame.size.height);
            self.canDragTable = YES;
        }
    }
    else if (translation.y == 0){
        
    }
    profileWrapperScrollView.frame = frame;
    [gesture setTranslation:CGPointZero inView:label];
    
    if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint velocity = [gesture velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.05 * slideMult; // Increase for more slide
        CGPoint finalPoint = CGPointMake(gesture.view.center.x,
                                         gesture.view.center.y + (velocity.y * slideFactor));
        //finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        float top = finalPoint.y - (profileWrapperScrollView.frame.size.height/2);
        if (top < 0) {
            NSLog(@"less than zero");
            finalPoint = CGPointMake(finalPoint.x, profileWrapperScrollView.frame.size.height/2);
        }
            if (top == 269.500000) {
               finalPoint = CGPointMake(finalPoint.x, [UIHelper getScreenHeight] - 32);
            }
        
        NSLog(@"the top is %f and the other is %f", top, ([UIHelper getScreenHeight]/2) - 32);
       // NSLog(@"velocity is %f", velocity.y);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            NSLog(@"anm");
            gesture.view.center = finalPoint;
        } completion:nil];
        
    }
}

-(void)animateWrapperToZero:(BucketModel *) bucket{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame =  profileWrapperScrollView.frame;
                         frame.origin.y = 0;
                         profileWrapperScrollView.frame = frame;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         [self changeToBucket:bucket];
                     }];
}

-(void)discovercallbacks{
    __weak typeof(self) weakSelf = self;
    NSLog(@"DETTE ER HER");
    self.profileBuckets.onExpand=^(BucketModel*(bucket)){
        NSLog(@"zerocal");
        [weakSelf animateWrapperToZero:bucket];
        //  [weakSelf changeToBucket:bucket];
    };
    self.profileBuckets.onFeedRefreshed = ^(bool (hasElements)){
        if (hasElements) {
            NSLog(@"hiding");
        };
        
        weakSelf.vibrancyEffectView.hidden = hasElements;
    };
    
    /*
     self.discover.onLockScreenToggle = ^{
     if(scrollView.scrollEnabled){
     scrollView.scrollEnabled = NO;
     }else{
     scrollView.scrollEnabled = YES;
     }
     };
     self.discover.onProgression = ^(int(progression)){
     [weakSelf increaseProgress:progression];
     };
     self.discover.onNetworkError = ^(UIView *(view)){
     [weakSelf addErrorMessage:view];
     };
     
     self.discover.onNetworkErrorHide=^{
     [weakSelf hideError];
     };
     */
}

-(void)changeToBucket:(BucketModel *) bucket{
    //Same as onExpand in activity
    BucketController *bucketController = [[BucketController alloc] init];
    
    [bucketController setBucket:bucket];
    
    //[((BucketController *)root) setSuperCarousel:self];
    __weak typeof(self) weakSelf = self;
    bucketController.onDespand = ^{
        [weakSelf removeBucketAsRoot];
    };
    //[root addViewController:self];
    
    //[self.navigationController setViewControllers:@[root] animated:NO];
    //[self.navigationController.view layoutIfNeeded];
    [self.navigationController pushViewController:bucketController animated:NO];
}

-(void)removeBucketAsRoot{
    //root = oldRoot;
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController.view layoutIfNeeded];
    //[self didGainFocus];
    [self.profileBuckets onFocusGained];
}
/*
- (void)peekViewVerticalMove:(UIPanGestureRecognizer *)gesture
{
    NSLog(@"peeek drag");
        UILabel *label = (UILabel *)gesture.view;
        CGPoint translation = [gesture translationInView:label];
        CGRect frame = self.profileBuckets.view.frame;
        
        if(gesture.state == UIGestureRecognizerStateBegan){
           
        }
        if(frame.origin.y >= 0 - translation.y && frame.origin.y < (([UIHelper getScreenHeight]/2)-32) - translation.y){
            self.profileBuckets.view.frame = CGRectMake(0, self.profileBuckets.view.frame.origin.y + (translation.y*1.4), [UIHelper getScreenWidth], self.profileBuckets.view.frame.size.height);
        }
        else {
            [self.profileBuckets.tableView setScrollEnabled:YES];
        }
        if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
        {
           
        }
        [gesture setTranslation:CGPointZero inView:label];
}
*/
-(void)initialize{
   // http://w4ve.herokuapp.com/user/2/buckets
    authHelper = [[AuthHelper alloc] init];
    NSString *url = [NSString stringWithFormat:@"user/%@/buckets", [authHelper getUserId]];
    //self.feedModel = [[FeedModel alloc] initWithURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"user id %d", self.user.Id);
    if(isSubscriber){
        /*
         [self.subscribeButton setTitle:NSLocalizedString(@"unsubscribe_txt", nil) forState:UIControlStateNormal];
         self.subscribeButton.imageView.frame = CGRectMake(0, 0, 40, 40);
         [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
         [[self.subscribeButton imageView] setTintColor:[UIColor whiteColor]];
         [self.subscribeButton setTintColor:[UIColor whiteColor]];
         //top left bottom right
         [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 140)];
         [self.subscribeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
         [self.subscribeButton sizeToFit];
         */
        [self.subscribeButton setTintColor:[UIColor whiteColor]];
        NSLog(@"User id %d auth helper %d", self.user.Id, [[authHelper getUserId] intValue]);
        if ([self.user Id] == [[authHelper getUserId] intValue]) {
            [self.subscribeButton setTitle:NSLocalizedString(@"subscriptions_button_txt", nil) forState:UIControlStateNormal];
        }else{
            [self.subscribeButton setTitle:NSLocalizedString(@"unsubscribe_txt", nil) forState:UIControlStateNormal];
        }
        [[self.subscribeButton layer] setBorderColor:[ColorHelper magenta].CGColor];
        NSLog(@"sub");
        
    }else{
        NSLog(@"subbb");
        if ([self.user Id] ==[[authHelper getUserId] intValue]) {
            [[self.subscribeButton layer] setBorderColor:[ColorHelper magenta].CGColor];
        }else{
            [[self.subscribeButton layer] setBorderColor:[ColorHelper whiteColor].CGColor];
        }
        //[self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
        [self.subscribeButton setTitle:NSLocalizedString(@"subscribe_txt", nil) forState:UIControlStateNormal];
        [self removeInsetsFromButton];
    }
    
}

-(void)removeInsetsFromButton{
    [self.subscribeButton setImage: nil forState:UIControlStateNormal];
    [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.subscribeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
   // [self.subscribeButton sizeToFit];
}

-(void)updatePeekView:(UserModel *) user{
    self.user = user;
    UserModel *deviceUser =[[UserModel alloc] initWithDeviceUser];
    self.subscribeModel = [[SubscribeModel alloc] initWithSubscriber:deviceUser withSubscribee:self.user];
    if(user.Id == [[authHelper getUserId] intValue]){
        isDeviceUser = YES;
        //self.subscribeButton.hidden = YES;
        self.settingsButton.hidden = NO;
        //self.subscribersCountLabel.hidden = YES;
        [self.subscribeButton setTitle:NSLocalizedString(@"subscriptions_button_txt", nil) forState:UIControlStateNormal];
        
        //[self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
        [[self.subscribeButton layer] setBorderColor:[ColorHelper magenta].CGColor];
    }else{
        self.subscribersCountLabel.hidden = NO;
        self.subscribeButton.hidden = NO;
        self.settingsButton.hidden = YES;
        isDeviceUser = NO;
    }
    if(user.Id == [[authHelper getUserId] intValue]){
        self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d %@", user.subscribers_count, NSLocalizedString(@"subscriptions_profile_txt", nil)];
        
    }else{
        if (user.subscribers_count == 0) {
            [self.subscribersCountLabel setHidden:YES];
        }else{
            if (user.subscribers_count == 1) {
                if (self.subscribeModel.isSubscriberLocal) {
                    //Du subscriber, det vil si at det skal sta du gjor det
                    //self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d %@", user.subscribers_count, NSLocalizedString(@"subscriptions_when_single_you_txt", nil)];
                    self.subscribersCountLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"subscriptions_when_single_you_txt", nil)];
                }else{
                    self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d %@", user.subscribers_count, NSLocalizedString(@"subscriptions_single_txt", nil)];
                }
                
            }
            else{
                if (self.subscribeModel.isSubscriberLocal) {
                    if (user.subscribers_count == 2) {
                        self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d %@", user.subscribers_count - 1, NSLocalizedString(@"subscriptions_when_single_txt", nil)];
                    }else{
                        self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d %@", user.subscribers_count - 1, NSLocalizedString(@"subscriptions_when_txt", nil)];
                    }
                    
                }else{
                 self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d %@", user.subscribers_count, NSLocalizedString(@"subscriptions_txt", nil)];
                }
               
            }
            [self.subscribersCountLabel setHidden:NO];
        }
    }
    self.usernameLabel.text = user.usernameFormatted;
    [self checkSubscription];

    
    
    //self.subscribersCountLabel.text = [NSString stringWithFormat:@"%d %@", user.subscribers_count, NSLocalizedString(@"subscriptions_txt", nil)];
    self.usernameLabel.text = [user display_name] != nil ? [user display_name] : [user usernameFormatted];
}

-(void)initActivityIndicator{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.subscribeButton addSubview:activityIndicator];
    
    activityIndicator.center = CGPointMake(self.subscribeButton.frame.size.width / 2, self.subscribeButton.frame.size.height / 2);
    activityIndicator.hidden = NO;
    activityIndicator.hidesWhenStopped = YES;
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
        //Sea[[vc viewControllers] objectAtIndex:0];
        
        [vc.navigationBar setTintColor:[ColorHelper purpleColor]];
        [vc.navigationBar setBackgroundColor:[ColorHelper purpleColor]];
        [vc.navigationBar setBarTintColor:[ColorHelper purpleColor]];
        //[[ApplicationHelper getMainNavigationController] pushViewController:vc animated:YES];
        [[ApplicationHelper getMainNavigationController] presentViewController:vc animated:YES completion:nil];
    }
}


-(void)checkScreen{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        NSLog(@"screensize is %f", screenSize.height);
        if (screenSize.height > 667.0f) {
            //iphone 6 plus
        }
        else if (screenSize.height > 568.0f) {
            //iphone 6
        }
        else if (screenSize.height > 480.0f) {
            /*iPhone 5 stuff here.*/
            float labelWidth = [UIHelper getScreenWidth] - 40;
            self.profilePicture.frame = CGRectMake([UIHelper getScreenWidth]/2 - (80/2), 30, 80, 80);
            self.usernameLabel.frame = CGRectMake([UIHelper getScreenWidth]/2 - (labelWidth/2), 120, labelWidth, 30);
            self.profilePicture.layer.cornerRadius = 40;
        } else {
            /*iPhone Classic stuff here.*/
        }
    } else {
        /*Do iPad stuff here.*/
    }
}
-(void)viewDidAppear:(BOOL)animated{
    if(self.isDeviceUser){
        UserModel *userModel =[[UserModel alloc] initWithDeviceUser:^(UserModel *user){
            [self updateText:user];
        } onError:^(NSError *error){}];
    }else{
        [self updateText:[self anotherUser]];
    }
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
