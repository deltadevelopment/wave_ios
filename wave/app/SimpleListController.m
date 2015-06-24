//
//  SimpleListController.m
//  wave
//
//  Created by Simen Lie on 24.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SimpleListController.h"
#import "SimpleListCell.h"
#import "UIHelper.h"
@interface SimpleListController ()

@end

@implementation SimpleListController{
    NSString *searchString;
     UIVisualEffectView  *blurEffectView;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.users = [[NSMutableArray alloc] init];
    
    self.userFeed = [[UserFeed alloc] init];
    [self.userFeed getFeed:^{
        self.users = [self.userFeed feed];
        [self refreshResults];
    } onError:^(NSError *error){
    
    }];
    [self.view setBackgroundColor:[UIColor clearColor]];
 self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SimpleListCell class] forCellReuseIdentifier:@"simple"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void)refreshResults{
    [self.tableView reloadData];
}
-(id)initWithSize:(float) yPos{
    self = [super init];
    self.yPos = yPos;
    return self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self supplyTextWithUser:[[self users] objectAtIndex:indexPath.row]];
}

-(void)loadView{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    NSLog(@"ypos %f", self.yPos);
    float yPos2 = self.yPos + 64;
    float height = [UIHelper getScreenHeight] - yPos2 - 10;
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0,[UIHelper getScreenHeight] - 150 - self.yPos,[UIHelper getScreenWidth], 150)
                      style:UITableViewStylePlain];
    //contentView.backgroundColor = [UIColor whiteColor];
    //self.tableView = ta;
}

-(void)searchForUser:(NSString *) username withTextField:(CaptionTextField *) captionTextField{
    self.captionTextField = captionTextField;
    searchString = username;
    NSArray *listItems = [username componentsSeparatedByString:@"@"];
    NSString *userSearch = [listItems objectAtIndex:[listItems count]-1];
    self.users = [self getArrayFromString:userSearch];
    if ([self.users count] == 0) {
        self.tableView.hidden = YES;
        self.onHide();
    }else{
        self.tableView.hidden = NO;
        self.onShow();
    }
    [self.tableView reloadData];
}

-(void)supplyTextWithUser:(SubscribeModel *) subscriber{
    NSArray *listItems = [searchString componentsSeparatedByString:@"@"];
    NSString *userSearch = [listItems objectAtIndex:[listItems count]-1];
    userSearch = [[subscriber subscribee] username];
    NSMutableArray *mutArray = [[NSMutableArray alloc] initWithArray:listItems];
    [mutArray replaceObjectAtIndex:[listItems count]-1 withObject:userSearch];
    NSString * result = [[mutArray valueForKey:@"description"] componentsJoinedByString:@"@"];
    [self.captionTextField setText:result];
    self.tableView.hidden = YES;
    self.onHide();
}

-(NSMutableArray *)getArrayFromString:(NSString *) string{
    NSMutableArray *searchResultsArray =[[NSMutableArray alloc] init];
    for (SubscribeModel *subscriber in [self.userFeed feed]) {
        if ([[[subscriber subscribee] username] containsString:string]) {
            [searchResultsArray addObject:subscriber];
        }
    }
    return  searchResultsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.users count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell");
    SimpleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simple" forIndexPath:indexPath];
    if (!cell.isInitialized) {
        //cell = [[SimpleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"simple"];
        [cell initialize];
    }
    [cell updateUI:[self.users objectAtIndex:indexPath.row]];
    // Configure the cell...
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
