//
//  ActivityViewController.h
//  wave
//
//  Created by Simen Lie on 17/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractFeedViewController.h"
#import "FeedModel.h"
@interface ActivityViewController : AbstractFeedViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) FeedModel *feedModel;
@property (nonatomic) bool shouldHidePeek;
@property (nonatomic) bool noBucketsInFeed;
@property (nonatomic) bool readyForExpanding;
@property (nonatomic, copy) void (^onFeedRefreshed)(BOOL(hasElementsInFeed));
-(void)initialize;
-(UIView *)getCameraHolder;



@end
