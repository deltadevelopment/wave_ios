//
//  CarouselController.m
//  wave
//
//  Created by Simen Lie on 30.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CarouselController.h"
#import "BucketController.h"
@interface CarouselController ()

@end

@implementation CarouselController{
    NSInteger currentPage;
    bool hasChangedCarouselElement;
    UIScrollView *scrollView;
    NavigationControlViewController *root;
    NavigationControlViewController *oldRoot;
    NSMutableArray *pages;
}

- (void)viewDidLoad {
    root = self;
    // Do any additional setup after loading the view.
    pages = [[NSMutableArray alloc] init];
    
    
    
    
    NSArray  *storyboardIds = @[@"activity",
                                @"pinnedView",
                                @"activity"];
    self.carouselObjects = [[NSMutableArray alloc] initWithArray:storyboardIds];
    [self addView:0];
    [self addView:1];
    [self addView:2];
    self.automaticallyAdjustsScrollViewInsets=NO;
   
    //_pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    AbstractFeedViewController *startingViewController = [self viewControllerAtIndex:0];
    self.currentController = startingViewController;
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -64);
    self.navigationController.navigationBar.translucent = NO;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    [self.pageViewController didMoveToParentViewController:self];
    
    for (UIView *v in self.pageViewController.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            scrollView = ((UIScrollView *)v);
            scrollView.delegate = self;
        }
    }
    
    self.carousel = [[Carousel alloc]initWithPages:3];
    [self.carousel addNavigationTitle:NSLocalizedString(@"profile_title", nil) withPageCount:0];
    [self.carousel addNavigationTitle:NSLocalizedString(@"activity_title", nil) withPageCount:1];
    [self.carousel addNavigationTitle:NSLocalizedString(@"discover_title", nil) withPageCount:2];
    
    self.navigationItem.titleView = [self.carousel getNavBar];
    [self.carousel updateCarousel:3 withCurrentPage:0];
    [super viewDidLoad];
    AvailabilityViewController *viewControllerX = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    FilterViewController *viewControllerY = (FilterViewController *)[self createViewControllerWithStoryboardId:@"filterView"];
    
    [self attachViews:viewControllerY withY:viewControllerX];
    self.startY = 64;
    [self getProgressIndicator].frame = CGRectMake(0, self.startY, 0, 4);
    [self.view addSubview:[self getProgressIndicator]];

}

-(void)viewDidLayoutSubviews{
    //[self.view insertSubview:[self getProgressIndicator] aboveSubview:self.pageViewController.view];
}

-(void)addView:(NSInteger) index{
    AbstractFeedViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:[self.carouselObjects objectAtIndex:index]];
    if(index == 0){
        [pageContentViewController setViewMode:0];
    }else {
        [pageContentViewController setViewMode:1];
        [pageContentViewController setIsDeviceUser:YES];
    }
    [pages addObject:pageContentViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   // [self updatePage:scrollView];
    [self.carousel animateTitles:scrollView.contentOffset.x];
    
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    
    NSUInteger index = ((AbstractFeedViewController*) viewController).pageIndex;
    [self.carousel backward:index];
    if ((index == 0) || (index == NSNotFound)) {
        return [self viewControllerAtIndex:[self.carouselObjects count]-1];
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((AbstractFeedViewController*) viewController).pageIndex;
    [self.carousel forward:index];

    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.carouselObjects count]) {
        return [self viewControllerAtIndex:0];
    }
    
    return [self viewControllerAtIndex:index];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.currentController = [pageViewController.viewControllers objectAtIndex:0];
    [self prepareCamera];
}


- (AbstractFeedViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.carouselObjects count] == 0) || (index >= [self.carouselObjects count])) {
        return nil;
    }
    
    AbstractFeedViewController *pageContentViewController = [pages objectAtIndex:index];
    [self viewControllerCallbacks:pageContentViewController];
   
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

-(void)viewControllerCallbacks:(AbstractFeedViewController *) viewController{
    __weak typeof(self) weakSelf = self;
    viewController.onExpand=^(BucketModel*(bucket)){
        [weakSelf changeToBucket:bucket];
    };
    
    viewController.onLockScreenToggle = ^{
        if(scrollView.scrollEnabled){
            scrollView.scrollEnabled = NO;
        }else{
            scrollView.scrollEnabled = YES;
        }
    };
    viewController.onProgression = ^(int(progression)){
        [weakSelf increaseProgress:progression];
    };
    viewController.onNetworkError = ^(UIView *(view)){
        [weakSelf addErrorMessage:view];
    };
    
    viewController.onNetworkErrorHide=^{
        [weakSelf hideError];
    };

}

-(void)changeToBucket:(BucketModel *) bucket{
    //[self addBucketAsRoot:@"bucketController2" withBucket:bucket];
    /*
    root = (NavigationControlViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"bucketController2"];
      [root setBucket:bucket];
    [self.view addSubview:root.view];
     */
    oldRoot = root;
    root = [[BucketController alloc] init];
    [root setBucket:bucket];
    [((BucketController *)root) setSuperCarousel:self];
       __weak typeof(self) weakSelf = self;
    root.onDespand = ^{
        [weakSelf removeBucketAsRoot];
    };
    //[root addViewController:self];
    
    //[self.navigationController setViewControllers:@[root] animated:NO];
    //[self.navigationController.view layoutIfNeeded];
    [self.navigationController pushViewController:root animated:NO];
}

-(void)removeBucketAsRoot{
    root = oldRoot;
    [self.navigationController setViewControllers:@[root] animated:NO];
    [self.navigationController.view layoutIfNeeded];
    [self didGainFocus];
}

-(void)didGainFocus{
    [self.currentController onFocusGained];
}

# pragma SuperButton callbacks
-(void)prepareCamera{
    [self.currentController prepareCamera:self.camera.view];
}

-(void)onMediaPosted:(BucketModel *)bucket{
    [self.currentController onMediaPosted:bucket];
}
-(void)onMediaPostedDrop:(DropModel *)drop{
    [self.currentController onMediaPostedDrop:drop];
}
-(void)onCameraClose{
    [self.currentController oncameraClose];
}
-(void)showCamera{
    [self.currentController onCameraReady];
}

-(void)onImageTaken:(UIImage *)image withText:(NSString *)text{
    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    [self.currentController onImageTaken:[GraphicsHelper imageByScalingAndCroppingForSize:size img:image] withText:text];
    //[[currentController view] setBackgroundColor:[UIColor colorWithPatternImage:]];
}

-(void)onVideoTaken:(NSData *)video withImage:(UIImage *)image withtext:(NSString *)text{
    [self.currentController onVideoTaken:video withImage:image withtext:text];
}

-(void)onCameraOpen{
    [super onCameraOpen];
    [self.currentController onCameraOpen];
}

-(void)onCancelTap{
    [super onCancelTap];
    [self.currentController onCancelTap];
}

@end
