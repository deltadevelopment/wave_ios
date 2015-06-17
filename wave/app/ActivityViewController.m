//
//  ActivityViewController.m
//  wave
//
//  Created by Simen Lie on 17/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import "UIHelper.h"
#import "DropModel.h"
#import "BucketModel.h"
#import "ApplicationHelper.h"
#import "SuperViewController.h"
#import "DataHelper.h"
#import "GraphicsHelper.h"
#import "FeedModel.h"
#import "UserModel.h"
#import "PeekViewController.h"
#import "PeekViewModule.h"
@interface ActivityViewController ()

@end
const int EXPAND_SIZE = 400;
@implementation ActivityViewController{
   // NSMutableArray *feed;
    UserModel *userModel;
    AuthHelper *authHelper;
    bool shouldExpand;
    NSIndexPath *indexCurrent;
    UIView *cameraView;
    bool cameraMode;
    UIImage *imgTaken;
    UIView *cameraHolder;
    UIView *errorView;
    int indexValue;
    int viewMode;
    UIStoryboard *storyboard;
    PeekViewController *peekViewController;
    PeekViewModule *peekViewModule;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    userModel =[[UserModel alloc] initWithDeviceUser:^(UserModel *user){
        userModel = user;
    } onError:^(NSError *error){}];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cameraHolder = [[UIView alloc]initWithFrame:CGRectMake(0, -64, [UIHelper getScreenWidth],[UIHelper getScreenHeight])];
    cameraHolder.backgroundColor = [UIColor whiteColor];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [ColorHelper blueColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self startRefreshing];
    
    self.tableView.backgroundColor = [ColorHelper blueColor];
    if(viewMode == 1){
        [self addPeekView];
    }
}

-(void)setViewMode:(int)mode{
    viewMode = mode;
}

-(void)initialize{
    
    if(viewMode == 0){
        self.feedModel = [[FeedModel alloc] init];
    }else{
        if(self.isDeviceUser){
            authHelper = [[AuthHelper alloc] init];
            NSString *url = [NSString stringWithFormat:@"user/%@/buckets", [authHelper getUserId]];
            self.feedModel = [[FeedModel alloc] initWithURL:url];
        }else{
             __weak typeof(self) weakSelf = self;
            self.onExpand=^(BucketModel*(bucket)){
                [weakSelf changeToBucket:bucket];
            };
            [self.navigationItem setTitle:self.anotherUser.username];
            NSString *url = [NSString stringWithFormat:@"user/%d/buckets", self.anotherUser.Id];
            self.feedModel = [[FeedModel alloc] initWithURL:url];
        }
       
    }
}

-(void)changeToBucket:(BucketModel *) bucket{
    BucketController *bucketController = [[BucketController alloc] init];
    [bucketController setBucket:bucket];
    //[((BucketController *)root) setSuperCarousel:self];
    __weak typeof(self) weakSelf = self;
    bucketController.onDespand = ^{
        [weakSelf removeBucketAsRoot];
    };
    //[root addViewController:self];
    
    //[self.navigationController setViewControllers:@[root] animated:NO];
    //[self.navigationController.view layoutIfNeeded];
    [self.navigationController pushViewController:bucketController animated:NO];
}

-(void)removeBucketAsRoot{
    //root = oldRoot;
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController.view layoutIfNeeded];
    //[self didGainFocus];
    [self onFocusGained];
}


-(void)addPeekView{
    peekViewModule = [[PeekViewModule alloc] initWithView:self.view withSubview:cameraHolder withController:self.navigationController];
     NSLog(@"hiding2");
    if(self.isDeviceUser){
        userModel =[[UserModel alloc] initWithDeviceUser:^(UserModel *user){
            [peekViewModule updateText:user];
        } onError:^(NSError *error){}];
    }else{
        [peekViewModule updateText:self.anotherUser];
    }
    
}

-(void)subscribeAction{
  
}

-(void)startRefreshing{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    } completion:^(BOOL finished) {
       
        
    }];
     [self.refreshControl beginRefreshing];
    [self refreshFeed];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(viewMode == 1){
    [peekViewModule fadeOut];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(viewMode == 1){
        [peekViewModule fadeIn];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        if(viewMode == 1){
            [peekViewModule fadeIn];
        }
    }
}

-(void)refreshFeed{
    __weak typeof(self) weakSelf = self;
    [self.feedModel getFeed:^{
        [weakSelf stopRefreshing];
    } onError:^(NSError *error){
        //NSLog(@"%@", [error localizedDescription]);
        
    }];
}

-(void)stopRefreshing{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}



-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    [self.view addSubview:cameraHolder];
    cameraHolder.hidden = YES;
    [self.view insertSubview:self.tableView belowSubview:cameraHolder];
    if(viewMode == 1){
        if(!self.shouldHidePeek){
            [peekViewModule layoutElementsWithSubview:cameraHolder];
        }else{
            [peekViewModule layoutBackgroundWithSubview:cameraHolder];
        }
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Tableview methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!cameraMode){
        NSIndexPath *oldIndex = indexCurrent;
        indexCurrent = indexPath;
        if(indexCurrent == oldIndex){
            if(shouldExpand){
                shouldExpand = false;
            }else{
                shouldExpand = true;
            }
        }else{
            shouldExpand = true;
        }
     
        [CATransaction begin];
        
        [CATransaction setCompletionBlock:^{
            if(shouldExpand){
                [self expandBucketWithId:(int)indexPath.row];
            }
            
        }];
        
        [tableView beginUpdates];
        [tableView endUpdates];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [CATransaction commit];
        
    }
}

-(void)onFocusGained{
    shouldExpand = NO;
    indexCurrent = nil;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)expandBucketWithId:(int) Id{
   // ActivityTableViewCell *cell = (ActivityTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:Id inSection:0]];
    BucketModel *bucket = [[self.feedModel feed] objectAtIndex:Id];
    self.onExpand(bucket);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([indexPath isEqual:indexCurrent] && shouldExpand)
    {
        return [UIHelper getScreenHeight] - 64;
    }
    else if([indexPath isEqual:indexCurrent]){
        return ([UIHelper getScreenHeight] - 64)/2;
    }
    else {
        return ([UIHelper getScreenHeight] - 64)/2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.feedModel feed] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"activityCell";
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(!cell.isInitialized){
        //Applying GUI to cell first time
        [cell initializeWithMode:viewMode withSuperController:self];
    }
    //Updating cell from changes in bucket
    [cell update:[[self.feedModel feed] objectAtIndex:indexPath.row]];
    return cell;
}

#pragma Camera methods

-(void)prepareCamera:(UIView *)view{
    if(cameraView == nil){
        cameraView = view;
        [cameraHolder addSubview:cameraView];
    }
}

-(void)layOutPeek{
    self.shouldHidePeek = NO;
    [peekViewModule layoutElementsWithSubview:cameraHolder];
}

-(void)onCameraOpen{
    /*
    _tableView.scrollEnabled = NO;
    self.onLockScreenToggle();

    if([feedModel isYourBucketInFeed]){
        indexValue = [feedModel personalBucketIndex];
    }
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    NSLog(@"test %d", indexValue);
    cameraMode = YES;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexValue inSection:0];
    shouldExpand = true;
    indexCurrent = newIndexPath;
    BucketModel *firstBucket = [[feedModel feed] objectAtIndex:indexValue];
    
    NSString *value = firstBucket.title;
    if([[firstBucket bucket_type] isEqualToString:@"user"]){
        value = [[firstBucket user] usernameFormatted];
    }
    
    if(![value isEqualToString:[userModel usernameFormatted]]){
 
        BucketModel *bucket = [[BucketModel alloc] init];
        DropModel *drop = [[DropModel alloc] init];
        //drop.media = @"169.jpg";
        bucket.drops = [[NSMutableArray alloc] initWithObjects:drop, nil];
        bucket.title = [userModel usernameFormatted];
        
        [[feedModel feed] insertObject:bucket atIndex:0];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            cameraHolder.hidden = NO;
        }];
        [self.tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [CATransaction commit];
    }
    else{
        NSLog(@"er samme");
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            cameraHolder.hidden = NO;
        }];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [CATransaction commit];
        
    }
     */
    
    [self test];
}

-(void)test{
    _tableView.scrollEnabled = NO;
    self.onLockScreenToggle();
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    cameraMode = YES;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexValue inSection:0];
    shouldExpand = true;
    indexCurrent = newIndexPath;

    BucketModel *bucket = [[BucketModel alloc] init];
    DropModel *drop = [[DropModel alloc] init];
    //drop.media = @"169.jpg";
    [bucket addDrop:drop];
    bucket.title = [userModel usernameFormatted];
    
    [[self.feedModel feed] insertObject:bucket atIndex:0];
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        cameraHolder.hidden = NO;
    }];
    [self.tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    [CATransaction commit];
}


-(void)animationIsDone{
    
}

-(void)onCameraReady{

}

-(void)oncameraClose{
   // ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //cell.bucketImage.image = nil;
    
    _tableView.scrollEnabled = YES;
}




-(void)onImageTaken:(UIImage *)image withText:(NSString *)text{
    [self mediaTaken:image withText:text isMediaVideo:NO];
    NSLog(@"Image taken in activity");
   // [self uploadMedia:UIImagePNGRepresentation(image)];
}
-(void)onVideoTaken:(NSData *)video withImage:(UIImage *)image withtext:(NSString *)text{
    [self mediaTaken:image withText:text isMediaVideo:YES];
   // [self uploadMedia:video];
  //  NSLog(@"File size is : %.2f MB",(float)video.length/1024.0f/1024.0f);
}

-(void)mediaTaken:(UIImage *) image withText:(NSString *) text isMediaVideo:(bool) isVideo{
    
    cameraHolder.hidden = YES;
    imgTaken = image;
    if([text isEqualToString:@""]){
        //personal bucket
        if([self.feedModel isYourBucketInFeed]){
            NSLog(@"personal bucket");
            indexValue = [self.feedModel personalBucketIndex];
        }
        [[self.feedModel feed] removeObjectAtIndex:0];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        //Scroll your bucket
          [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        
        ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0]];
        cell.bucketImage.image = imgTaken;
        cell.displayNameText.text = [text isEqualToString:@""] ? [userModel usernameFormatted] : text;
        [cell startSpinnerForUploadAnimtation];
        //cameraCell.bucketImage.image = imgTaken;
        BucketModel *bucket = [[self.feedModel feed] objectAtIndex:indexValue];
        DropModel *drop = [bucket.drops objectAtIndex:0];
        drop.media_img = imgTaken;
        drop.media_type = isVideo ? 1:0;
        if(isVideo){
            drop.thumbnail_tmp =(UIImagePNGRepresentation(imgTaken));
        }else{
            drop.media_tmp = (UIImagePNGRepresentation(imgTaken));
        }
       
        cameraMode = NO;
        shouldExpand = NO;
        indexCurrent = nil;
        self.onLockScreenToggle();
        [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0]];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        //set image to the new
        
        
        //
        
        /*
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self updat:text];
        }];
        [self.tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [CATransaction commit];
         */
        
    }else{
        indexValue = 0;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        BucketModel *bucket = [[self.feedModel feed] objectAtIndex:indexValue];
        bucket.user = userModel;
        bucket.Id = 9999;
        bucket.title = text;
        bucket.bucket_type = @"shared";
        
    
        ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0]];
        //cell.bucketImage.image = imgTaken;
        //cell.usernameText.hidden = NO;
        //cell.displayNameText.text = [text isEqualToString:@""] ? [userModel usernameFormatted] : text;
       // cell.usernameText.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"by_txt", nil), userModel.username];
        
        [cell startSpinnerForUploadAnimtation];
        //cameraCell.bucketImage.image = imgTaken;
      
        DropModel *drop = [[DropModel alloc] init];
        [bucket addDrop:drop];
        drop.media_img = imgTaken;
        drop.media_type = isVideo ? 1:0;
        if(isVideo){
            drop.thumbnail_tmp =(UIImagePNGRepresentation(imgTaken));
        }else{
            NSLog(@"NOT VIDEO");
            drop.media_tmp = (UIImagePNGRepresentation(imgTaken));
        }
        [cell update:bucket];
        cameraMode = NO;
        shouldExpand = NO;
        indexCurrent = nil;
        self.onLockScreenToggle();
        [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0]];
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    
    
}

-(void)updat:(NSString *) text{
    //[cameraView removeFromSuperview];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0]];
    cell.bucketImage.image = imgTaken;
    cell.displayNameText.text = [text isEqualToString:@""] ? [userModel usernameFormatted] : text;
    [cell startSpinnerAnimtation];
    //cameraCell.bucketImage.image = imgTaken;
    BucketModel *bucket = [[self.feedModel feed] objectAtIndex:indexValue];
    
    DropModel *drop = [bucket.drops objectAtIndex:0];
    drop.media_img = imgTaken;
    
    //bucket.isInitalized = NO;
    
    //cell.bottomBar.alpha = 1.0;
    //cameraCell = cell;
    cameraMode = NO;
    shouldExpand = NO;
    indexCurrent = nil;
    self.onLockScreenToggle();
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}

-(void)onMediaPosted:(BucketModel *)bucket{
    bucket.user = userModel;
    [bucket addDrop:[[[self.feedModel feed] objectAtIndex:0] getLastDrop]];
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell stopSpinnerForUploadAnimation];
    [[self.feedModel feed] replaceObjectAtIndex:0 withObject:bucket];
    /*
    
    [cell update:[[self.feedModel feed] objectAtIndex:indexValue]];
        NSLog(@"MEdia was posted");
     */
}

-(void)onMediaPostedDrop:(DropModel *)drop{
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell stopSpinnerForUploadAnimation];
    /*
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0]];
    [cell stopSpinnerAnimation];
    BucketModel *bucket = [[self.feedModel feed] objectAtIndex:indexValue];
    [bucket addDropToFirst:drop];
    [[self.feedModel feed] replaceObjectAtIndex:indexValue withObject:bucket];
     [cell update:[[self.feedModel feed] objectAtIndex:indexValue]];
      NSLog(@"MEdia was posted drop");
     */
}

-(void)hidePeekFirst{
    self.shouldHidePeek = YES;
    NSLog(@"hiding");
}

-(void)uploadMedia:(NSData *) media{
/*
     __weak typeof(self) weakSelf = self;
    [bucketController createNewBucket:media
                      withBucketTitle:@"My new Crazy bucket"
                withBucketDescription:@"My new crazy description"
                      withDropCaption:@"My crazy new drop!"
                           onProgress:^(NSNumber *progression)
     {
        NSLog(@"LASTET OPP: %@", progression);
         weakSelf.onProgression([progression intValue]);
         
         
     }
                         onCompletion:^(ResponseModel *response, BucketModel *bucket)
     {
        // NSString *strdata=[[NSString alloc]initWithData:[[response data] objectForKey:@"bucket"] encoding:NSUTF8StringEncoding];
        // NSLog(strdata);
         [feed replaceObjectAtIndex:0 withObject:bucket];
         NSLog(@"ALT ER FERDIG LASTET OPP!");
     } onError:^(NSError *error){
        [DataHelper storeData:media];
         //[weakSelf addErrorMessage];
         errorView = [GraphicsHelper getErrorView:[error localizedDescription]
                                          withParent:self
                                     withButtonTitle:@"Prøv igjen"
                           withButtonPressedSelector:@selector(uploadAgain)];
        
         
         weakSelf.onNetworkError(errorView);
      
     }];
 */
}

-(void)viewDidAppear:(BOOL)animated{
//animate the view down
}



-(void)viewWillDisappear:(BOOL)animated{
        
}

-(void)uploadAgain{
    [errorView removeFromSuperview];
    self.onNetworkErrorHide();
    [self uploadMedia:[DataHelper getData]];
    
}




-(void)onCancelTap{
    //[cameraView removeFromSuperview];
    cameraHolder.hidden = YES;
    self.onLockScreenToggle();
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    cameraMode = NO;
    shouldExpand = NO;
    indexCurrent = nil;
    [[self.feedModel feed] removeObjectAtIndex:0];
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
 
   
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
