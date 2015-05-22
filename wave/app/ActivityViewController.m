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
#import "BucketController.h"
#import "DropModel.h"
#import "BucketModel.h"
#import "ApplicationHelper.h"
#import "SuperViewController.h"
#import "DataHelper.h"
#import "GraphicsHelper.h"
#import "FeedModel.h"
#import "UserModel.h"
@interface ActivityViewController ()

@end
const int EXPAND_SIZE = 400;
@implementation ActivityViewController{
   // NSMutableArray *feed;
    FeedModel *feedModel;
    UserModel *userModel;
    bool shouldExpand;
    NSIndexPath *indexCurrent;
    UIView *cameraView;
    bool cameraMode;
    UIImage *imgTaken;
    BucketController *bucketController;
    UIView *cameraHolder;
    UIView *errorView;
    
    int indexValue;
    
}

- (void)viewDidLoad {
    NSLog(@"<ActivityViewController STARTED>");
    [super viewDidLoad];
    bucketController = [[BucketController alloc] init];
    feedModel = [[FeedModel alloc] init];
    userModel = [[UserModel alloc] initWithDeviceUser];

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
}

-(void)startRefreshing{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    } completion:^(BOOL finished) {
       
        
    }];
     [self.refreshControl beginRefreshing];
    [self refreshFeed];
}

-(void)refreshFeed{
    __weak typeof(self) weakSelf = self;
    [feedModel getFeed:^{
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
    BucketModel *bucket = [[feedModel feed] objectAtIndex:Id];
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
    return [[feedModel feed] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"activityCell";
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(!cell.isInitialized){
        //Applying GUI to cell first time
        [cell initialize];
    }
    //Updating cell from changes in bucket
    [cell update:[[feedModel feed] objectAtIndex:indexPath.row]];
    return cell;
}

#pragma Camera methods

-(void)prepareCamera:(UIView *)view{
    if(cameraView == nil){
        cameraView = view;
        [cameraHolder addSubview:cameraView];
    }
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


-(void)animationIsDone{
    
}

-(void)onCameraReady{

}

-(void)oncameraClose{
   // ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //cell.bucketImage.image = nil;
    
    _tableView.scrollEnabled = YES;
}

-(void)mediaTaken:(UIImage *) image withText:(NSString *) text{
    cameraHolder.hidden = YES;
    imgTaken = image;
    if([text isEqualToString:@""]){
        //personal bucket
        if([feedModel isYourBucketInFeed]){
            indexValue = [feedModel personalBucketIndex];
        }
        [[feedModel feed] removeObjectAtIndex:0];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self updat:text];
        }];
        [self.tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [CATransaction commit];
        
    }else{
        indexValue = 0;
        [self updat:text];
    }

   
}
-(void)updat:(NSString *) text{
    //[cameraView removeFromSuperview];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

    NSLog(@"index value: %d", indexValue);
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0]];
    cell.bucketImage.image = imgTaken;
    cell.displayNameText.text = [text isEqualToString:@""] ? [userModel usernameFormatted] : text;
    [cell startSpinnerAnimtation];
    //cameraCell.bucketImage.image = imgTaken;
    BucketModel *bucket = [[feedModel feed] objectAtIndex:indexValue];
    
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

-(void)onImageTaken:(UIImage *)image withText:(NSString *)text{
    [self mediaTaken:image withText:text];
   // [self uploadMedia:UIImagePNGRepresentation(image)];
}
-(void)onVideoTaken:(NSData *)video withImage:(UIImage *)image withtext:(NSString *)text{
    [self mediaTaken:image withText:text];
   // [self uploadMedia:video];
  //  NSLog(@"File size is : %.2f MB",(float)video.length/1024.0f/1024.0f);
}

-(void)onMediaPosted:(BucketModel *)bucket{
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell stopSpinnerAnimation];
    NSLog(@"DROPCOUTN %lu",  (unsigned long)[[bucket drops] count]);
    [[feedModel feed] replaceObjectAtIndex:0 withObject:bucket];
     [cell update:[[feedModel feed] objectAtIndex:indexValue]];
}

-(void)onMediaPostedDrop:(DropModel *)drop{
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexValue inSection:0]];
    [cell stopSpinnerAnimation];
    BucketModel *bucket = [[feedModel feed] objectAtIndex:indexValue];
    [bucket addDropToFirst:drop];
    [[feedModel feed] replaceObjectAtIndex:indexValue withObject:bucket];
     [cell update:[[feedModel feed] objectAtIndex:indexValue]];
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
    [[feedModel feed] removeObjectAtIndex:0];
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
