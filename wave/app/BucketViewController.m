//
//  BucketViewController.m
//  wave
//
//  Created by Simen Lie on 27.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "BucketViewController.h"
#import "AvailabilityViewController.h"
#import "FilterViewController.h"
#import "PeekViewController.h"
@interface BucketViewController ()

@end

@implementation BucketViewController{
    UIView *cameraView;
    UIScrollView *Scroller;
    CGRect ViewSize;
    int PageCount;
    NSInteger currentPage;
    UIStoryboard *storyboard;
    PeekViewController *peekViewController;
    NSLayoutConstraint *topConstraint;
    UIVisualEffectView  *blurEffectView;
}

- (void)viewDidLoad {
    [self addImageScroller];
    [super viewDidLoad];
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // Do any additional setup after loading the view.
    AvailabilityViewController *viewControllerX = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    FilterViewController *viewControllerY = (FilterViewController *)[self createViewControllerWithStoryboardId:@"filterView"];
    
    [self attachViews:viewControllerY withY:viewControllerX];
    UITapGestureRecognizer *despandBucketGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(despandBucket)];
    despandBucketGesture.numberOfTapsRequired = 2;
    despandBucketGesture.numberOfTouchesRequired = 1;
    despandBucketGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:despandBucketGesture];
    [self attachGUI];
    [self.view insertSubview:self.topBar aboveSubview:Scroller];
    [self addPeekView];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(peekViewDrag:)]];
    [self animateElementsIn];
    
}

-(void)animateElementsIn{
  
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.dropsAmount.alpha = 0.9;
                         self.viewsAmount.alpha = 0.9;
                         self.dropsIcon.alpha = 0.6;
                         self.viewsIcon.alpha = 0.6;
                     }
                     completion:nil];
}

-(void)addImageScroller{
    self.automaticallyAdjustsScrollViewInsets=NO;
    PageCount = 0;
    int navigationHeight = self.navigationController.navigationBar.frame.size.height;
    Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -32, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    Scroller.backgroundColor = [UIColor clearColor];
    Scroller.pagingEnabled = YES;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    Scroller.delegate = self;
    
    ViewSize = Scroller.bounds;
    
    [self addImage:@"169.jpg"];
    [self addImage:@"test2.jpg"];
    [self addImage:@"miranda-kerr.jpg"];
    [self.view addSubview:Scroller];
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
        self.dropsAmount.text = [NSString stringWithFormat:@"%ld/11", (long)currentPage + 1];
        
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


-(void)addPeekView{
      [self addBlur];
    peekViewController = (PeekViewController *)[storyboard instantiateViewControllerWithIdentifier:@"peekView"];
    peekViewController.view.frame = CGRectMake(0, -[UIHelper getScreenHeight], [UIHelper getScreenWidth], [UIHelper getScreenHeight] - 64);
    [self.view addSubview:peekViewController.view];
  
    peekViewController.view.backgroundColor = [UIColor clearColor];
    //[self addConstraints:peekViewController.view];
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

-(void)attachGUI{
    //self.isInitialized = YES;
    //self.bucketImage.contentMode = UIViewContentModeScaleAspectFill;
    //self.bucketImage.clipsToBounds = YES;
    //[self insertSubview:self.topBar aboveSubview:self.bucketImage];
    //[self insertSubview:self.bottomBar aboveSubview:self.bucketImage];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.displayNameText.text = [feed objectAtIndex:indexPath.row];
    
   // [self.bucketImage setUserInteractionEnabled:YES];
    //[self setUserInteractionEnabled:YES];
    [UIHelper applyThinLayoutOnLabel:self.displayNameText withSize:18 withColor:[UIColor blackColor]];
    [UIHelper roundedCorners:self.profilePictureIcon withRadius:15];
    [UIHelper roundedCorners:self.availabilityIcon withRadius:7.5];
    self.topBar.alpha = 0.9;
    self.displayNameText.text = @"Chris";
    //self.bottomBar.alpha = 0.9;
    [self.navigationItem setTitle:@"Chris Aardal"];
    [UIHelper applyThinLayoutOnLabel:self.dropsAmount withSize:14];
    [UIHelper applyThinLayoutOnLabel:self.viewsAmount withSize:14];
    self.dropsAmount.text = @"1/11";
    self.viewsAmount.text = @"4.5K";
    self.dropsAmount.alpha = 0.0;
    self.viewsAmount.alpha = 0.0;
    self.dropsIcon.alpha = 0.0;
    self.viewsIcon.alpha = 0.0;
    self.viewsIcon.image = [UIHelper iconImage:[UIImage imageNamed:@"bucket-white.png"] withSize:30];
    self.dropsIcon.image = [UIHelper iconImage:[UIImage imageNamed:@"bucket-white.png"] withSize:30];
}

-(void)despandBucket{
    NSLog(@"despanding");
    [self.superController removeBucketAsRoot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma SuperButton callbacks
-(void)prepareCamera{
    
    
}

-(void)onCameraClose{
    
}
-(void)showCamera{
    
}


-(void)onImageTaken:(UIImage *)image{
  
    //[[currentController view] setBackgroundColor:[UIColor colorWithPatternImage:]];
}

-(void)onCameraOpen{
   
}

- (void)peekViewDrag:(UIPanGestureRecognizer *)gesture
{
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    CGRect frame = peekViewController.view.frame;
    if(frame.origin.y + frame.size.height <= [UIHelper getScreenHeight] - 64){
        peekViewController.view.frame = CGRectMake(0, peekViewController.view.frame.origin.y + translation.y, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
        blurEffectView.frame = peekViewController.view.frame;
    }
    
    if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        
        if(frame.origin.y + frame.size.height > ([UIHelper getScreenHeight]/2)){
            [self animatePeekViewIn];
        }else{
            [self animatePeekViewOut];
        }
    }
    [gesture setTranslation:CGPointZero inView:label];
    
}



-(void)animatePeekViewIn{
    
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = peekViewController.view.frame;
                         frame.origin.y = -64;
                         peekViewController.view.frame = frame;
                         blurEffectView.frame = frame;
                     }
                     completion:nil];
    
}
-(void)animatePeekViewOut{
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = peekViewController.view.frame;
                         frame.origin.y = -[UIHelper getScreenHeight];
                         peekViewController.view.frame = frame;
                         blurEffectView.frame = frame;
                         
                     }
                     completion:nil];
}

-(void)addBlur{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, -[UIHelper getScreenHeight], [UIHelper getScreenWidth], [UIHelper getScreenWidth]);
    // blurEffectView.alpha = 0.9;
    [self.view addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
