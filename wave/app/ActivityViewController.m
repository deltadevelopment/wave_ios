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
    //self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollUp{
    [super scrollUp];
    // self.labelTest.text = @"cameraMODE";
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!cameraMode){
        NSIndexPath *oldIndex = indexCurrent;
        indexCurrent = indexPath;
        if(indexCurrent == oldIndex){
            //indexCurrent = nil;
            if(shouldExpand){
                shouldExpand = false;
            }else{
                shouldExpand = true;
            }
            
        }else{
            shouldExpand = true;
        }
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    
    
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
    
    //cell.bucketImage.contentMode = UIViewContentModeCenter;
    cell.bucketImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.bucketImage.clipsToBounds = YES;
    [cell insertSubview:cell.topBar aboveSubview:cell.bucketImage];
   //[cell insertSubview:cell.bottomBar aboveSubview:cell.bucketImage];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.displayNameText.text = [feed objectAtIndex:indexPath.row];
   
    
    
    [cell.bucketImage setUserInteractionEnabled:YES];
    [cell setUserInteractionEnabled:YES];
    [UIHelper applyThinLayoutOnLabel:cell.displayNameText withSize:18 withColor:[UIColor blackColor]];
    [UIHelper roundedCorners:cell.profilePictureIcon withRadius:15];
    [UIHelper roundedCorners:cell.availabilityIcon withRadius:7.5];
    cell.topBar.alpha = 0.9;
    cell.bottomBar.alpha = 0.9;
    /*
    if(cameraMode && indexPath.row == 0){
        NSLog(@"skal ta bilde");
        CGRect frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight] - 64);
        cameraView.frame = frame;
        [cell.bucketImage insertSubview:cameraView atIndex:0];

        cameraView.frame = frame;
        
       
    }
     */
    NSLog(@"Img taken : %@, row: %ld", imgTaken != nil ? @"ER BIKDE" : @"IKKE bilde", (long)indexPath.row);
    if(imgTaken != nil && indexPath.row == 0){
       // [cameraView removeFromSuperview];
       // cell.bucketImage.image = imgTaken;
       
    }else{
        cell.bucketImage.image = [UIImage imageNamed:@"169.jpg"]; //[self createImage];
    }
   
    return cell;
    
}

-(UIImage*)createImage{
    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    return  [UIHelper imageByScalingAndCroppingForSize:size img:[UIImage imageNamed:@"169.jpg"]];
}

-(void)prepareCamera:(UIView *)view{
    //[self.tableView addSubview:view];
    if(cameraView == nil){
        cameraView = view;
     
    }
  
    
}
/*
 -(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 NSLog(@"dsipla");
 if(cameraMode && indexPath.row == 0){
 CGRect frame = cell.frame;
 frame.size.height = 0;
 cell.frame = frame;
 
 }
 
 }
 */
-(void)onCameraOpen{
_tableView.scrollEnabled = NO;
     [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
   //[feed insertObject:@"Chris" atIndex:0];
    cameraMode = YES;
    
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    shouldExpand = true;
    indexCurrent = newIndexPath;
   

    //[self.tableView reloadData];
 ActivityTableViewCell *cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(![[feed objectAtIndex:0] isEqualToString:@"Simen"]){
        NSLog(@"her");
        [feed insertObject:@"Simen" atIndex:0];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        cell = (ActivityTableViewCell  *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.bucketImage addSubview:cameraView];
       
    }
    else{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
         [cell.bucketImage addSubview:cameraView];
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
    NSLog(@"img");
    //UIImageWriteToSavedPhotosAlbum(imgTaken, nil, nil, nil);
    cameraMode = NO;
    shouldExpand = NO;
    indexCurrent = nil;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)addConstraintsToCamera:(UIView *) view
{
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:cameraView
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:cameraView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:cameraView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:cameraView
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
