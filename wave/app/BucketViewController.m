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
#import "ChatViewController.h"
#import "DropViewController.h"
#import "ConstraintHelper.h"
#import "DropModel.h"
#import "GraphicsHelper.h"
@interface BucketViewController ()

@end
const int PEEK_Y_START = 300;
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
    ChatViewController *chat;
    bool peekExpanded;
    bool firstTime;
    float initalAlpha;
    UIImageView *cameraPlaceHolder;
    UIImageView *currentView;
    NSMutableArray *drops;
    bool lastPage;
    bool shiftPage;
    bool lastDropIsAdded;
    bool cameraMode;
    NSMutableArray *dropsView;
    DropViewController *drop;
    UIImage *firstBucket;
    UIView *cameraHolder;
    bool isPeeking;
    bool canPeek;
    
}

- (void)viewDidLoad {
     drops = [[NSMutableArray alloc]init];
    [self addImageScroller];
    [super viewDidLoad];
    canPeek = YES;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    dropsView = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    AvailabilityViewController *viewControllerX = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    FilterViewController *viewControllerY = (FilterViewController *)[self createViewControllerWithStoryboardId:@"filterView"];
    chat = (ChatViewController *)[self createViewControllerWithStoryboardId:@"chatView"];
    //[self.view insertSubview:chat.view belowSubview:[self.superButton getButton]];
    [Scroller addSubview:chat.view];
   // chat.view.hidden = YES;
  
    cameraHolder = [[UIView alloc]initWithFrame:CGRectMake(0, -64, [UIHelper getScreenWidth],[UIHelper getScreenHeight])];
    cameraHolder.backgroundColor = [UIColor whiteColor];

    //[self addConstraints:Scroller withSubview:chat.view];
    [self addConstraintsChat:chat.view];
    [self attachViews:viewControllerY withY:viewControllerX];

    [self attachGUI];
    [self.view insertSubview:self.topBar aboveSubview:Scroller];
    [self addPeekView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(peekViewDrag:)];
   // pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    [self animateElementsIn];
    
    UITapGestureRecognizer *chatGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChat)];
    
    [self.view addGestureRecognizer:chatGesture];
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(despandBucket:)];
    gestureRecognizer.delegate = self;
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    gestureRecognizer.numberOfTouchesRequired = 1;
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self.view insertSubview:cameraHolder belowSubview:[self.superButton getButton ]];
    cameraHolder.hidden = YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]] ) {
        if([chat isChatVisible] || isPeeking || cameraMode){
            return NO;
        }
        return YES;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches BEGAN");
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        //This will cancel the singleTap action
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {

    } else if (touch.tapCount == 2) {
  
    }
}

-(void)showChat{
    if([chat isChatVisible]){
        [chat hideChat];
    }else{
        [chat showChat];
    }
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
    //int navigationHeight = self.navigationController.navigationBar.frame.size.height;
    Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -32, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    Scroller.backgroundColor = [UIColor clearColor];
    Scroller.pagingEnabled = YES;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    Scroller.delegate = self;
    
    ViewSize = Scroller.bounds;
    DropModel *firstDrop = [[DropModel alloc] initWithTestData:@"169.jpg" withName:@"Chris"];
    firstDrop.image = firstBucket;
    
    [self addDropToBucket:[[DropModel alloc] initWithTestData:@"miranda-kerr.jpg" withName:@"Miranda Kerr"]];
    [self addDropToBucket:firstDrop];
    [self addDropToBucket:[[DropModel alloc] initWithTestData:@"test2.jpg" withName:@"Matika"]];
    [self addDropToBucket:[[DropModel alloc] initWithTestData:@"miranda-kerr.jpg" withName:@"Miranda Kerr"]];
    [self addDropToBucket:firstDrop];
    [self.view addSubview:Scroller];
    CGPoint bottomOffset = CGPointMake(Scroller.bounds.size.width, 0);
    [Scroller setContentOffset:bottomOffset animated:NO];
}

-(BOOL)shouldGetMoreImages{
    int temp = (PageCount) /2;
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
    if (previousPage != page) {
        previousPage = page;
        currentPage = page;
        if(currentPage == PageCount - 1){
            
            if(cameraMode){
                self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count]];
            }else{
               self.dropsAmount.text = [NSString stringWithFormat:@"%d/%ld", 1, [drops count] - 2];
            }
         
        }else{
            if(currentPage == 0){
                self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", [drops count] - 2, [drops count] - 2];
            }
            else{
                self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 2];
            }
            
            
        
        }
        
        if([self shouldGetMoreImages]){
           // [self addImage:@"test1.jpg"];
            //[self addImage:@"test2.jpg"];
            //[self addImage:@"miranda-kerr.jpg"];
        }
    }
}

-(void)removeLastDrop{
    lastDropIsAdded = NO;
    PageCount -=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    ViewSize = CGRectOffset(ViewSize, -Scroller.bounds.size.width, 0);
    [[Scroller subviews] objectAtIndex:[drops count]-1];
    [drops removeObjectAtIndex:[drops count]-1];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
   
   
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if(page == PageCount - 1){
        CGPoint bottomOffset = CGPointMake(Scroller.bounds.size.width, 0);
        [Scroller setContentOffset:bottomOffset animated:NO];
        //[Scroller scrollRectToVisible:CGRectMake([UIHelper getScreenWidth],0,[UIHelper getScreenHeight],HEIGHT_OF_IMAGE) animated:NO];
        
    }
    if(page == 0){
        CGPoint bottomOffset = CGPointMake(Scroller.contentSize.width - (Scroller.bounds.size.width *2), 0);
        [Scroller setContentOffset:bottomOffset animated:NO];
    }
}



-(void)addPeekView{
    [self addBlur];
    peekViewController = (PeekViewController *)[storyboard instantiateViewControllerWithIdentifier:@"peekView"];
    peekViewController.view.frame = CGRectMake(0, -PEEK_Y_START, [UIHelper getScreenWidth], PEEK_Y_START);
    [self.view addSubview:peekViewController.view];
    
    peekViewController.view.backgroundColor = [UIColor clearColor];
    //[self addConstraints:peekViewController.view];
}



-(void)addDropToBucket:(DropModel *)drop
{
    PageCount +=1;
    self.topBar.hidden = YES;
    
    //Drop topBar
    UIView *topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 32, [UIHelper getScreenWidth], 50)];
    
    //Drop profilePicture
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
    
    profilePicture.image = [UIImage imageNamed:@"miranda-kerr.jpg"];
    profilePicture.layer.cornerRadius = 15;
    profilePicture.clipsToBounds = YES;
    
    //Drop Name Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, -2, [UIHelper getScreenWidth] - 52, 50)];
    nameLabel.text = [drop username];
    [UIHelper applyThinLayoutOnLabel:nameLabel withSize:18 withColor:[UIColor whiteColor]];
    [nameLabel setMinimumScaleFactor:12.0/17.0];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    
    //Shadow View
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 32, [UIHelper getScreenWidth], [UIHelper getScreenHeight]/4)];
    [UIHelper addShadowToView:shadowView];
    
    UIImageView *ImgView = [[UIImageView alloc] initWithFrame:ViewSize];
    
    //Attach elements
    [topBar addSubview:nameLabel];
    [topBar addSubview:profilePicture];
    if(drop.image !=nil){
        [ImgView setImage:drop.image];
    }else{
        [ImgView setImage:[UIImage imageNamed:[drop media]]];
    }
    
    [ImgView addSubview:shadowView];
    [ImgView addSubview:topBar];

    [Scroller addSubview:ImgView];
    [drops addObject:ImgView];
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
}



-(void)addImageWithImageReturned:(UIImageView *) imageView
{
    PageCount +=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);

    [Scroller addSubview:imageView];
    
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
}


-(UIImageView *)addImageWithCamera
{
    PageCount +=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    UIImageView *ImgView = [[UIImageView alloc] initWithFrame:ViewSize];
    [Scroller addSubview:ImgView];
    [Scroller layoutIfNeeded];
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
    return ImgView;
}

-(void)attachGUI{
    [UIHelper applyThinLayoutOnLabel:self.displayNameText withSize:18 withColor:[UIColor blackColor]];
    [UIHelper roundedCorners:self.profilePictureIcon withRadius:15];
    [UIHelper roundedCorners:self.availabilityIcon withRadius:7.5];
    self.topBar.alpha = 0.9;
    self.displayNameText.text = @"Chris";
    [self.navigationItem setTitle:@"Chris Aardal"];
    [UIHelper applyThinLayoutOnLabel:self.dropsAmount withSize:14];
    [UIHelper applyThinLayoutOnLabel:self.viewsAmount withSize:14];
    currentPage = 1;
    self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 2];
    self.viewsAmount.text = @"4.5K";
    self.dropsAmount.alpha = 0.0;
    self.viewsAmount.alpha = 0.0;
    self.dropsIcon.alpha = 0.0;
    self.viewsIcon.alpha = 0.0;
    self.viewsIcon.image = [UIHelper iconImage:[UIImage imageNamed:@"eye.png"] withSize:30];
    self.dropsIcon.image = [UIHelper iconImage:[UIImage imageNamed:@"drop.png"] withSize:30];
    
}

-(void)initCameraPlaceholder{
    cameraPlaceHolder = [[UIImageView alloc] initWithFrame:ViewSize];
}

-(void)despandBucket:(UISwipeGestureRecognizer *)recognizer {
    [self.superController removeBucketAsRoot];
}
-(void)setBucket:(UIImage *)bucket{
    firstBucket = bucket;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma SuperButton callbacks
-(void)prepareCamera{
    if(cameraView == nil){
        [self initCameraPlaceholder];
        cameraView = self.camera.view;
        [cameraHolder addSubview:cameraView];
    }
}


-(void)onCameraClose{
    cameraMode = NO;
    
    [super onCameraClose];
}

-(void)showCamera{
    chat.view.hidden = YES;
    Scroller.userInteractionEnabled = NO;
    
    [self removeLastDrop];
    UIImageView *plcCamera = [self addImageWithCamera];
    //[plcCamera addSubview:cameraView];
     currentView = plcCamera;
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
          CGPoint bottomOffset = CGPointMake(Scroller.contentSize.width - Scroller.bounds.size.width, 0);
        dispatch_async(main_queue, ^{
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                   [Scroller setContentOffset:bottomOffset animated:NO];
                             }
                             completion:^(BOOL finished){
                                 cameraHolder.hidden = NO;
                                 canPeek = NO;
                                 //[self showToolButtons];
                                 
                                 
                             }];
          
            
            
        });
    });
    
    
    
}

-(void)onCancelTap{
    [super onCancelTap];
     cameraHolder.hidden = YES;
    Scroller.userInteractionEnabled = YES;
    PageCount -=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    ViewSize = CGRectOffset(ViewSize, -Scroller.bounds.size.width, 0);
      [self addDropToBucket:[[DropModel alloc] initWithTestData:@"169.jpg" withName:@"Chris"]];
    self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 2];
}

-(void)onImageTaken:(UIImage *)image{
     cameraHolder.hidden = YES;
    Scroller.userInteractionEnabled = YES;

    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    //[self.camera.view removeFromSuperview];
    currentView.image = [GraphicsHelper imageByScalingAndCroppingForSize:size img:image];
    [drops addObject:currentView];
    self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 1];
       [self addDropToBucket:[[DropModel alloc] initWithTestData:@"169.jpg" withName:@"Chris"]];
    UIImageView *firstDrop = [drops objectAtIndex:0];
    firstDrop.image = image;
}

-(void)onCameraOpen{
    cameraMode = YES;
    [super onCameraOpen];
}

- (void)peekViewDrag:(UIPanGestureRecognizer *)gesture
{
    if(!cameraMode){
        isPeeking = YES;
        UILabel *label = (UILabel *)gesture.view;
        CGPoint translation = [gesture translationInView:label];
        CGRect frame = peekViewController.view.frame;
        
        if(gesture.state == UIGestureRecognizerStateBegan){
            [self hideSubscribeButton];
        }
        
        if(frame.origin.y <= -44 - translation.y){
            peekViewController.view.frame = CGRectMake(0, peekViewController.view.frame.origin.y + (translation.y*1.4), [UIHelper getScreenWidth], PEEK_Y_START - 64);
            [self calculateAlpha:-44 withTotal:frame.origin.y];
        }
        
        
        if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
        {
            if(frame.origin.y + frame.size.height >= (PEEK_Y_START-64) - 64){
                [self animatePeekViewIn];
                
            }else{
                [self animatePeekViewOut];
                isPeeking = NO;
            }
            
        }
        [gesture setTranslation:CGPointZero inView:label];
    }
    
    
}

-(void)calculateAlpha:(float) number withTotal:(float) total{
    float alpha = ((number/total) * 100)/100;
    if(!firstTime){
        firstTime = YES;
        initalAlpha = alpha;
    }
    float result = alpha - initalAlpha;
    blurEffectView.alpha = result*(alpha + 1);
}


-(void)hideSubscribeButton{
    if(peekViewController.subscribeButton.alpha == 1.0){
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             peekViewController.subscribeButton.alpha = 0.0;
                             peekViewController.subscribeVerticalconstraint.constant += 60;
                             [peekViewController.view layoutIfNeeded];
                             [peekViewController.view updateConstraintsIfNeeded];
                         }
                         completion:nil];
    }

}


-(void)animatePeekViewIn{
    peekExpanded = YES;
  
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = peekViewController.view.frame;
                         frame.origin.y = -44;
                         frame.size.height = [UIHelper getScreenHeight];
                         peekViewController.view.frame = frame;
                         //  blurEffectView.frame = frame;
                         blurEffectView.alpha = 1;
                         peekViewController.subscribeButton.alpha = 1.0;
                         peekViewController.subscribeVerticalconstraint.constant -= 60;
                         [peekViewController.view layoutIfNeeded];
                         [peekViewController.view updateConstraintsIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.3f
                                               delay:0.0f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                             
                                          }
                                          completion:nil];
                     }];
    
}
-(void)animatePeekViewOut{
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = peekViewController.view.frame;
                         frame.origin.y = -PEEK_Y_START;
                         frame.size.height = PEEK_Y_START - 64;
                         peekViewController.view.frame = frame;
                         //blurEffectView.frame = frame;
                         blurEffectView.alpha = 0;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
}

-(void)addBlur{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    // blurEffectView.alpha = 0.9;
    blurEffectView.alpha = 0.0;
    [self.view addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)addConstraints:(UIView *) view
{
     view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
}

-(void)addConstraintsChat:(UIView *) view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:30.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-30.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
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
