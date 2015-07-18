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
#import "BucketController.h"
#import "ProfileViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController{
    NSTimer *searchTimer;
    NSInteger currentScopeIndex;
    NSString *currentSearchString;
    UIActivityIndicatorView *spinner;
    UILabel *noUsersLabel;
    UIView *wrapHolder;
    UIVisualEffectView  *blurEffectView;
    UIVisualEffectView  *blurEffectViewSearch;
    NavigationControlViewController *root;
    NavigationControlViewController *oldRoot;
    ProfileViewController *profileView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  // self.searchMode = YES;
    //self.tagMode = NO;
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    if (self.tagMode) {
        [self.navigationItem setTitle:NSLocalizedString(@"tagged_users_txt", nil)];
    }else {
        [self.navigationItem setTitle:NSLocalizedString(@"subscriptions_button_txt", nil)];
    }
    
    self.userFeed = [[UserFeed alloc] init];
    self.searchFeed = [[SearchModel alloc] init];
    self.tagFeed = [[TagSearchModel alloc] init];
    [self.tagFeed setBucketId:self.currentBucket.Id];
    if (self.searchMode) {
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        self.searchController.dimsBackgroundDuringPresentation = NO;
        if (self.searchMode && !self.tagMode) {
            //self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"@",@"user")];
        }else{
            self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"@",@"user"),
                                                                  NSLocalizedString(@"#",@"hashtag")];
        }
        
        self.searchController.searchBar.delegate = self;//(CarouselController *)[self carouselParent];
        self.searchController.searchResultsUpdater = self;//(CarouselController *)[self carouselParent];
        self.searchController.hidesNavigationBarDuringPresentation = NO;
     //
        if (self.tagMode) {
            //self.searchController.hidesNavigationBarDuringPresentation = YES;
         
           // self.tableView.tableHeaderView = self.searchController.searchBar;
             // self.definesPresentationContext = YES;
            wrapHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], 44)];
            [wrapHolder setTintColor:[UIColor purpleColor]];
            [wrapHolder addSubview:self.searchController.searchBar];
            CGRect frame = self.searchController.searchBar.frame;
            frame.size.height = [UIHelper getScreenWidth];
            self.searchController.searchBar.frame = frame;
            [self.searchController.searchBar setTintColor:[ColorHelper purpleColor]];
            /*
             [self.searchController.searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName , nil] forState:UIControlStateNormal];
             [self.searchController.searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor], NSForegroundColorAttributeName , nil] forState:UIControlStateSelected];
             */if([self.currentBucket.user Id] == [[[[AuthHelper alloc] init] getUserId] intValue]){
                 self.tableView.tableHeaderView = wrapHolder;
             }
            
        }
        //
        // [self.searchController.searchBar becomeFirstResponder];
        [self.searchController.searchBar sizeToFit];
       //self.tableView.tableHeaderView.backgroundColor = [UIColor blueColor];
        [self.searchController.searchBar setBarTintColor:[UIColor whiteColor]];
        [self.searchController.searchBar setBackgroundColor:[UIColor whiteColor]];
        self.searchController.searchBar.barTintColor = [UIColor whiteColor];
        self.tableView.tableHeaderView.tintColor = [ColorHelper purpleColor];
        self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //[self.tableView setContentOffset:CGPointMake(0,44) animated:YES];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [ColorHelper purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    noUsersLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, [UIHelper getScreenWidth] - 40, 50)];
    [noUsersLabel setTextColor:[UIColor blackColor]];
    [noUsersLabel setFont:[UIFont fontWithName:@"HelveticaNeue-ThinItalic" size:17.0f]];
    [noUsersLabel setText:NSLocalizedString(@"subscribers_none_txt", nil)];
    [self.view addSubview:noUsersLabel];
    
    if (self.searchMode) {
        [noUsersLabel setText:NSLocalizedString(@"search_info_txt", nil)];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        float center = ([UIHelper getScreenHeight] - 64)/2;
        spinner.center = CGPointMake([UIHelper getScreenWidth]/2-10, 64);
        spinner.hidesWhenStopped = YES;
        spinner.hidden = YES;
        [self.view addSubview:spinner];
        if (self.tagMode) {
            self.tableView.hidden = NO;
        }
        else{
            self.tableView.hidden = YES;
        }
        if (self.tagMode) {
            [self startRefreshing];
        }
    }
    else{
        [self startRefreshing];
    }
    
    //[self hideShowSearch:0];
    
   // [self addLeftButton];
    //self.tableView.contentInset = UIEdgeInsetsMake(160, 0, 0, 0);
    if (self.searchMode && !self.tagMode) {
        self.discover = [self.storyboard instantiateViewControllerWithIdentifier:@"activity"];
        [self.discover setViewMode:2];
        [self discovercallbacks];
        [self.view addSubview:self.discover.view];
        [noUsersLabel setHidden:YES];
        [self.searchController.searchBar setPlaceholder:NSLocalizedString(@"search_placeholder_txt", nil)];
    }
    if (!self.tagMode && self.searchMode) {
        [self addBlur];
        blurEffectView.hidden = YES;
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
  
}


-(void)changeToBucket:(BucketModel *) bucket{
    //[self addBucketAsRoot:@"bucketController2" withBucket:bucket];
    /*
     root = (NavigationControlViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"bucketController2"];
     [root setBucket:bucket];
     [self.view addSubview:root.view];
     */
    root = [[BucketController alloc] init];
    [root setBucket:bucket];
    //[((BucketController *)root) setSuperCarousel:self];
    __weak typeof(self) weakSelf = self;
    root.onDespand = ^{
        [weakSelf removeBucketAsRoot];
    };
    //[root addViewController:self];
    
    //[self.navigationController setViewControllers:@[root] animated:NO];
    //[self.navigationController.view layoutIfNeeded];
    [self.navigationController pushViewController:root animated:NO];
}

-(void)removeBucketAsRoot{
   // [self.navigationController setViewControllers:@[self] animated:NO];
    //[self.navigationController.view layoutIfNeeded];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.discover onFocusGained];
}


-(void)discovercallbacks{
    __weak typeof(self) weakSelf = self;
    self.discover.onExpand=^(BucketModel*(bucket)){
        [weakSelf changeToBucket:bucket];
    };
    /*
    self.discover.onLockScreenToggle = ^{
        if(scrollView.scrollEnabled){
            scrollView.scrollEnabled = NO;
        }else{
            scrollView.scrollEnabled = YES;
        }
    };
    self.discover.onProgression = ^(int(progression)){
        [weakSelf increaseProgress:progression];
    };
    self.discover.onNetworkError = ^(UIView *(view)){
        [weakSelf addErrorMessage:view];
    };
    
    self.discover.onNetworkErrorHide=^{
        [weakSelf hideError];
    };
     */
}

-(void)showSearch{
    if (self.searhIsShowing) {
        [self.searchController setActive:NO];
        self.searhIsShowing = NO;
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView.hidden = YES;
        blurEffectView.hidden = YES;
        self.tableView.hidden = YES;
        NSLog(@"hidign searchbar");
            [(CarouselController *)[self carouselParent] setScrollEnabled:YES forPageViewController:[(CarouselController *)[self carouselParent] pageViewController]];
    }else{
        self.searhIsShowing = YES;
        self.tableView.hidden = NO;
        [self addBlur];
        blurEffectView.hidden = NO;
        self.tableView.tableHeaderView = self.searchController.searchBar;
        // [self.searchController.searchBar becomeFirstResponder];
        [self.searchController.searchBar sizeToFit];
        self.tableView.tableHeaderView.backgroundColor = [UIColor blueColor];
        [self.searchController.searchBar setBarTintColor:[UIColor whiteColor]];
        [self.searchController.searchBar setBackgroundColor:[UIColor whiteColor]];
        self.searchController.searchBar.barTintColor = [UIColor whiteColor];
        self.tableView.tableHeaderView.tintColor = [ColorHelper purpleColor];
        [self.searchController.searchBar becomeFirstResponder];
        self.searchController.searchBar.backgroundImage = [[UIImage alloc] init];
        self.searchController.searchBar.backgroundColor = [UIColor clearColor];
        [self addBlurToSearch:self.searchController.searchBar];
        
        [self.searchController.searchBar insertSubview:blurEffectViewSearch atIndex:0];
        [self.tableView layoutIfNeeded];
        [self.tableView.tableHeaderView layoutIfNeeded];
        [self.tableView setNeedsDisplay];
        
       // [self.searchController.searchBar setSearchFieldBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal];
       
        for (UIView *subView in self.searchController.searchBar.subviews) {
            for(id field in subView.subviews){
                if ([field isKindOfClass:[UITextField class]]) {
                    UITextField *textField = (UITextField *)field;
                    [textField setTextColor:[UIColor whiteColor]];
                    [textField setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
  
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"didAPPEAR");
    if (!self.tagMode) {
        //[self addLeftButton];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
   // [self.searchController setActive:NO];
    /*
    [self.navigationItem setHidesBackButton:YES animated:YES];
    //UIImage* image = [UIHelper iconImage:[UIImage imageNamed:@"wave-logo.png"]];
    UIImage* image = [UIHelper iconImage:[UIImage imageNamed:@"wave-logos.png"] withSize:52];
    CGRect frame = CGRectMake(0, 0, 26, 26);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
   // [someButton addTarget:self action:@selector(nil) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    self.menuItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [[[ApplicationHelper getMainNavigationController] navigationItem] setLeftBarButtonItem:self.menuItem];
    [self.carouselParent.navigationItem setLeftBarButtonItem:self.menuItem];
     */
}

-(void)addLeftButton{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    //UIImage* image = [UIHelper iconImage:[UIImage imageNamed:@"wave-logo.png"]];
    UIImage* image = [UIHelper iconImage:[UIImage imageNamed:@"search-icon-white.png"] withSize:40];
    CGRect frame = CGRectMake(0, 0, 20, 20);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showSearch) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    self.menuItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [[[ApplicationHelper getMainNavigationController] navigationItem] setLeftBarButtonItem:self.menuItem];
    [self.carouselParent.navigationItem setLeftBarButtonItem:self.menuItem];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.isSearching = YES;
    [self.view bringSubviewToFront:self.tableView];
    NSString *searchString = searchController.searchBar.text;
    if (searchString.length > 0) {
        //[spinner setHidden:NO];
        //[spinner startAnimating];
         //self.tableView.hidden = YES;
        currentScopeIndex = searchController.searchBar.selectedScopeButtonIndex;
        currentSearchString = searchString;
        if (searchTimer != nil && [searchTimer isValid]) {
            [searchTimer invalidate];
        }
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                       target:self
                                                     selector:@selector(searchDelayed)
                                                     userInfo:nil
                                                      repeats:NO];
    }
}

-(void)searchDelayed{
    [self searchForText:currentSearchString
                  scope:currentScopeIndex];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.tagMode) {
        self.isSearching = NO;
    }
    if (self.searchMode && !self.tagMode) {
        //[self.view addSubview:self.discover.view];
    }
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     [(CarouselController *)[self carouselParent] setScrollEnabled:YES forPageViewController:[(CarouselController *)[self carouselParent] pageViewController]];
    if (!self.tagMode) {
        self.searhIsShowing = NO;
        self.tableView.tableHeaderView = nil;
    }
    else{
        self.isSearching = NO;
    }
    
    if (self.searchMode && !self.tagMode) {
        NSLog(@"canceling");
        self.onSearchedCanceled();
        [self.view addSubview:self.discover.view];
        self.tableView.hidden = YES;
    }
}


- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar {
   // self.tableView.contentInset = UIEdgeInsetsMake(164, 0, 0, 0);
    if (self.tagMode) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            CGRect frame = wrapHolder.frame;
            frame.size.height += 44;
            wrapHolder.frame = frame;
        } completion:^(BOOL finished) {
            self.tableView.tableHeaderView = wrapHolder;
            
        }];
    }
  
    [(CarouselController *)[self carouselParent] setScrollEnabled:NO forPageViewController:[(CarouselController *)[self carouselParent] pageViewController]];
    //[self ShowMySearch];
    NSLog(@"should Begin editing");
    
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"did Begin editing");

}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"should end editing");

    if (self.searchController.isActive) {
    }else{
        if (!self.tagMode) {
            if (self.searchMode && !self.tagMode) {
                
            }else{
                self.searhIsShowing = NO;
                self.tableView.tableHeaderView = nil;
            }
            
        }
    }

    return YES;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"did end editing");

    
    if (self.tagMode) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            CGRect frame = wrapHolder.frame;
            frame.size.height -= 44;
            wrapHolder.frame = frame;
        } completion:^(BOOL finished) {
            self.tableView.tableHeaderView = wrapHolder;
            
        }];
    }

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
    if (self.tagMode) {
        [self.tagFeed getTags:^{
            [weakSelf stopRefreshing];
            if(![weakSelf.tagFeed hasSearchResults]){
                if([self.currentBucket.user Id] != [[[[AuthHelper alloc] init] getUserId] intValue]){
                    self.tableView.hidden = YES;
                    [noUsersLabel setText:NSLocalizedString(@"tagged_none_txt", nil)];
                }
            }else{
                
            }
            [self.tableView reloadData];
        } onError:^(NSError *error){
            NSLog(@"%@", [error localizedDescription]);
            
        }];
    }else{
        [self.userFeed getFeed:^{
            NSLog(@"userFEED");
            [weakSelf stopRefreshing];
            if(![weakSelf.userFeed hasUsers]){
                self.tableView.hidden = YES;
            }else{
                
            }
            //[self.tableView reloadData];
        } onError:^(NSError *error){
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
    
}

-(void)searchForText:(NSString *)searchString
               scope:(NSInteger) scopeIndex{
    
    [self.searchFeed stopSearchConnection];
    if (scopeIndex == 0) {
        [self.searchFeed setSearchMode:@"user"];
    }else {
        [self.searchFeed setSearchMode:@"hashtag"];
    }

    [self.searchFeed search:searchString
             withCompletion:^
     {
         if ([self.searchFeed.searchResults count] == 0) {
             if (!self.tagMode) {
                 self.tableView.hidden = YES;
             }
             
             if (currentScopeIndex == 0) {
                 
                 [noUsersLabel setText:[NSString stringWithFormat:@"%@ '%@'",NSLocalizedString(@"search_users_match_txt", nil),searchString]];
             }else{
                 [noUsersLabel setText:[NSString stringWithFormat:@"%@ '%@'",NSLocalizedString(@"search_hashtag_match_txt", nil), searchString]];
             }
             
         }else{
             if (currentScopeIndex == 1) {
                 [noUsersLabel setText:[NSString stringWithFormat:@"No hashtags found matching '%@'", searchString]];
                 self.tableView.hidden = YES;
             }else{
                 [self.tableView reloadData];
                 self.tableView.hidden = NO;
             }
             
         }
     }
                    onError:^(NSError *error)
     {
     }];
}


-(void)addBlur{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.frame;
    // blurEffectView.alpha = 0.9;
    blurEffectView.alpha = 1.0;
    [self.view addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)addBlurToSearch:(UISearchBar *) searchBar{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    blurEffectViewSearch = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectViewSearch.frame = searchBar.frame;
    // blurEffectView.alpha = 0.9;
    blurEffectViewSearch.alpha = 0.00;
    //[searchBar addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectViewSearch setTranslatesAutoresizingMaskIntoConstraints:NO];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserModel *user;
    if (self.searchMode && self.tagMode) {
        TagModel *tag = [[self.tagFeed feed] objectAtIndex:indexPath.row];
        user = [tag taggee];
        NSLog(@"user id %d", tag.user.Id);
    }
   else if (self.searchMode) {
        user = [[self.searchFeed searchResults] objectAtIndex:indexPath.row];
    }else{
       SubscribeModel *subscription = [[self.userFeed feed] objectAtIndex:indexPath.row];
        user = [subscription subscribee];
    }
    
    [self showProfile:user];
}
/*
-(void)showProfile:(UserModel *) user{
    AbstractFeedViewController *profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"activity"];
    [profileController setViewMode:1];
    [profileController setIsDeviceUser:NO];
    [profileController setAnotherUser:user];
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
    
    if (!self.searchMode) {
        [self dismiss];
    }
    if (self.tagMode) {
        [self dismiss];
    }
    
    [[ApplicationHelper getMainNavigationController] pushViewController:profileController animated:YES];
}
*/
-(void)showProfile:(UserModel *) user{
    //[self.parentController stopAllVideo];
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    profileView = [[ProfileViewController alloc] init];
    [profileView setViewMode:1];
    [profileView setIsNotDeviceUser:YES];
    [profileView setIsDeviceUser:NO];
    [profileView setAnotherUser:user];
    [profileView.navigationItem setTitle:user.username];
    
   
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    
    [[ApplicationHelper getMainNavigationController] pushViewController:profileView animated:YES];
}

-(void)viewDidLayoutSubviews{
    self.topConstraint.constant = 0;
    [self.searchController.searchBar sizeToFit];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    if(!cell.isInitialized){
        //UI initialization
            [cell initalizeWithMode:self.searchMode withTagMode:self.tagMode];
    }
    
    if([self.currentBucket.user Id] != [[[[AuthHelper alloc] init] getUserId] intValue]){
        [[cell subscribeButton] setHidden:YES];
    }else{
        [[cell subscribeButton] setHidden:NO];
    }
    
    cell.onTagDeleted = ^(TagModel *tag){
        [[self.tagFeed feed] removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        if ([[self.tagFeed feed] count] == 0) {
            //self.tableView.hidden = YES;
        }
    };
    
    cell.onTagCreated = ^(TagModel *tag){
        [[self.tagFeed feed] addObject:tag];
        self.isSearching = NO;
        [self.tableView reloadData];
        [self.searchController setActive:NO];
        self.isSearching = NO;
      
    };
    if (self.searchMode && self.tagMode) {
        if (!self.isSearching) {
            TagModel *tag = [[self.tagFeed feed] objectAtIndex:indexPath.row];
            [cell updateUI:tag withTagmode:NO withBucketId:self.currentBucket.Id];
            NSLog(@"isnot");
        }else{
            NSLog(@"issearching");
            UserModel *userModel = [[self.searchFeed searchResults] objectAtIndex:indexPath.row];
            [cell setIsTagged:[self.tagFeed isUserTagged:userModel]];
            [cell updateUI:userModel withTagmode:YES withBucketId:self.currentBucket.Id];
        }
    }
    else if (self.searchMode) {
        UserModel *userModel = [[self.searchFeed searchResults] objectAtIndex:indexPath.row];
        [cell updateUI:userModel withTagmode:NO withBucketId:self.currentBucket.Id];
    }else{
        if ([self.userFeed.feed count]> 0) {
            SubscribeModel *subscribeModel = [[self.userFeed feed] objectAtIndex:indexPath.row];
            [cell updateUI:subscribeModel withTagmode:NO withBucketId:self.currentBucket.Id];
        }
       
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    if (self.searchMode) {
        if (self.tagMode) {
            if (self.isSearching) {
                return [[self.searchFeed searchResults] count];
            }else{
                return [[self.tagFeed feed] count];
            }
            
        }
        return [[self.searchFeed searchResults] count];
    }
    return [[self.userFeed feed] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
        return 60;
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
