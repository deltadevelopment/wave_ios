//
//  SearchViewController.h
//  wave
//
//  Created by Simen Lie on 19.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserFeed.h"
#import "AbstractFeedViewController.h"
@interface SearchViewController : AbstractFeedViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating,UISearchControllerDelegate, UIBarPositioningDelegate>
- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UserFeed *userFeed;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end