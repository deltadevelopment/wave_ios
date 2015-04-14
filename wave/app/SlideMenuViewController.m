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

@implementation SlideMenuViewController{
    MenuTableViewController *menuViewController;
    UINavigationController *mainViewController;
    UIStoryboard *storyboard ;
    bool drawerIsVisible;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    menuViewController = (MenuTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"menuTableView"];
    mainViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"mainViewMenuNav"];
    TestSuperViewController *root = [[mainViewController viewControllers]objectAtIndex:0];
    [root addViewController:self];

    //[mainViewController.menuItem setAction:@selector(test)];
    //[mainViewController.menuItem setTarget:self];
    [self.mainView addSubview:mainViewController.view];
    [self.menuView addSubview:menuViewController.view];
    
    mainViewController.view.layer.masksToBounds = NO;
    mainViewController.view.layer.shadowOffset = CGSizeMake(-5, 0);
    mainViewController.view.layer.shadowRadius = 5;
    mainViewController.view.layer.shadowOpacity = 0.4;
    __weak typeof(self) weakSelf = self;
    menuViewController.onCellSelection =^(NSString *(storyboardId)){
        [weakSelf onCellSelection:storyboardId];
    };
    
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(buttonDragged:)];
    [self.mainView addGestureRecognizer:gesture];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
   
    // Do any additional setup after loading the view.
}

-(void)onCellSelection:(NSString *) storyboardId
{
    //Naviger her
    
    TestSuperViewController *test = (TestSuperViewController *)[storyboard instantiateViewControllerWithIdentifier:storyboardId];
    [test addViewController:self];
    [mainViewController setViewControllers:@[test] animated:NO];
    [self.view layoutIfNeeded];
    [self fadeMainViewOut];

}

-(void)fadeMainViewIn{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.horizontalSpace.constant += 200;
                         [self.view layoutIfNeeded];
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
                         self.horizontalSpace.constant -= 200;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
     drawerIsVisible = NO;
}

-(void)showDrawer
{
    if(!drawerIsVisible){
        [self fadeMainViewIn];
        
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
