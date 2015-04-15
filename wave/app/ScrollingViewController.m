//
//  ScrollingViewController.m
//  wave
//
//  Created by Simen Lie on 15/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ScrollingViewController.h"
#import "UIHelper.h"
@interface ScrollingViewController ()

@end

@implementation ScrollingViewController{
    UIScrollView *Scroller;
    CGRect ViewSize;
    int PageCount;
     NSInteger currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    PageCount = 0;
    int navigationHeight = self.navigationController.navigationBar.frame.size.height;
    Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navigationHeight, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    Scroller.backgroundColor = [UIColor clearColor];
    Scroller.pagingEnabled = YES;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    Scroller.delegate = self;
    
    ViewSize = Scroller.bounds;
    
    [self addImage:@"test1.jpg"];


    [self addImage:@"test2.jpg"];
    

    [self addImage:@"miranda-kerr.jpg"];
    
    [self.view addSubview:Scroller];
}

-(void)viewDidAppear:(BOOL)animated{
    self.view.userInteractionEnabled = YES;
    Scroller.userInteractionEnabled = YES;
}

-(void)loadMoreImages{
    [self addImage:@"test2.jpg"];
}

-(BOOL)shouldGetMoreImages{
    int temp = (PageCount) /2;
    NSLog(@"Current page: %ld PageCount %d temp: %d", (long)currentPage, PageCount, temp);
    if(currentPage > temp){
        return YES;
    }
    return NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    //NSLog(@"%ld",(long)page);
    if (previousPage != page) {
        previousPage = page;
        currentPage = page;
        
       // NSLog(@"%ld",(long)page);
        if([self shouldGetMoreImages]){
           NSLog(@"adding images");
            [self addImage:@"test1.jpg"];
            [self addImage:@"test2.jpg"];
            [self addImage:@"miranda-kerr.jpg"];
        }
        /* Page did change */
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
   
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

}


-(void)addImage:(NSString *) name
{
    PageCount +=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    UIImageView *ImgView = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView setImage:[UIImage imageNamed:name]];
    [Scroller addSubview:ImgView];
    
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
