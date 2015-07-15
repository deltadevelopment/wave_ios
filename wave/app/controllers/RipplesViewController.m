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
#import "DataHelper.h"
//static int TABLE_CELLS_ON_SCREEN = 6;
@interface RipplesViewController ()

@end

@implementation RipplesViewController{
   // NSMutableArray *notifications;
    bool shouldExpand;
    NSIndexPath *indexCurrent;
    int maxWidth;
    CGRect cellFrame;
    int currentBucketId;
    int currentDropId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //notifications = [[NSMutableArray alloc] init];
    self.ripplesFeedModel =[[RipplesFeed alloc] init];
       __weak typeof(self) weakSelf = self;
    [ApplicationHelper setBlock:^(){
        NSLog(@"EXECUTING");
        [weakSelf setGotNotificationNow:YES];
        [weakSelf refreshFeed];
        [DataHelper storeRippleCount:0];
    }];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [DataHelper storeRippleCount:0];
    [DataHelper getNotificationLabel].hidden = YES;
    [self.navigationItem setTitle: NSLocalizedString(@"ripples_title", nil)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    //[self refreshFeed];
   
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [ColorHelper magenta];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self startRefreshing];
    
    UILabel *noNotificationsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [UIHelper getScreenWidth] - 40, 50)];
    [noNotificationsLabel setTextColor:[UIColor blackColor]];
    [noNotificationsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-ThinItalic" size:17.0f]];
    [noNotificationsLabel setText:NSLocalizedString(@"ripples_info_txt", nil)];
    [self.view addSubview:noNotificationsLabel];
}
-(void)viewWillDisappear:(BOOL)animated{
    [DataHelper storeRippleCount:0];
    [DataHelper getNotificationLabel].hidden = YES;
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
    [self.ripplesFeedModel getFeed:^{
         [weakSelf stopRefreshing];
        if(![self.ripplesFeedModel hasNotifications]){
            self.tableView.hidden = YES;
        }else{
           
        }
        [self.tableView reloadData];
    } onError:^(NSError *error){
        //NSLog(@"%@", [error localizedDescription]);
    }];
}

-(void)stopRefreshing{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    //NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    //NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                            //    forKey:NSForegroundColorAttributeName];
   // NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    //self.refreshControl.attributedTitle = attributedTitle;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.ripplesFeedModel feed] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RipplesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ripplesCell" forIndexPath:indexPath];
    RippleModel *rippleModel = [[self.ripplesFeedModel feed] objectAtIndex:indexPath.row];
    
       __weak typeof(self) weakSelf = self;
    if(!cell.isInitialized){
        //UI initialization
        [cell initalize];
    }
    cell.onUserTap = ^(RippleModel *ripple){
        [weakSelf showProfile:ripple];
    };
    cell.onBucketTap = ^(RippleModel *ripple, RipplesTableViewCell *cell){
        [weakSelf showBucketNormally:ripple withCell:cell];
    };
    cell.onDropTap = ^(RippleModel *ripple, RipplesTableViewCell *cell){
        [weakSelf showDropNormally:ripple withCell:cell];
    };
    [cell.profilePictureImage setImage:[UIImage imageNamed:@"user-icon-gray.png"]];
   
    //cell.notificationLabel.text = [rippleModel message];
    NSString *username = [rippleModel.interaction GetCurrentUser] != nil ? [[rippleModel.interaction GetCurrentUser] username] :@"N/A";
    cellFrame = [cell makeTextClickableAndLayout:username
                                  withRestOfText: [rippleModel addSpaceToString:[rippleModel.interaction localizedMessage]] withRippleId:rippleModel.Id withRipple:rippleModel];
    [cell.userButton setTitle:@"simenlie" forState:UIControlStateNormal];
    maxWidth = cell.textView.frame.size.width;
    cell.NotificationTimeLabel.text = [rippleModel created_at] ? [rippleModel created_at] : @"test";
    //  [cell calculateHeight];
    if (self.gotNotificationNow && indexPath.row == 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:0.961 green:0.973 blue:0.98 alpha:1]];
        self.gotNotificationNow = NO;
    }else{
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    if(cellFrame.size.height <50){
        [cell updateUiWithHeight:60];
        [cell initActionButton:rippleModel withCellHeight:60];
    }
    else{
        [cell updateUiWithHeight:cellFrame.size.height + 20];
        [cell initActionButton:rippleModel withCellHeight:cellFrame.size.height + 20];
    }
    return cell;
}

-(void)showProfile:(RippleModel *) ripple{
    AbstractFeedViewController *profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"activity"];
    [profileController setViewMode:1];
    [profileController setIsDeviceUser:NO];
    [profileController setAnotherUser:[ripple.interaction GetCurrentUser]];
    [profileController hidePeekFirst];
    
    [self.view insertSubview:profileController.view atIndex:0];
    [self addChildViewController:profileController];
    CGRect frame = profileController.view.frame;
    frame.origin.y = -[UIHelper getScreenHeight];
    profileController.view.frame = frame;
    [profileController layOutPeek];
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStylePlain
                                     target:nil
                                     action:nil];
    
    [[ApplicationHelper getMainNavigationController] pushViewController:profileController animated:YES];
}

-(void)showBucketNormally:(RippleModel *)ripple
                 withCell:(RipplesTableViewCell *) cell
{
    if ([[ripple.interaction topic_type] isEqualToString:@"Tag"]) {
        NSLog(@"TAG BUCKET YES");
        currentBucketId = [[ripple.interaction.tag bucket] Id];
        NSLog(@"the bucket is id %d", currentBucketId);
    }else{
        currentBucketId = [[ripple.interaction bucket] Id];
    }
    
    [self tableView:self.tableView didSelectRowAtIndexPath:[self.tableView indexPathForCell:cell]];
}
-(void)showDropNormally:(RippleModel *)ripple
               withCell:(RipplesTableViewCell *) cell
{
    currentBucketId = [[ripple.interaction drop] bucket_id];
    [self tableView:self.tableView didSelectRowAtIndexPath:[self.tableView indexPathForCell:cell]];
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


-(void)expandBucketWithId:(int) Id withDrop:(int) dropId{
    // ActivityTableViewCell *cell = (ActivityTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:Id inSection:0]];
    BucketModel *bucket = [[BucketModel alloc] init];
    [bucket setId:Id];
    DropModel *drop = [[DropModel alloc] init];
    [drop setId:dropId];
    [bucket addDrop:drop];

    [self changeToBucket:bucket withDropId:dropId];
   
   // self.onExpand(bucket);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RippleModel *rippleModel = [[self.ripplesFeedModel feed] objectAtIndex:indexPath.row];
 
    if (![rippleModel.interaction.topic_type isEqualToString:@"Subscription"]) {
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
                [self navigateWithRipple:rippleModel];
            }
            
        }];
        
        [tableView beginUpdates];
        [tableView endUpdates];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [CATransaction commit];
    }

}

-(void)navigateWithRipple:(RippleModel *) ripple{
    if ([ripple.interaction.topic_type isEqualToString:@"Drop"]) {
        [self expandBucketWithId:[ripple.interaction.drop bucket_id] withDrop:ripple.interaction.drop.Id];
    }
    else if ([ripple.interaction.topic_type isEqualToString:@"Bucket"]) {
        [self expandBucketWithId:[ripple.interaction.bucket Id] withDrop:0];
    }
    else if ([ripple.interaction.topic_type isEqualToString:@"Vote"]) {
        [self expandBucketWithId:[ripple.interaction.temperature bucket_id] withDrop:[ripple.interaction.temperature drop_id]];
    }
    else if ([ripple.interaction.topic_type isEqualToString:@"Subscription"]) {
        //Dont do anything
    }
    else if ([ripple.interaction.topic_type isEqualToString:@"Tag"]) {
        
        if ([ripple.interaction.tag.taggable_type isEqualToString:@"Bucket"]) {
            [self expandBucketWithId:[ripple.interaction.tag.bucket Id] withDrop:0];
        }else{
            [self expandBucketWithId:[ripple.interaction.tag.drop bucket_id] withDrop:ripple.interaction.tag.drop.Id];
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([indexPath isEqual:indexCurrent] && shouldExpand)
    {
        return [UIHelper getScreenHeight] - 64;
    }
  
    else {
        /*
        RippleModel *rip =[[self.ripplesFeedModel feed] objectAtIndex:indexPath.row];
        NSArray *compt = [[[self.ripplesFeedModel feed] objectAtIndex:indexPath.row] getComputedString];
        NSString *text2 = [NSString stringWithFormat:@"%@ %@", [compt objectAtIndex:0],[compt objectAtIndex:1]];
        NSString *text = [[[self.ripplesFeedModel feed] objectAtIndex:indexPath.row] message];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:15]};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [text2 boundingRectWithSize:CGSizeMake(70.f, CGFLOAT_MAX)
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:attributes
                                         context:nil];
        NSLog(@"the max width is %f", rect.size.height);
        
        return rect.size.height;
        return ([UIHelper getScreenHeight] - 64)/TABLE_CELLS_ON_SCREEN;
         */
         //RipplesTableViewCell *cell = (RipplesTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if(cellFrame.size.height <50){
           
            
            
            return 60;
        }
       
        return cellFrame.size.height + 20;
    }
}

-(void)changeToBucket:(BucketModel *) bucket withDropId:(int)dropId{
    //Same as onExpand in activity
    BucketController *bucketController = [[BucketController alloc] init];
    
        [bucketController setBucket:bucket withCurrentDropId:dropId];
    
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
