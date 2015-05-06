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
    ActivityTableViewCell *cameraCell;
    ActivityTableViewCell *topCell;
    BucketController *bucketController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    feed = [[NSMutableArray alloc]init];
    [feed addObject:@"Chris"];
    [feed addObject:@"Christian"];
    [feed addObject:@"Chris"];
    [feed addObject:@"Christian"];
    [feed addObject:@"Chris"];
    [feed addObject:@"Christian"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    bucketController = [[BucketController alloc] init];
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
            // animation has finished
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
        NSLog(@"CELL ER NULL");
        cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(!cell.isInitialized){
        [cell initialize];
    }
    cell.displayNameText.text = [feed objectAtIndex:indexPath.row];
    if(imgTaken == nil){
        cell.bucketImage.image = [UIImage imageNamed:@"169.jpg"]; //[self createImage];
        
    }else{
        indexPath.row != 0 ? cell.bucketImage.image = [UIImage imageNamed:@"169.jpg"] : nil;
    }

    if([[feed objectAtIndex:indexPath.row] isEqual: @"Simen"]){
        if(!cameraMode){
            [cameraView removeFromSuperview];
        }
        NSLog(@"-----------------------");
        cameraCell = cell;
        cameraCell.profilePictureIcon.image = [UIImage imageNamed:@"bucket.png"];
        
    }
    else{
        if(!cameraMode){
            [cameraView removeFromSuperview];
        }
        cameraCell.profilePictureIcon.image = [UIImage imageNamed:@"miranda-kerr.jpg"];
        cameraCell = nil;
        [cameraView removeFromSuperview];
    }
   
   
    
    
    return cell;
}

#pragma Camera methods

-(void)prepareCamera:(UIView *)view{
    if(cameraView == nil){
        cameraView = view;
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
    
    if(![[feed objectAtIndex:0] isEqualToString:@"Simen"]){
        NSLog(@"_______LEGGER TIL");
        [feed insertObject:@"Simen" atIndex:0];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [cameraCell.bucketImage addSubview:cameraView];
        }];
   
   
        [self.tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [CATransaction commit];
        //topCell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSLog(@"LEGGER TIL KAMERA VIEW");
        //[topCell.bucketImage addSubview:cameraView];
        
      //  cameraCell.bottomBar.alpha = 0.0;
    }
    else{
        //FIKS for å få kamera view opp alle ganger
        cameraCell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [cameraCell.bucketImage addSubview:cameraView];
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
    imgTaken = image;
    //[cameraView removeFromSuperview];
    //ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cameraCell.bucketImage.image = imgTaken;
    //cell.bottomBar.alpha = 1.0;
    //cameraCell = cell;
    cameraMode = NO;
    shouldExpand = NO;
    indexCurrent = nil;
     self.onLockScreenToggle();
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)onCancelTap{
    //[cameraView removeFromSuperview];
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
