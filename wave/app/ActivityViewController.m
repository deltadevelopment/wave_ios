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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //feed = [ApplicationHelper bucketTestData];
    
    feed = [ApplicationHelper bucketTestData];
    
    /*
         feed = [[NSMutableArray alloc]init];
    [feed addObject:@"Chris"];
    [feed addObject:@"Christian"];
    [feed addObject:@"Olav"];
    [feed addObject:@"Jakob"];
    [feed addObject:@"Jens"];
    [feed addObject:@"Rune"];
     */
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    bucketController = [[BucketController alloc] init];
    cameraHolder = [[UIView alloc]initWithFrame:CGRectMake(0, -64, [UIHelper getScreenWidth],[UIHelper getScreenHeight])];
    cameraHolder.backgroundColor = [UIColor whiteColor];
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
                [self expandBucketWithId:indexPath.row];
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
    ActivityTableViewCell *cell = (ActivityTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:Id inSection:0]];
    self.onExpand(cell.bucketImage.image);
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



-(void)onImageTaken:(UIImage *)image{
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
-(void)onVideoTaken:(NSData *)video withImage:(UIImage *)image{
    [self onImageTaken:image];
}


-(void)onCancelTap{
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
