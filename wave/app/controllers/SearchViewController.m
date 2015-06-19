//
//  SearchViewController.m
//  wave
//
//  Created by Simen Lie on 19.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "ColorHelper.h"
#import "CarouselController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
  // self.searchMode = YES;
    //self.tagMode = NO;
  [self.navigationItem setTitle:@"Subscriptions"];
    
    self.userFeed = [[UserFeed alloc] init];
    if (self.searchMode) {
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        self.searchController.dimsBackgroundDuringPresentation = NO;
        if(!self.tagMode){
            self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"@",@"user"),
                                                                  NSLocalizedString(@"#",@"hashtag")];
        }
        self.searchController.searchBar.delegate = self;//(CarouselController *)[self carouselParent];
        self.searchController.searchResultsUpdater = self;//(CarouselController *)[self carouselParent];
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        
        self.tableView.tableHeaderView = self.searchController.searchBar;
     // self.definesPresentationContext = YES;
        [self.searchController.searchBar sizeToFit];
        self.tableView.tableHeaderView.backgroundColor = [UIColor blueColor];
        [self.searchController.searchBar setBarTintColor:[UIColor whiteColor]];
        [self.searchController.searchBar setBackgroundColor:[UIColor whiteColor]];
        self.searchController.searchBar.barTintColor = [UIColor whiteColor];
        self.tableView.tableHeaderView.tintColor = [ColorHelper purpleColor];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [ColorHelper purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
       [self startRefreshing];
    UILabel *noUsersLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 74, [UIHelper getScreenWidth] - 40, 50)];
    [noUsersLabel setTextColor:[UIColor blackColor]];
    [noUsersLabel setFont:[UIFont fontWithName:@"HelveticaNeue-ThinItalic" size:17.0f]];
    [noUsersLabel setText:@"No Subscribers yet"];
    [self.view addSubview:noUsersLabel];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    //[self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    //[self.tableView reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"CLICKED");
    
}


- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    NSLog(@"select %ld", (long)selectedScope);
    
    [self updateSearchResultsForSearchController:self.searchController];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar {
    NSLog(@"here4");
    [(CarouselController *)[self carouselParent] setScrollEnabled:NO forPageViewController:[(CarouselController *)[self carouselParent] pageViewController]];
    //[self ShowMySearch];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
 
    return YES;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
     [(CarouselController *)[self carouselParent] setScrollEnabled:YES forPageViewController:[(CarouselController *)[self carouselParent] pageViewController]];
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
    [self.userFeed getFeed:^{
        [weakSelf stopRefreshing];
        if(![self.self.userFeed hasUsers]){
            self.tableView.hidden = YES;
            NSLog(@"no users yets");
            
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
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    //self.refreshControl.attributedTitle = attributedTitle;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}


-(void)viewDidLayoutSubviews{
    if(self.searchMode){
        self.topConstraint.constant = 0;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
   SubscribeModel *subscribeModel = [[self.userFeed feed] objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    if(!cell.isInitialized){
        //UI initialization
        [cell initalizeWithMode:NO];
    }
    [cell updateUI:subscribeModel];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"the count for subscribers is %lu", (unsigned long)[[self.userFeed feed] count]);
    return [[self.userFeed feed] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
        return 60;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelAction:(id)sender {
    [self dismiss];
}

- (IBAction)doneAction:(id)sender {
    [self dismiss];
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
