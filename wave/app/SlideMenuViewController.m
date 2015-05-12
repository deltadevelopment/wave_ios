//
//  SlideMenuViewController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "DrawerViewController.h"
#import "MainViewController.h"

#import "AppDelegate.h"
#import "UIHelper.h"
#import "BucketModel.h"
@interface SlideMenuViewController ()

@end
static int const DRAWER_SIZE = 280;
@implementation SlideMenuViewController{
    DrawerViewController *menuViewController;
    UINavigationController *mainViewController;
    NavigationControlViewController *root;
    NavigationControlViewController *oldRoot;
    UIStoryboard *storyboard ;
    bool drawerIsVisible;
    NSLayoutConstraint *rootViewHorisontalConstraint;
    NSLayoutConstraint *rootViewHorConstrant;
    NSLayoutConstraint *width;
    NSLayoutConstraint *height;
    NSLayoutConstraint *topConstraint;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    menuViewController = (DrawerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menuTableView"];
    mainViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"mainViewMenuNav"];
    [self addRootViewController:@"carousel"];
    
   //root = [[mainViewController viewControllers]objectAtIndex:0];

    
    
    //[root addViewController:self];

    //[mainViewController.menuItem setAction:@selector(test)];
    //[mainViewController.menuItem setTarget:self];
    CGRect frame = mainViewController.view.frame;
    frame.size.width = frame.size.width - 55;
    mainViewController.view.frame = frame;
    [self.mainView addSubview:mainViewController.view];
     //[view addSubview:button];
    [self addViewWithConstraints:mainViewController.view];
    [self.menuView addSubview:menuViewController.view];
    
    mainViewController.view.layer.masksToBounds = NO;
    mainViewController.view.layer.shadowOffset = CGSizeMake(-1, 0);
    mainViewController.view.layer.shadowRadius = 1;
    mainViewController.view.layer.shadowOpacity = 0.4;

  
    __weak typeof(self) weakSelf = self;
    menuViewController.onCellSelection =^(NSString *(storyboardId)){
        [weakSelf onCellSelection:storyboardId];
    };
    
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(buttonDragged:)];
    gesture.cancelsTouchesInView = NO;
    UITapGestureRecognizer *tapGr;
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGr.numberOfTapsRequired = 1;
    tapGr.cancelsTouchesInView = NO;
    [self.mainView addGestureRecognizer:tapGr];
    [self.mainView addGestureRecognizer:gesture];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
   
    // Do any additional setup after loading the view.    
}

-(void)addViewWithConstraints:(UIView *) view{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    /*
  rootViewHorConstrant = [NSLayoutConstraint constraintWithItem:self.mainView
                                                                            attribute:NSLayoutAttributeTrailing
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:view
                                                                            attribute:NSLayoutAttributeTrailing
                                                                           multiplier:1.0
                                                                             constant:0.0];
    [self.mainView addConstraint:rootViewHorConstrant];

    
    
    [self.mainView addConstraint:[NSLayoutConstraint constraintWithItem:self.mainView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0.0]];
     */
    
    topConstraint = [NSLayoutConstraint constraintWithItem:self.mainView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0];
    [self.mainView addConstraint:topConstraint];
    
    
    rootViewHorisontalConstraint = [NSLayoutConstraint constraintWithItem:self.mainView
                                                                                    attribute:NSLayoutAttributeLeading
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:view
                                                                                    attribute:NSLayoutAttributeLeading
                                                                                   multiplier:1.0
                                                                                     constant:0.0];
    
    
    [self.mainView addConstraint:rootViewHorisontalConstraint];
    
    width =[NSLayoutConstraint
                                constraintWithItem:view
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:self.mainView
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    
    height =[NSLayoutConstraint
                                 constraintWithItem:view
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:self.mainView
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    [self.mainView addConstraint:height];
    [self.mainView addConstraint:width];

    
    
}

-(void)handleTap:(UITapGestureRecognizer *) sender{
    if(drawerIsVisible){
        [root.view setUserInteractionEnabled:YES];
        [self fadeMainViewOut];
    }
}

-(void)addRootViewController:(NSString *) storyboardId{
    root = (NavigationControlViewController *)[storyboard instantiateViewControllerWithIdentifier:storyboardId];
    [root addViewController:self];
    [mainViewController setViewControllers:@[root] animated:NO];
    [self.mainView layoutIfNeeded];
    CGRect frame2 = root.view.frame;
    frame2.origin.y = 64;
    //frame2.size.height -=20;
    root.view.frame = frame2;
    
    [self.mainView layoutIfNeeded];
}


-(void)addBucketAsRoot:(NSString *) storyboardId withBucket:(BucketModel *)bucket{
    NSLog(@"ADding buket as root");
    oldRoot = root;
    root = (NavigationControlViewController *)[storyboard instantiateViewControllerWithIdentifier:storyboardId];
    [root setBucket:bucket];
    [root addViewController:self];
    [mainViewController setViewControllers:@[root] animated:NO];
    [self.mainView layoutIfNeeded];
    CGRect frame2 = root.view.frame;
    frame2.origin.y = 64;
    //frame2.size.height -=20;
    root.view.frame = frame2;
    
    [self.mainView layoutIfNeeded];
}

-(void)removeBucketAsRoot{
    root = oldRoot;
    [mainViewController setViewControllers:@[root] animated:NO];
    [self.mainView layoutIfNeeded];
    [self.mainView layoutIfNeeded];
    [root didGainFocus];
    
    //do it
}

-(void)onCellSelection:(NSString *) storyboardId
{
    //Naviger her
    [self addRootViewController:storyboardId];
    if(drawerIsVisible){
        [self fadeMainViewOut];
    }
   
}

-(void)fadeMainViewIn{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.horizontalSpace.constant += DRAWER_SIZE;
                         
                         CGRect frame = mainViewController.view.frame;
                         frame.size.width = frame.size.width +285;
                         width.constant += DRAWER_SIZE;
                         //height.constant -= 64;
                         //topConstraint.constant = 64;
                         //rootViewHorConstrant.constant -=DRAWER_SIZE;
                         //rootViewHorisontalConstraint.constant += DRAWER_SIZE;
                         mainViewController.view.frame = frame;
                         [self.mainView layoutIfNeeded];
                         [root.view layoutIfNeeded];
                         CGRect frame2 = root.view.frame;
                         frame2.origin.y = 64;
                         frame2.size.height -= 20;
                         root.view.frame = frame2;
                         [root setNeedsStatusBarAppearanceUpdate];
                        [self.mainView layoutIfNeeded];
                         
                       
                     }
                     completion:^(BOOL finished){
                     
                         
                         
                     }];
    
    drawerIsVisible = YES;
}

-(void)fadeMainViewOut{
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.horizontalSpace.constant -= DRAWER_SIZE;
                         CGRect frame = mainViewController.view.frame;
                         frame.size.width = frame.size.width -285;
                         mainViewController.view.frame = frame;
                         [self.mainView layoutIfNeeded];
                         CGRect frame2 = root.view.frame;
                         frame2.origin.y = 64;
                         root.view.frame = frame2;
                          width.constant -= DRAWER_SIZE;
                         
                         [root setNeedsStatusBarAppearanceUpdate];
                         [self.mainView layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                        
                     }];
    drawerIsVisible = NO;
}

-(void)showDrawer
{
    if(!drawerIsVisible){
        [self fadeMainViewIn];
       
        [root.view setUserInteractionEnabled:NO];
        
    }else{
        [self fadeMainViewOut];
        [root.view setUserInteractionEnabled:YES];
    }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonDragged:(UIPanGestureRecognizer *)gesture{
    UILabel *label = (UILabel *)gesture.view;
    if(drawerIsVisible){
       
        CGPoint translation = [gesture translationInView:label];
        if(translation.x < 0){
         
            [root.view setUserInteractionEnabled:YES];
            [self fadeMainViewOut];
        }
     
    }
    
    
    
    if(gesture.state == UIGestureRecognizerStateBegan){
       
        
    }
    else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        
        
    }
    else{
        
        
        [gesture setTranslation:CGPointZero inView:label];
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
