//
//  SlideMenuViewController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "MenuTableViewController.h"
#import "MainViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
@interface SlideMenuViewController ()

@end
static int const DRAWER_SIZE = 300;
@implementation SlideMenuViewController{
    MenuTableViewController *menuViewController;
    UINavigationController *mainViewController;
    TestSuperViewController *root;
    UIStoryboard *storyboard ;
    bool drawerIsVisible;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    menuViewController = (MenuTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menuTableView"];
    mainViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"mainViewMenuNav"];
   root = [[mainViewController viewControllers]objectAtIndex:0];

    
    
    [root addViewController:self];

    //[mainViewController.menuItem setAction:@selector(test)];
    //[mainViewController.menuItem setTarget:self];
    CGRect frame = mainViewController.view.frame;
    frame.size.width = frame.size.width - 55;
    mainViewController.view.frame = frame;
    [self.mainView addSubview:mainViewController.view];
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
    UITapGestureRecognizer *tapGr;
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGr.numberOfTapsRequired = 1;
    [self.mainView addGestureRecognizer:tapGr];
    [self.mainView addGestureRecognizer:gesture];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
   
    // Do any additional setup after loading the view.
}

-(void)handleTap:(UITapGestureRecognizer *) sender{
    if(drawerIsVisible){
        [root.view setUserInteractionEnabled:YES];
        [self fadeMainViewOut];
    }
}

-(void)onCellSelection:(NSString *) storyboardId
{
    //Naviger her
    
    root = (TestSuperViewController *)[storyboard instantiateViewControllerWithIdentifier:storyboardId];
    [root addViewController:self];
    [mainViewController setViewControllers:@[root] animated:NO];
    [self.mainView layoutIfNeeded];
    CGRect frame2 = root.view.frame;
    frame2.origin.y = 64;
    root.view.frame = frame2;
    [self.mainView layoutIfNeeded];
    [self fadeMainViewOut];
}

-(void)fadeMainViewIn{
    NSLog(@"fading in");
   
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
  
    
    NSLog(@"test : %f", root.view.frame.origin.y);
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.horizontalSpace.constant += DRAWER_SIZE;
                         CGRect frame = mainViewController.view.frame;
                         frame.size.width = frame.size.width +285;
                         mainViewController.view.frame = frame;
                              [self.mainView layoutIfNeeded];
                         CGRect frame2 = root.view.frame;
                         frame2.origin.y = 64;
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
