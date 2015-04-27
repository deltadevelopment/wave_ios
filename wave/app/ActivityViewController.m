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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    feed = [[NSMutableArray alloc]init];
    [feed addObject:@"Chris"];
    [feed addObject:@"Christian"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            [self expandBucket];
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

-(void)expandBucket{
    self.onExpand();
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
        [cell initialize];
    }
    cell.displayNameText.text = [feed objectAtIndex:indexPath.row];
    if(imgTaken == nil){
        cell.bucketImage.image = [UIImage imageNamed:@"169.jpg"]; //[self createImage];
    }else{
        indexPath.row != 0 ? cell.bucketImage.image = [UIImage imageNamed:@"169.jpg"] : nil;
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
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    cameraMode = YES;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    shouldExpand = true;
    indexCurrent = newIndexPath;
    
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(![[feed objectAtIndex:0] isEqualToString:@"Simen"]){
        NSLog(@"her");
        [feed insertObject:@"Simen" atIndex:0];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.bucketImage addSubview:cameraView];
        cell.bottomBar.alpha = 0.0;
        
    }
    else{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
         [cell.bucketImage addSubview:cameraView];
        cell.bottomBar.alpha = 0.0;
    }
}
-(void)onCameraReady{
    NSLog(@"ready");
}

-(void)oncameraClose{
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.bucketImage.image = nil;
    _tableView.scrollEnabled = YES;
}

-(void)onImageTaken:(UIImage *)image{
    imgTaken = image;
    [cameraView removeFromSuperview];
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.bucketImage.image = imgTaken;
    cell.bottomBar.alpha = 1.0;
    cameraMode = NO;
    shouldExpand = NO;
    indexCurrent = nil;
    [self.tableView beginUpdates];
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
