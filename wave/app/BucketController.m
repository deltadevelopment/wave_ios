//
//  BucketViewController2.m
//  wave
//
//  Created by Simen Lie on 30.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "BucketController.h"
#import "BucketModel.h"
#import "FilterViewController.h"
#import "TemperatureController.h"
#import "BucketView.h"
#import "PeekViewController.h"
#import "DataHelper.h"
#import "InfoView.h"
#import "ConstraintHelper.h"
#import "SearchViewController.h"
#import "TemperatureModel.h"
@interface BucketController ()

@end
const int PEEK_Y_START = 300;
@implementation BucketController
{
    NSArray *array;
    BucketModel *bucket;
    bool canPeek;
    UIView *cameraHolder;
    PeekViewController *peekViewController;
    UIVisualEffectView  *blurEffectView;
    bool firstTime;
    bool peekExpanded;
    float initalAlpha;
    bool cameraMode;
    bool isPeeking;
    UIStoryboard *storyboard;
    UIImageView *cameraPlaceHolder;
    UIView *cameraView;
    UIScrollView *scrollView;
    bool isFirst;
    DropController *currentDropPage;
    DropController *lastUploadedDropPage;
    UserModel *user;
    InfoView *infoView;
    UIButton *infoButton;
    NSLayoutConstraint *infoButtonConstraint;
    bool shouldAnimateTemperatureChanges;
    bool superButtonDisabled;
    AuthHelper *authHelper;
    bool isAboutToleaveBucket;
    bool shouldJumpToDrop;
    int dropIdToJumpTo;
    bool dropForDeletion;
    int currentDropPosition;
    UIImageView *tickView;
}
@synthesize infoViewMode;
- (void)viewDidLoad {
    [super viewDidLoad];
     isAboutToleaveBucket = NO;
    [self setUpObjects];
    
    [self setUpGestures];
    
    [self loadBucket];
   
    [self initUISetup];
    [self attachSubviews];
    [self setupCallbacks];
    [self showChat];
    if(superButtonDisabled){
        [self disableReply];        
    }else{
    [self enableReply];
    }
 
    TemperatureController *viewControllerX = [[TemperatureController alloc] init];
    viewControllerX.onAction = ^(NSNumber *temperature){
        TemperatureModel *temperatureModel = [[TemperatureModel alloc] initWithDrop:[[currentDropPage drop] Id]];
        [temperatureModel setTemperature:[temperature intValue]];
        [temperatureModel saveChanges:^(ResponseModel *response, TemperatureModel *temperatureModel){
            if(shouldAnimateTemperatureChanges){
                [currentDropPage bindTemperatureChanges];
                shouldAnimateTemperatureChanges = NO;
            }else{
                shouldAnimateTemperatureChanges = YES;
            }
        } onError:^(NSError *error){}];
        
    };
    viewControllerX.onAnimationEnded =^{
        if(shouldAnimateTemperatureChanges){
            [currentDropPage bindTemperatureChanges];
            shouldAnimateTemperatureChanges = NO;
        }else{
            shouldAnimateTemperatureChanges = YES;
        }
        
        
    };
    // FilterViewController *viewControllerY = (FilterViewController *)[self createViewControllerWithStoryboardId:@"filterView"];
    
    cameraHolder = [[UIView alloc]initWithFrame:CGRectMake(0, -64, [UIHelper getScreenWidth],[UIHelper getScreenHeight])];
    cameraHolder.backgroundColor = [UIColor whiteColor];
    [self attachViews:nil withY:viewControllerX];
    [self.view insertSubview:cameraHolder belowSubview:[self.superButton getButton ]];
    cameraHolder.hidden = YES;
    user = [[UserModel alloc] initWithDeviceUser];
    [user find:^(UserModel *returningUser){
        user = returningUser;
    } onError:^(NSError *error){}];
    [self initInfoButton];
    infoView = [[InfoView alloc] initWithSuperViewController:self withButton:infoButton withConstraint:infoButtonConstraint];
    [self.view addSubview:infoView];
    [self initTickView];
    [self addPeekView];
    self.startY = 0;
    [self getProgressIndicator].frame = CGRectMake(0, self.startY, 0, 4);
    [self getProgressIndicator].hidden = NO;
    [self.view addSubview:[self getProgressIndicator]];
}


-(void)ShowProfile{
    
    

}

-(void)initInfoButton{
    infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //infoButton.frame = CGRectMake([UIHelper getScreenWidth] - 40,15 , 20, 20);
    [UIHelper applyUIOnButton:infoButton];
    [infoButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"dots-hor-icon.png"] withSize:150] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(tapInfoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    infoButtonConstraint = [ConstraintHelper addConstraintsToButton:self.view withButton:infoButton withPoint:CGPointMake(0, 15) fromLeft:YES fromTop:NO];
    infoButton.hidden = NO;
}


-(void)tapInfoButton{
    [self showActions];
    /*if([infoView viewHidden]){
     [infoView show];
     
     }else{
     [infoView hide];
     
     }*/
}

-(void)showActions{
    UIAlertController * view = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    NSString *watchString = bucket.watching ? NSLocalizedString(@"unwatch_action_txt", nil) : NSLocalizedString(@"watch_action_txt", nil);
    
    UIAlertAction* watch = [UIAlertAction
                          actionWithTitle:watchString
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              if (bucket.watching) {
                                  [bucket unwatch:^(ResponseModel *response){
                                      [bucket setWatching:NO];
                                      [view dismissViewControllerAnimated:YES completion:nil];
                                  }
                                        onError:^(NSError *error){
                                            
                                        }];
                              }else{
                                  [bucket watch:^(ResponseModel *response){
                                      [bucket setWatching:YES];
                                      [view dismissViewControllerAnimated:YES completion:nil];
                                  }
                                        onError:^(NSError *error){
                                            
                                        }];
                              }
                              
                          }];
    
    
    UIAlertAction* redrop = [UIAlertAction
                            actionWithTitle:NSLocalizedString(@"redrop_action_txt", nil)
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [currentDropPage.drop redrop:^(ResponseModel *response){
                                    [self animateTick];
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                } onError:^(NSError *error){}];
                                //Do some thing here
                                //[view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
    
    UIAlertAction* delete = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"delete_bucket_txt", nil)
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                // [view dismissViewControllerAnimated:YES completion:nil];
                                 dropForDeletion = NO;
                                 [self showDeleteAlert];
                             }];
    
    UIAlertAction* deleteDrop = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"delete_drop_txt", nil)
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 dropForDeletion = YES;
                                 [self showDeleteAlert];
                                 
                             }];
    
   
    
    
    UIAlertAction* tag = [UIAlertAction
                          actionWithTitle:NSLocalizedString(@"tags_txt", nil)
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              //Do some thing here
                              
                              //Show Subscribers
                              UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                              UINavigationController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"searchNavigation"];
                              vc.definesPresentationContext = YES;
                              SearchViewController *tagsView =  [[vc viewControllers] objectAtIndex:0];
                              [tagsView setTagMode:YES];
                              [tagsView setSearchMode:YES];
                              [tagsView setCurrentBucket:bucket];
                             
                             
                              // [vc.navigationBar setti]
                              [vc.navigationBar setTintColor:[ColorHelper purpleColor]];
                              [vc.navigationBar setBackgroundColor:[ColorHelper purpleColor]];
                              [vc.navigationBar setBarTintColor:[ColorHelper purpleColor]];
                              //[[ApplicationHelper getMainNavigationController] pushViewController:vc animated:YES];
                              
                              [[ApplicationHelper getMainNavigationController] presentViewController:vc animated:YES completion:nil];
                              
                              
                              
                              [view dismissViewControllerAnimated:YES completion:nil];
                              
                          }];
 
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"cancel_menu_txt", nil)
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
   
    
    
    if (![bucket.bucket_type isEqualToString:@"user"]) {
         [view addAction:tag];
          [view addAction:watch];
    }
    if ([bucket.bucket_type isEqualToString:@"user"] && bucket.user.Id == [[authHelper getUserId] intValue]) {
        
    }
    else{
     [view addAction:redrop];
    }
   
    
    if (currentDropPage.drop.user.Id == [[authHelper getUserId] intValue]) {
        [view addAction:deleteDrop];
    }
    
    if (bucket.user.Id == [[authHelper getUserId] intValue]) {
        if (![bucket.bucket_type isEqualToString:@"user"]) {
            [view addAction:delete];
        }
        
    }
    
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

-(void)initUISetup{
    //All visible and not visible elements
    [self.superButton getButton].hidden = YES;
}

-(void)attachSubviews{
    
    
    
}

-(void)animateTick{
    tickView.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         tickView.alpha = 0.8;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.3f
                                               delay:0.5f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              tickView.alpha = 0.0;
                                             // [infoView.view layoutIfNeeded];
                                          }
                                          completion:nil];
                     }];
}

-(void)initTickView{
    tickView = [[UIImageView alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth]/2-25, [UIHelper getScreenHeight]/2-25, 50, 50)];
    tickView.image = [UIImage imageNamed:@"tick.png"];
    tickView.alpha = 0.0;
    tickView.hidden = YES;
    [self.view addSubview:tickView];
}

-(void)showDeleteAlert{
    UIAlertView *alert;
    if (dropForDeletion) {
        alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"delete_drop_txt", nil)
                                                       message:NSLocalizedString(@"delete_drop_confirmation_txt", nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"cancel_menu_txt", nil)
                                             otherButtonTitles:@"Ok",nil];
    }else{
        alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"delete_bucket_txt", nil)
                                                       message:NSLocalizedString(@"delete_bucket_confirmation_txt", nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"cancel_menu_txt", nil)
                                             otherButtonTitles:@"Ok",nil];
    }

    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //ikke logg ut
    }else{
        //Logg ut
        if (dropForDeletion) {
            //Do some thing here
            
            [currentDropPage.drop delete:^(ResponseModel *response){
                DropModel *oldDrop = currentDropPage.drop;
                currentDropPage = [self viewControllerAtIndex:[currentDropPage pageIndex] -1 replacingObject:nil];
                NSArray *viewControllers = @[currentDropPage];
                [self.pageViewController setViewControllers:viewControllers
                                                  direction:UIPageViewControllerNavigationDirectionReverse
                                                   animated:YES
                                                 completion:^(BOOL finished){
                                                     [bucket removeDrop:oldDrop];
                                                     [self updatePageIndicator:currentDropPage.pageIndex];
                                                 }];
                
                
                
                //[view dismissViewControllerAnimated:YES completion:nil];
            } onError:^(NSError *error){}];
        }else{
            [bucket delete:^(ResponseModel *response, BucketModel *newBucket){
                [DataHelper addToDeletionQueue:bucket];
                [self despandBucket:nil];
            } onError:^(NSError *error){
                
            }];
            
        }
        
    }
}


-(void)loadBucket{
    [bucket find:[bucket Id] onCompletion:^(ResponseModel *response, BucketModel *returningBucket){
        bucket = returningBucket;
        int dropPositionInBucket = (int)[bucket.drops count]-1;
        if(shouldJumpToDrop){
            int index = 0;
            for(DropModel *drop in bucket.drops){
                if(drop.Id == dropIdToJumpTo){
                    dropPositionInBucket = index;
                }
                index++;
            }
        }
        DropModel *currDrop = [[bucket drops] objectAtIndex:dropPositionInBucket];
        [peekViewController updatePeekView:[currDrop user]];
        currentDropPage = [self viewControllerAtIndex:dropPositionInBucket replacingObject:currentDropPage];
        currentDropPosition = dropPositionInBucket;
        NSArray *viewControllers = @[currentDropPage];
        if (currentDropPage.isLoaded) {
            [currentDropPage startVideo];
        }else{
            [currentDropPage setIsStartingView:YES];
        }
        
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self updatePageIndicator:dropPositionInBucket];
        
    } onError:^(NSError *error){
        
    }];
    /*
     [bucket find:^{
     if([[bucket drops] count] > 0){
     [self updatePageIndicator:[[bucket drops] count]-1];
     }
     } onError:^(NSError *error){
     
     
     }];
     */
}

-(void)setUpObjects{
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _drops = [[NSMutableArray alloc] init];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    isFirst = YES;
    currentDropPage = [self viewControllerAtIndex:0 replacingObject:nil];
    currentDropPosition = 0;
    NSArray *viewControllers = @[currentDropPage];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_pageViewController];
    [self.view insertSubview:_pageViewController.view atIndex:0];
    [self.pageViewController didMoveToParentViewController:self];
    
    for (UIView *v in self.pageViewController.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            scrollView = ((UIScrollView *)v);
        }
    }
    _chat = (ChatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"chatView"];
    
    [scrollView addSubview:self.chat.view];
    [self addConstraintsChat:self.chat.view];
    // _chat.view.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    
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
                                                           constant:-100.0]];
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


-(void)setupCallbacks{
    __weak typeof(self) weakSelf = self;
    self.chat.onChatHidden = ^{
        [weakSelf chatWasHidden];
    };
}

-(void)chatWasHidden{
    infoButton.hidden = NO;
    [self.superButton getButton].hidden = NO;
    
    
}


-(void)setUpGestures{
    UIPanGestureRecognizer *peekDragGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(peekViewVerticalMove:)];
    UITapGestureRecognizer *showChatGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChat)];
    UISwipeGestureRecognizer *despandBucketGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(despandBucket:)];
    despandBucketGesture.delegate = self;
    [despandBucketGesture setDirection:(UISwipeGestureRecognizerDirectionUp)];
    despandBucketGesture.numberOfTouchesRequired = 1;
    despandBucketGesture.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:peekDragGesture];
    [self.view addGestureRecognizer:showChatGesture];
    [self.pageViewController.view addGestureRecognizer:despandBucketGesture];
}

-(void)showChat{
    if(!infoViewMode && !isPeeking){
        if([self.chat isChatVisible]){
            [self.chat hideChat];
            
            infoButton.hidden = NO;
            [self.superButton getButton].hidden = NO;
            
            
        }else{
            [self.chat showChat];
            infoButton.hidden = YES;
            [self.superButton getButton].hidden = YES;
        }
    }
}

-(void)despandBucket:(UISwipeGestureRecognizer *)recognizer {
    //[self.superController removeBucketAsRoot];
    isAboutToleaveBucket = YES;
    [currentDropPage setIsDisplaying:NO];
    [currentDropPage setIsStartingView:NO];
    [currentDropPage stopVideo];
    self.onDespand();
    
    
    // [self.superCarousel removeBucketAsRoot];
    //[self dismissViewControllerAnimated:NO completion:nil];
    // NSLog(@"dismissing");
}

-(void)viewDidAppear:(BOOL)animated{

   
   
    NSLog(@"PEEK view");
}


-(void)addPeekView{
    [self addBlur];
    //peekViewController = [[PeekViewController alloc] init];
    peekViewController = (PeekViewController *)[storyboard instantiateViewControllerWithIdentifier:@"peekView"];
    
    [peekViewController setPageViewController:self.pageViewController];
    peekViewController.view.frame = CGRectMake(0, -PEEK_Y_START, [UIHelper getScreenWidth], PEEK_Y_START);
    //peekViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
    [peekViewController setParentController:self];
    //[self.view addSubview:peekViewController.view];
    [self.view insertSubview:peekViewController.view aboveSubview:blurEffectView];
    // peekViewController.view.backgroundColor = [UIColor clearColor];
    [peekViewController updatePeekView:[bucket user]];
    //[self addConstraints:peekViewController.view];
    
    
    // [self.view addSubview:self.chat.view];
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

-(UIScrollView *)getScrollView{
    for (UIView *v in self.pageViewController.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            scrollView = ((UIScrollView *)v);
            return scrollView;
        }
    }
    return nil;
}

-(void)loadView{
    //NSLog(@"loading view");
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    BucketView *contentView = [[BucketView alloc] initWithFrame:applicationFrame];
    self.view = contentView;
}



-(void)initUI{
    // self.uiPageIndicator = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //MER HER
}

-(void)animateElementsIn{
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //self.uiPageIndicator.alpha = 0.9;
                     }
                     completion:nil];
}

-(void)setBucket:(BucketModel *)inputBucket{
    bucket = inputBucket;
    NSLog(@"the bucket id is %d", bucket.Id);
    if (peekViewController != nil) {
        [peekViewController updatePeekView:[bucket user]];
    }
    authHelper = [[AuthHelper alloc] init];
    if([bucket.bucket_type isEqualToString:@"user"]){
        [self.navigationItem setTitle:[[bucket user] username]];
        // NSLog(@"Bucket user id: %d %d", [bucket user].Id, [[authHelper getUserId] intValue]);
        if([bucket user].Id == [[authHelper getUserId] intValue]){
            superButtonDisabled = NO;
        }
        else{
            superButtonDisabled = YES;
        }
        
    }else{
        superButtonDisabled = NO;
        [self.navigationItem setTitle:[bucket title]];
    }
}

-(void)setBucket:(BucketModel *)inputBucket withCurrentDropId:(int) dropId{
    bucket = inputBucket;
    NSLog(@"the bucket id is %d", bucket.Id);
    [bucket find:^{
        NSLog(@"trying to find");
        [self setBucket:bucket];
        if(dropId != 0){
            dropIdToJumpTo = dropId;
            shouldJumpToDrop = YES;
        }
    } onError:^(NSError *error){
        
    }];
   
}

-(void)updatePageIndicator:(NSUInteger)index{
    BucketView *contentView = (BucketView *) self.view;
    [contentView setPageIndicatorText:[NSString stringWithFormat:@"%ld/%lu",(long)index+1,(unsigned long)[[bucket drops] count]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((DropController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    if(index == 0){
        return [self viewControllerAtIndex:[[bucket drops] count]-1 replacingObject:nil];
    }
    
    index--;
    
    
    return [self viewControllerAtIndex:index replacingObject:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    //  [[self getScrollView]bringSubviewToFront:self.chat.view];
    NSUInteger index = ((DropController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [[bucket drops] count]) {
        return [self viewControllerAtIndex:0 replacingObject:nil];
    }
    
    
    return [self viewControllerAtIndex:index replacingObject:nil];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    DropController *currentPage = [pageViewController.viewControllers lastObject];
    currentDropPage = currentPage;
    [self updatePageIndicator:currentDropPage.pageIndex];
    [peekViewController updatePeekView:[[currentDropPage drop] user]];
    
    DropController *previousPage = [previousViewControllers objectAtIndex:0];
    [previousPage setIsDisplaying:NO];
    [previousPage stopVideo];
    //[currentDropPage startVideo];
    currentDropPage.isDisplaying = YES;
    [self startVideoTimer];
    
    
    
}

-(void)startVideoTimer{
    [NSTimer scheduledTimerWithTimeInterval:0.3
                                     target:self
                                   selector:@selector(playDelayed)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)playDelayed{
    if (currentDropPage.isDisplaying) {
        [currentDropPage startVideo];
    }

}

-(void)stopAllVideo{
    [currentDropPage stopVideo];
}


- (DropController *)viewControllerAtIndex:(NSUInteger)index replacingObject:(DropController *) pageToReplace
{
    if (([[bucket drops] count] == 0) || (index >= [[bucket drops]  count])) {
        return nil;
    }
    
    DropController *pageContentViewController = [[DropController alloc] init];
    DropModel *dropModel = [[bucket drops] objectAtIndex:index];
    if(pageToReplace != nil){
        //Uses the prefetched thumbnail or image from the feed, instead of downloading it again
        if(dropModel.media_type == 0){
            dropModel.media_tmp = [[pageToReplace drop] media_tmp];
            [[dropModel user] setMedia_tmp:[[[pageToReplace drop]user] media_tmp]];
        }else{
            dropModel.thumbnail_tmp = [[pageToReplace drop] thumbnail_tmp];
        }
    }
    [pageContentViewController setDrop:dropModel];
    if(isFirst){
        [pageContentViewController setIsPlaceholderView:YES];
        isFirst = NO;
    }
    else{
        [pageContentViewController setIsPlaceholderView:NO];
    }
    [pageContentViewController bindToModel];
    // pageContentViewController.imageFile = self.pageImages[index];
    //pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (void)peekViewVerticalMove:(UIPanGestureRecognizer *)gesture
{
    if(!cameraMode && !infoViewMode){
        isPeeking = YES;
        NSLog(@"ISPEEKING");
        UILabel *label = (UILabel *)gesture.view;
        CGPoint translation = [gesture translationInView:label];
        CGRect frame = peekViewController.view.frame;
        
        if(gesture.state == UIGestureRecognizerStateBegan){
            [peekViewController hideSubscribeButton];
            [peekViewController requestProfilePic];
        }
        if(frame.origin.y <= 0 - translation.y){
            peekViewController.view.frame = CGRectMake(0, peekViewController.view.frame.origin.y + (translation.y*1.4), [UIHelper getScreenWidth], PEEK_Y_START);
            float alpha = [self calculateAlpha:-44 withTotal:frame.origin.y];
            blurEffectView.alpha = alpha;
            //infoButton.alpha = 1 - alpha;
        }
        if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
        {
            if(frame.origin.y + frame.size.height >= (PEEK_Y_START-64) - 64){
                [self animatePeekViewIn];
                [currentDropPage mute];
            }else{
                [self animatePeekViewOut];
                [currentDropPage unmute];
                if(!isAboutToleaveBucket){
                   // [currentDropPage startVideo];
                }
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

-(void)onMediaPostedDrop:(DropModel *)drop{
    [lastUploadedDropPage.drop setId:drop.Id];
    [lastUploadedDropPage.drop setTemperature:drop.temperature];
    [lastUploadedDropPage bindTemperatureChanges];
    infoButton.hidden = NO;
    [peekViewController updatePeekView:[lastUploadedDropPage.drop user]];
    [self showSuperButton];
    
}

-(void)showSuperButton{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [[self superButton] getButton].alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         //[self showToolButtons];
                     }];
}


# pragma SuperButton callbacks
-(void)prepareCamera{
    if(cameraView == nil){
        cameraView = self.camera.view;
        [cameraHolder addSubview:cameraView];
    }
}


-(void)onCameraOpen{
    [currentDropPage stopVideo];
    [self.camera prepareCamera:YES withReply:YES];
    [DataHelper setCurrentBucketId:bucket.Id];
    
    cameraMode = YES;
    
    DropModel *replyDrop = [[DropModel alloc] init];
    
    [replyDrop setUser:user];
    [bucket addDrop:replyDrop];
    [self updatePageIndicator:[bucket drops].count-1];
    currentDropPage = [self viewControllerAtIndex:[bucket.drops count]-1 replacingObject:nil];
    NSArray *viewControllers = @[currentDropPage];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:^(BOOL finished){
                                         cameraHolder.hidden = NO;
                                         canPeek = NO;
                                         infoButton.hidden = YES;
                                     }];
    
    
    //Animate to last drop and add new drop
    
    
    
    // chat.view.hidden = YES;
    //Scroller.userInteractionEnabled = NO;
    // [self removeLastDrop];
    //DropView *plcCamera = ;
    //[plcCamera addSubview:cameraView];
    //currentView = [self addImageWithCamera];
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
        // CGPoint bottomOffset = CGPointMake(Scroller.contentSize.width - Scroller.bounds.size.width, 0);
        dispatch_async(main_queue, ^{
        });
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             //[Scroller setContentOffset:bottomOffset animated:NO];
                         }
                         completion:^(BOOL finished){
                             
                             //[self showToolButtons];
                             
                             
                         }];
        
        
        
    });
    //[self.camera prepareCamera:YES withReply:YES];
    
}

-(void)onCameraClose{
    cameraMode = NO;
    //infoButton.hidden = NO;
    [super onCameraClose];
}


-(void)showCamera{
    
}

-(void)onCancelTap{
    [super onCancelTap];
    cameraHolder.hidden = YES;
    
    NSArray *viewControllers = @[[self viewControllerAtIndex:[bucket.drops count]-2 replacingObject:nil]];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:^(BOOL finished){
                                         canPeek = YES;
                                         [bucket removeLastDrop];
                                         [self updatePageIndicator:[bucket drops].count-1];
                                     }];
    // Scroller.userInteractionEnabled = YES;
    //PageCount -=1;
    //[currentView removeFromSuperview];
    //Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    //ViewSize = CGRectOffset(ViewSize, -Scroller.bounds.size.width, 0);
    //[self addDropToBucket:[[DropModel alloc] initWithTestData:@"169.jpg" withName:@"Chris"]];
    // [self addDropToBucket:[[bucket drops] objectAtIndex:0]];
    //self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 2];
}

-(void)onVideoTaken:(NSData *)video withImage:(UIImage *)image withtext:(NSString *)text{
    cameraHolder.hidden = YES;
    [currentDropPage drop].media_type = 1;
    [currentDropPage drop].media_tmp = video;
    [currentDropPage setIsStartingView:YES];
    [currentDropPage bindToModel];
    lastUploadedDropPage = currentDropPage;
    // Scroller.userInteractionEnabled = YES;
    //  [currentView setMedia:video withIndexId:(int)[drops count]];
    // [drops addObject:currentView];
    // self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 1];
    // [self addDropToBucket:[[bucket drops] objectAtIndex:0]];
    // DropView *firstDrop = [drops objectAtIndex:0];
    //[firstDrop setMedia:video];
    //playButton.hidden = NO;
    // chat.view.hidden = NO;
    
}
-(void)onImageTaken:(UIImage *)image withText:(NSString *)text{
    cameraHolder.hidden = YES;
    [currentDropPage drop].media_type = 0;
    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    [currentDropPage drop].media_tmp = UIImagePNGRepresentation([GraphicsHelper imageByScalingAndCroppingForSize:size img:image]);
    [currentDropPage bindToModel];
    lastUploadedDropPage = currentDropPage;
    
    // Scroller.userInteractionEnabled = YES;
    
    //[self.camera.view removeFromSuperview];
    //[currentView setMedia:[GraphicsHelper imageByScalingAndCroppingForSize:size img:image] withIndexId:(int)[drops count]];
    // currentView.image = [GraphicsHelper imageByScalingAndCroppingForSize:size img:image];
    //[drops addObject:currentView];
    //self.dropsAmount.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, [drops count] - 1];
    //[self addDropToBucket:[[bucket drops] objectAtIndex:0]];
    // UIImageView *firstDrop = [drops objectAtIndex:0];
    //firstDrop.image = image;
    //[chat hideChat];
    
}


#pragma GESTURE delegates

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]){
        return NO;
    }
    if ([gestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]] ) {
        UISwipeGestureRecognizer *swipe = (UISwipeGestureRecognizer *)gestureRecognizer;
        if(swipe.direction == UISwipeGestureRecognizerDirectionDown){
            return YES;
        }
        if(isPeeking || cameraMode || infoViewMode){
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



@end
