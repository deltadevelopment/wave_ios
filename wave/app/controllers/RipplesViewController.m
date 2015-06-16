//
//  RipplesViewController.m
//  wave
//
//  Created by Simen Lie on 15/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RipplesViewController.h"
#import "RipplesTableViewCell.h"
#import "DataHelper.h"
#import "RippleModel.h"
#import "BucketController.h"
#import "RipplesFeed.h"
static int TABLE_CELLS_ON_SCREEN = 6;
@interface RipplesViewController ()

@end

@implementation RipplesViewController{
   // NSMutableArray *notifications;
    bool shouldExpand;
    NSIndexPath *indexCurrent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //notifications = [[NSMutableArray alloc] init];
    self.ripplesFeedModel =[[RipplesFeed alloc] init];
    
    
    [self.navigationItem setTitle:@"Ripples"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self refreshFeed];
    /*
    for(NSDictionary *dic in [DataHelper getNotifications]){
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        RippleModel *rippleModel = [[RippleModel alloc] init:mutDic];
        [notifications insertObject:rippleModel atIndex:0];
    }
   
    for(NSDictionary *dic in [DataHelper getNotifications]){
        
        NSLog(@"my dictionary is %@", dic);
    }
    NSLog(@"the size of the array is %lu", (unsigned long)[[DataHelper getNotifications] count]);
     */
    // Do any additional setup after loading the view.
}

-(void)refreshFeed{
    [self.ripplesFeedModel getFeed:^{
        //[weakSelf stopRefreshing];
        if(![self.ripplesFeedModel hasNotifications]){
            self.tableView.hidden = YES;
            NSLog(@"no notifications");
            
        
        }
        [self.tableView reloadData];
    } onError:^(NSError *error){
        //NSLog(@"%@", [error localizedDescription]);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"count is %lu", (unsigned long)[[self.ripplesFeedModel feed] count]);
    return [[self.ripplesFeedModel feed] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RipplesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ripplesCell" forIndexPath:indexPath];
    RippleModel *rippleModel = [[self.ripplesFeedModel feed] objectAtIndex:indexPath.row];
    
    
    if(!cell.isInitialized){
        //UI initialization
        [cell initalize];
    }
    [cell.profilePictureImage setImage:[UIImage imageNamed:@"miranda-kerr.jpg"]];
    //cell.notificationLabel.text = [rippleModel message];
    [cell.userButton setTitle:@"simenlie" forState:UIControlStateNormal];
    cell.NotificationTimeLabel.text = [rippleModel created_at] ? [rippleModel created_at] : @"test";
    [cell calculateHeight];
    return cell;
}




// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [[self.ripplesFeedModel feed] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)expandBucketWithId:(int) Id{
    // ActivityTableViewCell *cell = (ActivityTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:Id inSection:0]];
    BucketModel *bucket = [[BucketModel alloc] init];
    [bucket setId:Id];
    __weak typeof(self) weakSelf = self;
    [bucket find:^{
        NSLog(@"bucket count %@", [bucket bucket_type]);
         [weakSelf changeToBucket:bucket];
    
    } onError:^(NSError *error){
    
    }];
   // self.onExpand(bucket);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
            [self expandBucketWithId:2];
        }
        
    }];
    
    [tableView beginUpdates];
    [tableView endUpdates];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [CATransaction commit];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([indexPath isEqual:indexCurrent] && shouldExpand)
    {
        return [UIHelper getScreenHeight] - 64;
    }
  
    else {
        NSString *text = [[[self.ripplesFeedModel feed] objectAtIndex:indexPath.row] message];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:15]};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [text boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
        if(rect.size.height <55){
            return 60;
        }
        return rect.size.height - 16;
        return ([UIHelper getScreenHeight] - 64)/TABLE_CELLS_ON_SCREEN;
    }
    
    
    
    
    
    
}

-(void)changeToBucket:(BucketModel *) bucket{
    //Same as onExpand in activity
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

-(void)onFocusGained{
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

- (IBAction)actionButtonAction:(id)sender {
}
@end
