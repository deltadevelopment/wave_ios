//
//  NavigationScrollViewController.m
//  wave
//
//  Created by Simen Lie on 15/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "NavigationScrollViewController.h"
#import "UIHelper.h"
#import "AvailabilityViewController.h"
#import "AbstractFeedViewController.h"
#import "Carousel.h"
#import "FilterViewController.h"
@interface NavigationScrollViewController ()

@end

@implementation NavigationScrollViewController{
    UIScrollView *Scroller;
    CGRect ViewSize;
    int PageCount;
    NSInteger currentPage;
    UIStoryboard *storyboard;
    NSMutableArray *controllers;
    AbstractFeedViewController *currentController;
    Carousel *carousel;
}

- (void)viewDidLoad {
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    controllers = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets=NO;
    PageCount = 0;
    Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    Scroller.backgroundColor = [UIColor clearColor];
    Scroller.pagingEnabled = YES;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    Scroller.delegate = self;
    ViewSize = Scroller.bounds;

    carousel = [[Carousel alloc]initWithPages:3];
    [self addView:@"activity" withTitle:@"Activity"];
    [self addView:@"activity" withTitle:@"Discover"];
    [self addView:@"activity" withTitle:@"Pinned"];
    self.navigationItem.titleView = [carousel getNavBar];
    
    currentController = [controllers objectAtIndex:0];
    [self.view addSubview:Scroller];
    [super viewDidLoad];
    AvailabilityViewController *viewControllerX = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    FilterViewController *viewControllerY = (FilterViewController *)[self createViewControllerWithStoryboardId:@"filterView"];

    [self attachViews:viewControllerY withY:viewControllerX];

    currentPage = 0;
    [carousel updateCarousel:PageCount withCurrentPage:currentPage];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updatePage:scrollView];
    //Animate Navigtion bar titles with scroll view
    [carousel animateTitles:scrollView.contentOffset.x];
}


-(void)updatePage:(UIScrollView *)scrollView{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        previousPage = page;
        currentPage = page;
        [carousel updateCarousel:PageCount withCurrentPage:currentPage];
        NSLog(@"CONTROLLEr: %ld", (long)currentPage);
        currentController = [controllers objectAtIndex:currentPage];
        [self prepareCamera];
    }
}

-(void)addView:(NSString *) name withTitle:(NSString *) title
{
    [carousel addNavigationTitle:title withPageCount:PageCount];
    PageCount +=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    
    AbstractFeedViewController *mainViewController = (AbstractFeedViewController *)[storyboard instantiateViewControllerWithIdentifier:name];
    UIView *View = [[UIView alloc] initWithFrame:ViewSize];
    CGRect frame = mainViewController.view.frame;
    frame.size.height = frame.size.height -44;
    
    mainViewController.view.frame = frame;
    
    [View addSubview:mainViewController.view];
    [Scroller addSubview:View];
    [controllers addObject:mainViewController];
    [Scroller layoutIfNeeded];
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma SuperButton callbacks
-(void)prepareCamera{
   
    [currentController prepareCamera:self.camera.view];
}

-(void)onCameraClose{
    [currentController oncameraClose];
}
-(void)showCamera{
    [currentController onCameraReady];
}


-(void)onImageTaken:(UIImage *)image{
  CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    
    [currentController onImageTaken:[self.camera imageByScalingAndCroppingForSize:size img:image]];
  //[[currentController view] setBackgroundColor:[UIColor colorWithPatternImage:]];
}

-(void)onCameraOpen{
    [super onCameraOpen];
    [currentController onCameraOpen];
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
