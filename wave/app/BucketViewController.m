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
}

- (void)viewDidLoad {
     drops = [[NSMutableArray alloc]init];
    [self addImageScroller];
    [super viewDidLoad];
    [self calculate];
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   
    // Do any additional setup after loading the view.
    AvailabilityViewController *viewControllerX = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    FilterViewController *viewControllerY = (FilterViewController *)[self createViewControllerWithStoryboardId:@"filterView"];
    chat = (ChatViewController *)[self createViewControllerWithStoryboardId:@"chatView"];
    [self.view insertSubview:chat.view belowSubview:[self.superButton getButton]];
    chat.view.hidden = YES;
    [self addConstraints:chat.view];
    
    [self attachViews:viewControllerY withY:viewControllerX];
    
    UITapGestureRecognizer *despandBucketGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(despandBucket)];
    despandBucketGesture.numberOfTapsRequired = 2;
    despandBucketGesture.numberOfTouchesRequired = 2;
    despandBucketGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:despandBucketGesture];
    
    [self attachGUI];
    [self.view insertSubview:self.topBar aboveSubview:Scroller];
    [self addPeekView];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(peekViewDrag:)]];
    [self animateElementsIn];
    
    UITapGestureRecognizer *chatGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChat)];
    
    [self.view addGestureRecognizer:chatGesture];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    NSLog(@"trykk");
    if (touch.tapCount == 2) {
        //This will cancel the singleTap action
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        //if they tapped within the coin then place the single tap action to fire after a delay of 0.3
        NSLog(@"EN");
    } else if (touch.tapCount == 2) {
        //this is the double tap action
       // [theCoin changeCoin:coin];
        NSLog(@"TO");
    }
}

-(void)showChat{
    NSLog(@"SHOWING CHAT");
    if([chat.view isHidden]){
        chat.view.hidden = NO;
       
    }else{
        chat.view.hidden = YES;
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
    int navigationHeight = self.navigationController.navigationBar.frame.size.height;
    Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -32, [UIHelper getScreenWidth], [UIHelper getScreenHeight])];
    Scroller.backgroundColor = [UIColor clearColor];
    Scroller.pagingEnabled = YES;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    Scroller.delegate = self;
    
    ViewSize = Scroller.bounds;
    [self addImage:@"miranda-kerr.jpg"];
    [self addImage:@"169.jpg"];
    [self addImage:@"test2.jpg"];
    [self addImage:@"miranda-kerr.jpg"];
    [self addImage:@"169.jpg"];
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
            NSLog(@"________:::::");
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
            //NSLog(@"adding images");
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
        NSLog(@"kjør animasjon her");
        CGPoint bottomOffset = CGPointMake(Scroller.bounds.size.width, 0);
        [Scroller setContentOffset:bottomOffset animated:NO];
        //[Scroller scrollRectToVisible:CGRectMake([UIHelper getScreenWidth],0,[UIHelper getScreenHeight],HEIGHT_OF_IMAGE) animated:NO];
        
    }
    if(page == 0){
        CGPoint bottomOffset = CGPointMake(Scroller.contentSize.width - (Scroller.bounds.size.width *2), 0);
        [Scroller setContentOffset:bottomOffset animated:NO];
    }
    
    /*
    if(lastPage){
        if(shiftPage){
            CGPoint bottomOffset = CGPointMake(0, 0);
            [Scroller setContentOffset:bottomOffset animated:NO];
            lastPage = NO;
            [self removeLastDrop];
            shiftPage = NO;
        }else{
            NSLog(@"SHIFT PAGe");
            shiftPage = YES;
        }
       
    }
     */

}

-(void)calculate{
    float constant = -44;
    float var = -360;
    
    float calulcation = ((var/constant) *100);
    NSLog(@"PROSENT; %f", calulcation);
}


-(void)addPeekView{
    [self addBlur];
    peekViewController = (PeekViewController *)[storyboard instantiateViewControllerWithIdentifier:@"peekView"];
    peekViewController.view.frame = CGRectMake(0, -PEEK_Y_START, [UIHelper getScreenWidth], PEEK_Y_START);
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
     self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 2];
    self.viewsAmount.text = @"4.5K";
    self.dropsAmount.alpha = 0.0;
    self.viewsAmount.alpha = 0.0;
    self.dropsIcon.alpha = 0.0;
    self.viewsIcon.alpha = 0.0;
    self.viewsIcon.image = [UIHelper iconImage:[UIImage imageNamed:@"bucket-white.png"] withSize:30];
    self.dropsIcon.image = [UIHelper iconImage:[UIImage imageNamed:@"bucket-white.png"] withSize:30];
    
}

-(void)initCameraPlaceholder{
    cameraPlaceHolder = [[UIImageView alloc] initWithFrame:ViewSize];
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
    [self initCameraPlaceholder];
    cameraView = self.camera.view;
}

-(void)onCameraClose{
    cameraMode = NO;
    [super onCameraClose];
}

-(void)showCamera{

    [self removeLastDrop];
    UIImageView *plcCamera = [self addImageWithCamera];
    [plcCamera addSubview:cameraView];
     currentView = plcCamera;
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
          CGPoint bottomOffset = CGPointMake(Scroller.contentSize.width - Scroller.bounds.size.width, 0);
        dispatch_async(main_queue, ^{
            [Scroller setContentOffset:bottomOffset animated:YES];
        });
    });
}

-(void)onCancelTap{
    [super onCancelTap];
    PageCount -=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    [self.camera.view removeFromSuperview];
    NSLog(@"%f", ViewSize.size.width);
    ViewSize = CGRectOffset(ViewSize, -Scroller.bounds.size.width, 0);
    [self addImage:@"169.jpg"];
    self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 2];
}

-(void)onImageTaken:(UIImage *)image{
    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    [self.camera.view removeFromSuperview];
    currentView.image = [self.camera imageByScalingAndCroppingForSize:size img:image];
    [drops addObject:currentView];
    self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 1];
    [self addImage:@"169.jpg"];
    UIImageView *firstDrop = [drops objectAtIndex:0];
    firstDrop.image = image;
}

-(void)onCameraOpen{
    cameraMode = YES;
    [super onCameraOpen];
}

- (void)peekViewDrag:(UIPanGestureRecognizer *)gesture
{
    UILabel *label = (UILabel *)gesture.view;
    CGPoint translation = [gesture translationInView:label];
    CGRect frame = peekViewController.view.frame;
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        [self hideSubscribeButton];
    }
   
    if(frame.origin.y <= -44 - translation.y){
        peekViewController.view.frame = CGRectMake(0, peekViewController.view.frame.origin.y + (translation.y*1.4), [UIHelper getScreenWidth], PEEK_Y_START - 64);
        [self calculateAlpha:-44 withTotal:frame.origin.y];
        //-360 og -44
        //blurEffectView.frame = peekViewController.view.frame;
    }

    
    if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
       // NSLog(@"stor %f", frame.origin.y + frame.size.height);
        if(frame.origin.y + frame.size.height >= (PEEK_Y_START-64) - 64){
            [self animatePeekViewIn];
            
        }else{
            [self animatePeekViewOut];
        }
    }
    [gesture setTranslation:CGPointZero inView:label];
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
