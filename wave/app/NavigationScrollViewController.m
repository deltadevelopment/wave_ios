//
//  NavigationScrollViewController.m
//  wave
//
//  Created by Simen Lie on 15/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "NavigationScrollViewController.h"
#import "UIHelper.h"
#import "InnerShadowView.h"
#import "AvailabilityViewController.h"

@interface NavigationScrollViewController ()

@end

@implementation NavigationScrollViewController{
    UIScrollView *Scroller;
    CGRect ViewSize;
    int PageCount;
    NSInteger currentPage;
    UIStoryboard *storyboard;
    NSMutableArray *controllers;
    NSMutableArray *carousel;
    UILabel *navbarTitle;
     UILabel *navbarTitle2;
    UIView *view;
    float navBarDefaultY;
     float navBarDefaultY2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AvailabilityViewController *viewControllerX = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    [self attachViews:viewControllerX withY:nil];

    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    controllers = [[NSMutableArray alloc] init];
    carousel = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets=NO;
    PageCount = 0;
    Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    Scroller.backgroundColor = [UIColor clearColor];
    Scroller.pagingEnabled = YES;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    Scroller.delegate = self;
    
    ViewSize = Scroller.bounds;
    [self addView:@"second"];
    [self addView:@"second"];
    //[self addView:@"storyId"];
    [self.view addSubview:Scroller];
    [self addCarouselCircles];
    /*
    self.menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                  target:self
                                                                  action:@selector(menuItemSelected)];
    [self.navigationItem setLeftBarButtonItem:self.menuItem];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
 
*/
    // Do any additional setup after loading the view.
    currentPage = 0;
    for(int index = 0;index < PageCount; index++){
        UILabel *label =[carousel objectAtIndex:index];
        if(currentPage == index){
            
            label.backgroundColor =[UIColor colorWithRed:0.753 green:0.455 blue:0.808 alpha:1];
        }else{
            label.backgroundColor =[UIColor colorWithRed:0.357 green:0.125 blue:0.459 alpha:1];
        }
        
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self checkPage:scrollView];
    NSLog(@"test: %f", scrollView.contentOffset.x);
    [self slideNavTitle:scrollView.contentOffset.x withTitleLabel:navbarTitle withDefaultFloat:navBarDefaultY];
    [self slideNavTitle:scrollView.contentOffset.x withTitleLabel:navbarTitle2 withDefaultFloat:navBarDefaultY2];
    if(navbarTitle.frame.origin.x < navBarDefaultY){
        float alpha =scrollView.contentOffset.x/100;
        navbarTitle.alpha = 1.0 - alpha;
    }
    if(navbarTitle2.frame.origin.x > navBarDefaultY){
        float alpha =(scrollView.contentOffset.x - 375)/100;
        NSLog(@"ALPHA____ %f", alpha);
        navbarTitle2.alpha = 1.0 - ABS(alpha);
    }

}

-(void)slideNavTitle:(float)value withTitleLabel:(UILabel *) label withDefaultFloat:(float)fval
{
    CGRect frame = label.frame;
    frame.origin.x = fval - value;
    label.frame = frame;
 

}

-(void)checkPage:(UIScrollView *)scrollView{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    //NSLog(@"%ld",(long)page);
    if (previousPage != page) {
        previousPage = page;
        currentPage = page;
        for(int index = 0;index < PageCount; index++){
            UILabel *label =[carousel objectAtIndex:index];
            if(currentPage == index){
                label.backgroundColor =[UIColor colorWithRed:0.753 green:0.455 blue:0.808 alpha:1];
            }else{
                label.backgroundColor =[UIColor colorWithRed:0.357 green:0.125 blue:0.459 alpha:1];
            }
            
        }
        
        
    }
}

-(void)addCarouselCircles{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    //view.backgroundColor = [UIColor redColor];
    view.clipsToBounds = YES;
   
   
    //[self fade:view withLabel:nil];
    
    
    navbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 34)];
    [navbarTitle  setTextAlignment:NSTextAlignmentCenter];
    [UIHelper applyLayoutOnLabel:navbarTitle ];
    navbarTitle .text = @"Activity";
    [view addSubview:navbarTitle];
     //[self fade:view withLabel:navbarTitle];
    navBarDefaultY = navbarTitle.frame.origin.x;
    
    navbarTitle2 = [[UILabel alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth], 0, 250, 34)];
    [navbarTitle2  setTextAlignment:NSTextAlignmentCenter];
    [UIHelper applyLayoutOnLabel:navbarTitle2 ];
    navbarTitle2 .text = @"Discover";
    [view addSubview:navbarTitle2];
    //[self fade:view withLabel:navbarTitle];
    navBarDefaultY2 = navbarTitle2.frame.origin.x;
    
    
    UIView *circles = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 10)];
    //circles.backgroundColor = [UIColor brownColor];
    //[circles setCenter:view.center];
    [circles setCenter:CGPointMake(view.frame.size.width / 2, view.frame.size.height - 10)];
    [view addSubview:circles];
    
    
    
    UILabel *circleOne = [self createCircle:0];
    UILabel *circleTwo = [self createCircle:9];
    UILabel *circleThree = [self createCircle:18];
    [carousel addObject:circleOne];
    [carousel addObject:circleTwo];
    [carousel addObject:circleThree];
    
    [circles addSubview:circleOne];
    [circles addSubview:circleTwo];
    [circles addSubview:circleThree];
    self.navigationItem.titleView = view;
}


-(UILabel *)createCircle:(float) xPos{
    UILabel *circle = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, 6, 6)];
    circle.backgroundColor = [UIColor colorWithRed:0.357 green:0.125 blue:0.459 alpha:1];
    circle.layer.cornerRadius = 3;
    circle.clipsToBounds = YES;
    return circle;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}


-(void)addView:(NSString *) name
{
    
    PageCount +=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    
    UIViewController *mainViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:name];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
