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
@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    AuthHelper *authHelper;
    PeekViewController *peekViewController;
    ActivityViewController *activityController;
    float yPos;
    BOOL scrollDirection;
    UIScrollView *scrollView;
    int maxTop;
    int maxBottom;
    UIView *viewe;
    BOOL canDragTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [label setText:@"hey"];
    [label setTextColor:[UIColor redColor]];
    [self.view addSubview:label];
    self.profileBuckets = [self.storyboard instantiateViewControllerWithIdentifier:@"activity"];
    __weak typeof(self) weakSelf = self;
    self.profileBuckets.onTableViewDrag = ^(UIScrollView*(scrollView2)){
       // NSLog(@"scrollview %f", scrollView2.contentOffset.y);
        if (!canDragTable) {
            [scrollView2 setContentOffset:CGPointMake(0, 0)];
        }
       
        
        /*
        if (scrollView2.contentOffset.y < 0) {
            if (scrollView.contentOffset.y > 0) {
                [scrollView setScrollEnabled:YES];
            }
        }else{
            
        }
         */
        //NSLog(@"%f", scrollView.contentOffset.y);
        //[weakSelf trans:scrollView];
        /*
        NSLog(@"%f %f %f", scrollView.frame.origin.y, scrollView.frame.size.height, scrollView.contentOffset.y);
        
        static CGFloat previousOffset;
        CGRect frame = weakSelf.profileBuckets.view.frame;
        float decrementValue = previousOffset - scrollView.contentOffset.y;
        frame.origin.y -= -decrementValue;
        NSLog(@"DECREMENT value %f", decrementValue);
        previousOffset = scrollView.contentOffset.y;
        // [self.profileBuckets.tableView ]
        // self.view.frame = rect;
        
        //frame.origin.y = frame.origin.y - number;
        weakSelf.profileBuckets.view.frame = frame;
        */
        
    };

    [self.profileBuckets setSuperButton:self.superButton];
    [self.profileBuckets setViewMode:1];
    [self.profileBuckets setIsDeviceUser:YES];
    [self discovercallbacks];
    CGRect frame = self.profileBuckets.view.frame;
    frame.origin.y = ([UIHelper getScreenHeight]/2) - 32;
    
    self.profileBuckets.view.frame = frame;
    yPos = self.profileBuckets.view.frame.origin.y;
   // [self.profileBuckets.tableView setScrollEnabled:NO];
    //[self.view addSubview:self.profileBuckets.view];
 //   [self.profileBuckets.tableView setScrollEnabled:NO];
    
    //[self.profileBuckets.view addGestureRecognizer:peekDragGesture];
    
    // self.tableView = [[UITableView alloc] initWithFrame:CGRECtma]
    // Do any additional setup after loading the view.
 /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    peekViewController = (PeekViewController *)[storyboard instantiateViewControllerWithIdentifier:@"peekView"];
    activityController = [self.storyboard instantiateViewControllerWithIdentifier:@"activity"];
    [activityController setViewMode:1];
    [activityController setIsDeviceUser:YES];
    peekViewController.view.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);

    [peekViewController setActivityViewController:activityController]
        [peekViewController addBackgroundView];
    //[self.view addSubview:peekViewController.view];
    //[self.view insertSubview:peekViewController.view aboveSubview:blurEffectView];
    // peekViewController.view.backgroundColor = [UIColor clearColor];
    //[peekViewController updatePeekView:[bucket user]];
    
    
    //contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:peekViewController.view];
  */
    /*
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], 200)];
    [view setBackgroundColor:[UIColor redColor]];
    //[self.profileBuckets.tableView setBackgroundView:view];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + ([UIHelper getScreenHeight]/2) - 32);
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    [scrollView addSubview:view];
    [scrollView addSubview:self.profileBuckets.view];
     */
    
    [self.view addSubview:self.profileBuckets.view];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    [scrollView setContentSize:CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight] + ([UIHelper getScreenHeight]/2) - 32)];
    //[scrollView addSubview:self.profileBuckets.view];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    scrollView.delegate = self;
   
    
    //[self.view addSubview:scrollView];

    viewe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight] + ([UIHelper getScreenHeight]/2) - 32)];
    [viewe addSubview:self.profileBuckets.view];
    [self.view addSubview:viewe];
    UIPanGestureRecognizer *peekDragGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(peekViewVerticalMove:)];
    peekDragGesture.delegate = self;
    
    [viewe addGestureRecognizer:peekDragGesture];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)peekViewVerticalMove:(UIPanGestureRecognizer *)gesture
{
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    CGRect frame = viewe.frame;
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        
    }
    
    if (translation.y > 0) {
        //drar nedover
        NSLog(@"drar nedover %f", viewe.frame.origin.y);
        if (viewe.frame.origin.y < 0) {
            viewe.frame = CGRectMake(0, viewe.frame.origin.y + translation.y, [UIHelper getScreenWidth], viewe.frame.size.height);
             canDragTable = NO;
        }else{
            viewe.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], viewe.frame.size.height);
             canDragTable = YES;
        }
        
    }else if (translation.y < 0){
        //drar oppover
        NSLog(@"drar oppover");
        if (viewe.frame.origin.y > -302) {
            viewe.frame = CGRectMake(0, viewe.frame.origin.y + translation.y, [UIHelper getScreenWidth], viewe.frame.size.height);
             canDragTable = NO;
        }else{
            viewe.frame = CGRectMake(0, -302, [UIHelper getScreenWidth], viewe.frame.size.height);
            canDragTable = YES;
        }
       
        
    }
    else if (translation.y == 0){
        
    }
    
    /*
    float val = 0 - translation.y;
    NSLog(@"frame %f val %f", frame.origin.y, val);
    if (frame.origin.y < 0 - translation.y) {
        if (translation.y == 0) {
            
        }else if(frame.origin.y <= -300.0f - translation.y){
            NSLog(@"1");
            canDragTable = YES;
        }else{
            NSLog(@"2");
            
            viewe.frame = CGRectMake(0, viewe.frame.origin.y + translation.y, [UIHelper getScreenWidth], viewe.frame.size.height);
            canDragTable = NO;
        }
    }else{
         NSLog(@"3");
        canDragTable = YES;
    }*/
    if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        
    }
    [gesture setTranslation:CGPointZero inView:label];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y == 0.0f) {
       // [scrollView setScrollEnabled:NO];
    }
    if (scrollView.contentOffset.y == 301.5f) {
        [scrollView setScrollEnabled:NO];
    }
   // NSLog(@"croll %f", scrollView.contentOffset.y);
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //NSLog(@"did end");
}


-(void)trans:(UIScrollView *) scrollView{
    float offset = scrollView.contentOffset.y;
    if (offset > 0) {
        static CGFloat previousOffset;
        CGRect frame = self.profileBuckets.view.frame;
        float decrementValue = previousOffset - scrollView.contentOffset.y;
        //NSLog(@"decrementvalue %f", decrementValue);
        frame.origin.y -= -decrementValue;
        previousOffset = scrollView.contentOffset.y;
        self.profileBuckets.view.frame = frame;
    }
}

-(void)discovercallbacks{
    __weak typeof(self) weakSelf = self;
    self.profileBuckets.onExpand=^(BucketModel*(bucket)){
       // [weakSelf changeToBucket:bucket];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
