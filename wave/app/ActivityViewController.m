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
@interface ActivityViewController ()

@end
const int EXPAND_SIZE = 400;
@implementation ActivityViewController{
    NSMutableArray *feed;
    bool shouldExpand;
    NSIndexPath *indexCurrent;
    UIView *cameraView;
    bool cameraMode;
    UIImage *imgTaken;
    BucketController *bucketController;
    UIView *cameraHolder;
    UIView *errorView;
    UIRefreshControl *refreshControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bucketController = [[BucketController alloc] init];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [ColorHelper blueColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self startRefreshing];
    [self getFeed];
    //feed = [ApplicationHelper bucketTestData];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cameraHolder = [[UIView alloc]initWithFrame:CGRectMake(0, -64, [UIHelper getScreenWidth],[UIHelper getScreenHeight])];
    cameraHolder.backgroundColor = [UIColor whiteColor];
}

-(void)startRefreshing{
    if (self.tableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            self.tableView.contentOffset = CGPointMake(0, -refreshControl.frame.size.height);
        } completion:^(BOOL finished){
            
        }];
    }
    [refreshControl beginRefreshing];
}

-(void)refreshFeed{
    [self getFeed];
}

-(void)stopRefreshing{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    [refreshControl endRefreshing];
    NSLog(@"feed count %lu", (unsigned long)[feed count]);
    [self.tableView reloadData];
}

-(void)getFeed{
      __weak typeof(self) weakSelf = self;
    NSMutableArray *feedData = [[NSMutableArray alloc] init];
    [bucketController
     getFeed:^(ResponseModel *response){
     //Feed was returned
         NSMutableArray *rawFeed = [[response data] objectForKey:@"buckets"];
         for(NSMutableDictionary *rawBucket in rawFeed){
            BucketModel *bucket = [[BucketModel alloc] init:rawBucket];
            [feedData addObject:bucket];
             
         }
       feed = feedData;
       [weakSelf stopRefreshing];
     }
     onError:^(NSError *error){
         NSLog(@"%@", [error localizedDescription]);
    }];
}

-(void)viewDidLayoutSubviews{
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
    BucketModel *bucket = [feed objectAtIndex:Id];
    NSLog(@"BUCKET NAME: %@", bucket.title);
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
    return [feed count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell for");
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
    [cell update:[feed objectAtIndex:indexPath.row]];
    return cell;
}

#pragma Camera methods

-(void)prepareCamera:(UIView *)view{
    NSLog(@"prepping");
    if(cameraView == nil){
        cameraView = view;
        [cameraHolder addSubview:cameraView];
    }
}

-(void)onCameraOpen{
    _tableView.scrollEnabled = NO;
    self.onLockScreenToggle();
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    cameraMode = YES;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    shouldExpand = true;
    indexCurrent = newIndexPath;
    BucketModel *firstBucket = [feed objectAtIndex:0];
    
    if(![firstBucket.title isEqualToString:@"Simen"]){
 
        BucketModel *bucket = [[BucketModel alloc] init];
        DropModel *drop = [[DropModel alloc] init];
        //drop.media = @"169.jpg";
        bucket.drops = [[NSMutableArray alloc] initWithObjects:drop, nil];
        bucket.title = @"Simen";
        
        [feed insertObject:bucket atIndex:0];
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
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            cameraHolder.hidden = NO;
        }];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [CATransaction commit];
        
    }
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
    /*
     BucketModel *newBucket = [[BucketModel alloc] init];
     newBucket.Id = 3;
     newBucket.title = @"My new Crazy bucket";
     newBucket.bucket_description = @"My new crazy description";
     DropModel *newDrop = [[DropModel alloc] init];
     newDrop.caption = @"My crazy new drop!";
     newDrop.media_tmp = UIImagePNGRepresentation(image);
     newBucket.rootDrop = newDrop;
     
     [bucketController createNewBucket:newBucket
     onProgress:^(NSNumber *progression){
     NSLog(@"LASTET OPP: %@", progression);
     
     }
     onCompletion:^(BucketModel *bucket, ResponseModel *response){
     NSLog(@"ALT ER FERDIG LASTET OPP!");
     
     }];
     
     [bucketController updateBucket:newBucket
     onCompletion:^(ResponseModel *response){
     NSLog(@"BUCKET ENDRET");
     
     }];
     
     */
    cameraHolder.hidden = YES;
    imgTaken = image;
    //[cameraView removeFromSuperview];
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.bucketImage.image = imgTaken;
    cell.displayNameText.text = [text isEqualToString:@""] ? @"Simen Lie" : text;
    [cell startSpinnerAnimtation];
    //cameraCell.bucketImage.image = imgTaken;
    BucketModel *bucket = [feed objectAtIndex:0];
    
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
    NSLog(@"File size is : %.2f MB",(float)video.length/1024.0f/1024.0f);
}

-(void)onMediaPosted:(BucketModel *)bucket{
    NSLog(@"POSTEDT");
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell stopSpinnerAnimation];
    [feed replaceObjectAtIndex:0 withObject:bucket];
}

-(void)onMediaPostedDrop:(DropModel *)drop{
    NSLog(@"POSTEDT");
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell stopSpinnerAnimation];
    BucketModel *bucket = [feed objectAtIndex:0];
    [bucket addDrop:drop];
    [feed replaceObjectAtIndex:0 withObject:bucket];
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
    NSLog(@"cancelTAP");
    //[cameraView removeFromSuperview];
    cameraHolder.hidden = YES;
    self.onLockScreenToggle();
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    cameraMode = NO;
    shouldExpand = NO;
    indexCurrent = nil;
    [feed removeObjectAtIndex:0];
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
