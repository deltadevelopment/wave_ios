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
#import "ConstraintHelper.h"
#import "DropModel.h"
#import "GraphicsHelper.h"
#import "BucketView.h"
#import "BucketController.h"
#import "DropController.h"
#import "ConstraintHelper.h"
#import "InfoView.h"
#import "DataHelper.h"
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
    DropView *currentView;
    NSMutableArray *drops;
    bool lastPage;
    bool shiftPage;
    bool lastDropIsAdded;
    bool cameraMode;
    NSMutableArray *dropsView;
    //UIImage *firstBucket;
    UIView *cameraHolder;
    bool isPeeking;
    bool canPeek;
    UIButton *playButton;
    UIButton *infoButton;
    BucketController *bucketController;
    DropController *dropController;
    BucketModel *bucket;
    InfoView *infoView;
    NSLayoutConstraint *infoButtonConstraint;
}
@synthesize infoViewMode;

- (void)viewDidLoad {
    drops = [[NSMutableArray alloc]init];
    bucketController = [[BucketController alloc] init];
    dropController = [[DropController alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addImageScroller];
    [super viewDidLoad];
    canPeek = YES;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    dropsView = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    AvailabilityViewController *viewControllerX = (AvailabilityViewController *)[self createViewControllerWithStoryboardId:@"availability"];
    FilterViewController *viewControllerY = (FilterViewController *)[self createViewControllerWithStoryboardId:@"filterView"];
    self.displayNameText.hidden = YES;
    self.topBar.hidden = YES;
    // chat.view.hidden = YES;
  
    cameraHolder = [[UIView alloc]initWithFrame:CGRectMake(0, -64, [UIHelper getScreenWidth],[UIHelper getScreenHeight])];
    cameraHolder.backgroundColor = [UIColor whiteColor];

    //[self addConstraints:Scroller withSubview:chat.view];
    [self addConstraintsChat:chat.view];
    [self attachViews:viewControllerY withY:viewControllerX];
    [self setReplyMode:YES];
    [self attachGUI];
    [self.view insertSubview:self.topBar aboveSubview:Scroller];
    [self initInfoButton];
    [self initPlayButton];
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
    [Scroller addGestureRecognizer:gestureRecognizer];
    
    [self.view insertSubview:cameraHolder belowSubview:[self.superButton getButton ]];
    cameraHolder.hidden = YES;
    
    
        infoView = [[InfoView alloc] initWithSuperViewController:self withButton:infoButton withConstraint:infoButtonConstraint];
    [self.view addSubview:infoView];
}

-(void)initInfoButton{
    infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //infoButton.frame = CGRectMake([UIHelper getScreenWidth] - 40,15 , 20, 20);
    [UIHelper applyUIOnButton:infoButton];
    [infoButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"arrow-up-icon.png"] withSize:150] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(tapInfoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    infoButtonConstraint = [ConstraintHelper addConstraintsToButton:self.view withButton:infoButton withPoint:CGPointMake(0, 15) fromLeft:YES fromTop:NO];
    
}

-(void)tapInfoButton{
    if([infoView viewHidden]){
        [infoView show];

    }else{
        [infoView hide];

    }
}


-(void)viewDidAppear:(BOOL)animated{
  
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]){
        return NO;
    }
    if ([gestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]] ) {
        UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)gestureRecognizer;
        if(swipe.direction == UISwipeGestureRecognizerDirectionDown){
            return YES;
        }
        if([chat isChatVisible] || isPeeking || cameraMode || infoViewMode){
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
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        //This will cancel the singleTap action
        //[NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {

    } else if (touch.tapCount == 2) {
  
    }
}
-(void)chatWasHidden{
    infoButton.hidden = NO;
    [self.superButton getButton].hidden = NO;
}

-(void)showChat{
    
    if(!infoViewMode && !isPeeking){
        if([chat isChatVisible]){
            [chat hideChat];
           
            infoButton.hidden = NO;
            [self.superButton getButton].hidden = NO;
        }else{
            [chat showChat];
            infoButton.hidden = YES;
            [self.superButton getButton].hidden = YES;
        }
    }
}

-(void)animateElementsIn{
  
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.dropsAmount.alpha = 0.9;
                         self.viewsAmount.alpha = 0.9;
                         //self.dropsIcon.alpha = 0.6;
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
    chat = (ChatViewController *)[self createViewControllerWithStoryboardId:@"chatView"];
    __weak typeof(self) weakSelf = self;
    chat.onChatHidden = ^{
        [weakSelf chatWasHidden];
    };
    //[self.view insertSubview:chat.view belowSubview:[self.superButton getButton]];
    [Scroller addSubview:chat.view];
    DropModel *lastDrop = [[bucket drops] objectAtIndex:0];
    DropModel *tempDrop = [[DropModel alloc] init];
    [self addDropToBucket:lastDrop];
    for(int i = 0; i< bucket.drops_count; i++){
        if(i == bucket.drops_count - 1){
            [self addDropToBucket:lastDrop];
        }else{
            [self addDropToBucket:tempDrop];
        }
    }
    [self addDropToBucket:tempDrop];
    CGPoint bottomOffset = CGPointMake(Scroller.contentSize.width - (Scroller.bounds.size.width*2), 0);
    [Scroller setContentOffset:bottomOffset animated:NO];
   // self.dropsAmount.text = [NSString stringWithFormat:@"%d/%ld", 8, [drops count]];
    [bucket find:^{
        if([[bucket drops] count] > 0){
            DropModel *tempDrop = [[bucket drops] objectAtIndex:[[bucket drops] count]-1];
            DropModel *tempDrop2 = [[bucket drops] objectAtIndex:0];
            [self updateDrop:tempDrop2 toView:[drops objectAtIndex:[drops count]-1]];
            
            for(int i = 0; i<[[bucket drops] count];i++){
                DropModel *dropt = [[bucket drops] objectAtIndex:i];
                [self updateDrop:dropt toView:[drops objectAtIndex:i+1]];
            }
            
            
            [self updateDrop:tempDrop toView:[drops objectAtIndex:0]];
            DropView *currentDropView = [drops objectAtIndex:[drops count]-2];
            [peekViewController updatePeekView:[[currentDropView drop] user]];
            self.viewsAmount.text = [NSString stringWithFormat:@"%d", [[currentDropView drop] temperature]];
        }
    } onError:^(NSError *error){
       
        
    }];
    

    [self.view addSubview:Scroller];
    //CGPoint bottomOffset = CGPointMake(Scroller.bounds.size.width, 0);
    //[Scroller setContentOffset:bottomOffset animated:NO];
}

-(void)updateDrop:(DropModel *) drop toView:(DropView *) dropView{
    dropView.dropTitle.text = [NSString stringWithFormat:@"@%@",[[drop user] username]];
    [dropView setDrop:drop];
    [drop requestPhoto:^(NSData *media){
        if([drop media_type] == 0){
            //IMAGE
            // [dropView setImage:[UIImage imageWithData:media]];
            [dropView setMedia:[UIImage imageWithData:media] withIndexId:[drop Id]];
            [[dropView spinner] stopAnimating];
            
        }else{
            //VIDEO
            [dropView setMedia:media withIndexId:[drop Id]];
            playButton.hidden = NO;
        }
      
    }];
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
        if([drops count] > currentPage - 1){
            DropView *lastDropView = [drops objectAtIndex:currentPage - 1];
            [lastDropView dropWillHide];
            playButton.hidden = YES;
        }
        if([drops count] > currentPage){
            DropView *currentDropView = [drops objectAtIndex:currentPage];
            [peekViewController updatePeekView:[[currentDropView drop] user]];
            self.viewsAmount.text = [NSString stringWithFormat:@"%d", [[currentDropView drop] temperature]];
        }

        if([drops count] > currentPage){
            currentView = [drops objectAtIndex:currentPage];
            if([currentView hasVideo]){
                //VIS PLAY KNAPP
                playButton.hidden = NO;
            }
        }
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
    DropView *dropView = [drops objectAtIndex:[drops count] - 1];
    [dropView removeFromSuperview];
    [drops removeObject:dropView];
    
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
    [peekViewController updatePeekView:[bucket user]];
    //[self addConstraints:peekViewController.view];
}



-(void)addDropToBucket:(DropModel *)drop
{
    PageCount +=1;
    self.topBar.hidden = YES;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    DropView *dropView = [[DropView alloc] initWithFrame:ViewSize];
    [dropView setDrop:drop];
    dropView.dropTitle.text = [NSString stringWithFormat:@"@%@",[[drop user] username]];
    
    [drop requestPhoto:^(NSData *media){
        [dropView setImage:[UIImage imageWithData:media]];
    }];
    /*
    if(drop.image !=nil){
        [dropView setImage:drop.image];
    }
    else if(drop.media_tmp != nil){
        UIImage *img = [UIImage imageWithData:drop.media_tmp];
        CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
       
        [dropView setImage:[GraphicsHelper imageByScalingAndCroppingForSize:size img:img]];
    }
    else{
        [dropView setImage:[UIImage imageNamed:[drop media]]];
    }
    */
    
    [Scroller insertSubview:dropView belowSubview:chat.view];
    [drops addObject:dropView];
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
}



-(void)addImageWithImageReturned:(UIImageView *) imageView
{
    PageCount +=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);

    [Scroller addSubview:imageView];
    
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
}


-(DropView *)addImageWithCamera
{
    PageCount +=1;
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
     DropView *dropView = [[DropView alloc] initWithFrame:ViewSize];
    dropView.dropTitle.text = @"Simen";
    [Scroller insertSubview:dropView belowSubview:chat.view];
    [Scroller layoutIfNeeded];
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
    return dropView;
}

-(void)attachGUI{
    //[UIHelper applyThinLayoutOnLabel:self.displayNameText withSize:18 withColor:[UIColor blackColor]];
    [UIHelper roundedCorners:self.profilePictureIcon withRadius:15];
    [UIHelper roundedCorners:self.availabilityIcon withRadius:7.5];
    self.topBar.alpha = 0.9;
    //self.displayNameText.text = @"Chris";
   // [self.navigationItem setTitle:@"Chris Aardal"];
    [UIHelper applyThinLayoutOnLabel:self.dropsAmount withSize:14];
    [UIHelper applyThinLayoutOnLabel:self.viewsAmount withSize:14];
    currentPage = 1;
    self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)PageCount - 2, [drops count] - 2];
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
-(void)setBucket:(BucketModel *)inputBucket{
   bucket = inputBucket;
    if([bucket.bucket_type isEqualToString:@"user"]){
        [self.navigationItem setTitle:[[bucket user] username]];
    }else{
        [self.navigationItem setTitle:[bucket title]];
    }
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
    infoButton.hidden = NO;
    [super onCameraClose];
}


-(void)showCamera{
   
}

-(void)onCancelTap{
    [super onCancelTap];
    cameraHolder.hidden = YES;
    Scroller.userInteractionEnabled = YES;
    PageCount -=1;
    [currentView removeFromSuperview];
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    ViewSize = CGRectOffset(ViewSize, -Scroller.bounds.size.width, 0);
    //[self addDropToBucket:[[DropModel alloc] initWithTestData:@"169.jpg" withName:@"Chris"]];
    [self addDropToBucket:[[bucket drops] objectAtIndex:0]];
    self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 2];
}

-(void)initPlayButton{
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake([UIHelper getScreenWidth]/2 - 50, [UIHelper getScreenHeight]/2 - 50 - 64, 100, 100);
    playButton.alpha = 0.7;
    [playButton addTarget:self action:@selector(startStopVideo:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"play.png"] withSize:150] forState:UIControlStateNormal];
    playButton.hidden = YES;
    [self.view addSubview:playButton];
}

-(void)startStopVideo:(id)sender{
    if(currentView !=nil){
        [currentView playMediaWithButton:playButton];
    }
}

-(void)onVideoTaken:(NSData *)video withImage:(UIImage *)image withtext:(NSString *)text{
    cameraHolder.hidden = YES;
    Scroller.userInteractionEnabled = YES;
    [currentView setMedia:video withIndexId:(int)[drops count]];
    [drops addObject:currentView];
    self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 1];
    [self addDropToBucket:[[bucket drops] objectAtIndex:0]];
    // DropView *firstDrop = [drops objectAtIndex:0];
    //[firstDrop setMedia:video];
    playButton.hidden = NO;
    chat.view.hidden = NO;
    [self uploadMedia:video];
}
-(void)onImageTaken:(UIImage *)image withText:(NSString *)text{
    cameraHolder.hidden = YES;
    Scroller.userInteractionEnabled = YES;
    
    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    //[self.camera.view removeFromSuperview];
    [currentView setMedia:[GraphicsHelper imageByScalingAndCroppingForSize:size img:image] withIndexId:(int)[drops count]];
    // currentView.image = [GraphicsHelper imageByScalingAndCroppingForSize:size img:image];
    [drops addObject:currentView];
    self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 1];
  [self addDropToBucket:[[bucket drops] objectAtIndex:0]];
    UIImageView *firstDrop = [drops objectAtIndex:0];
    firstDrop.image = image;
    [chat hideChat];
    [self uploadMedia:UIImagePNGRepresentation(image)];
}



-(void)uploadMedia:(NSData *)media{
    /*
    BucketModel *newBucket = [[BucketModel alloc] init];
    newBucket.Id = 3;
    newBucket.title = @"My new Crazy bucket";
    newBucket.bucket_description = @"My new crazy description";
    DropModel *newDrop = [[DropModel alloc] init];
    newDrop.caption = @"My crazy new drop!";
    newDrop.media_tmp = UIImagePNGRepresentation(image);
    newBucket.rootDrop = newDrop;
     */
    
    /*
    [bucketController createNewBucket:media
                      withBucketTitle:@"My new Crazy bucket"
                withBucketDescription:@"My new crazy description"
                      withDropCaption:@"My crazy new drop!"
                           onProgress:^(NSNumber *progression)
     {
         NSLog(@"LASTET OPP: %@", progression);
         
     }
                         onCompletion:^(ResponseModel *response)
     {
         NSLog(@"ALT ER FERDIG LASTET OPP!");
         
     
     }];
    */
    /*
    [dropController addDropToBucket:@"My drop caption"
                          withMedia:media
                       withBucketId:1
                         onProgress:^(NSNumber *progression)
     
     {
         NSLog(@"LASTET OPP: %@", progression);
         
     }
                       onCompletion:^(ResponseModel *response)
     {
         NSLog(@"ALT ER FERDIG LASTET OPP!");
         
     } onError:<#^(NSError *)errorCallback#>];
    */
    /*
    [bucketController updateBucket:newBucket
                      onCompletion:^(ResponseModel *response){
                          NSLog(@"BUCKET ENDRET");
                          
                      }];
     */
     
     
}



-(void)onCameraOpen{
    [self.camera prepareCamera:YES withReply:YES];
    [DataHelper setCurrentBucketId:bucket.Id];
    infoButton.hidden = YES;
    cameraMode = YES;
    chat.view.hidden = YES;
    Scroller.userInteractionEnabled = NO;
    [self removeLastDrop];
    //DropView *plcCamera = ;
    //[plcCamera addSubview:cameraView];
    currentView = [self addImageWithCamera];
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
        CGPoint bottomOffset = CGPointMake(Scroller.contentSize.width - Scroller.bounds.size.width, 0);
        dispatch_async(main_queue, ^{
        });

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
    //[self.camera prepareCamera:YES withReply:YES];
}

- (void)peekViewDrag:(UIPanGestureRecognizer *)gesture
{
    if(!cameraMode && !infoViewMode){
        isPeeking = YES;
        UILabel *label = (UILabel *)gesture.view;
        CGPoint translation = [gesture translationInView:label];
        CGRect frame = peekViewController.view.frame;
        
        if(gesture.state == UIGestureRecognizerStateBegan){
            [peekViewController hideSubscribeButton];
        }
        
        if(frame.origin.y <= -44 - translation.y){
            peekViewController.view.frame = CGRectMake(0, peekViewController.view.frame.origin.y + (translation.y*1.4), [UIHelper getScreenWidth], PEEK_Y_START - 64);
            float alpha = [self calculateAlpha:-44 withTotal:frame.origin.y];
            blurEffectView.alpha = alpha;
            //infoButton.alpha = 1 - alpha;
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

-(float)calculateAlpha:(float) number withTotal:(float) total{
    float alpha = ((number/total) * 100)/100;
    if(!firstTime){
        firstTime = YES;
        initalAlpha = alpha;
    }
    float result = alpha - initalAlpha;
    
    return result *(alpha + 1);
}





-(void)animatePeekViewIn{
    peekExpanded = YES;
  
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         blurEffectView.alpha = 1;
                     }
                     completion:^(BOOL finished){

                     }];
    [peekViewController animatePeekViewIn];
    
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
