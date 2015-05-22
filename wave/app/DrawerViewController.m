//
//  MenuTableViewController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DrawerViewController.h"
#import "ColorHelper.h"
#import "UIHelper.h"
#import "MenuTableViewCell.h"
@interface DrawerViewController ()

@end

@implementation DrawerViewController{
    NSMutableArray *list;
    NSMutableArray *recentList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    list =[[NSMutableArray alloc]init];
      recentList =[[NSMutableArray alloc]init];
    [list addObject:@"Search"];
    [recentList addObject:@"Whats up today?"];
    CGRect frame = self.topView.frame;
    frame.size.height =150;
    self.topView.frame = frame;
    self.bucketImage.image = [UIImage imageNamed:@"test2.jpg"];
    self.bucketImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bucketImage.clipsToBounds = YES;
    self.profileImage.image = [UIImage imageNamed:@"miranda-kerr.jpg"];
    self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImage.layer.cornerRadius = 30;
    self.profileImage.clipsToBounds = YES;
    self.availabilityLabel.layer.cornerRadius = 5;
    self.availabilityLabel.clipsToBounds = YES;
    self.availabilityLabel.backgroundColor = [ColorHelper greenColor];
    self.availabilityLabel.hidden = YES;
    [UIHelper applyThinLayoutOnLabelH4:self.usernameLabel];
    [UIHelper applyThinLayoutOnLabelH2:self.displayNameLabel];
    self.usernameLabel.text = @"@simenlie";
    self.displayNameLabel.text = @"Simen Lie";
  

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    UITapGestureRecognizer *profileGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToProfileAction)];
    profileGr.numberOfTapsRequired = 1;
    profileGr.cancelsTouchesInView = NO;
    [self.profileView addGestureRecognizer:profileGr];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self addBlur];
}

-(void)goToProfileAction{
    //self.onCellSelection(@"second");
}

-(void)addBlur{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

    UIVisualEffectView  *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], 150);
   // blurEffectView.alpha = 0.9;
    [self.bucketImage addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 1){
        UIView *viewHeader = [UIView.alloc initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], 28)];
        
        UILabel *lblTitle = [UILabel.alloc initWithFrame:CGRectMake(10, 3, [UIHelper getScreenWidth], 21)];
        lblTitle.text = @"RECENT";
        [lblTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        [lblTitle setTextColor:[ColorHelper purpleColor]];
        [lblTitle setTextAlignment:NSTextAlignmentLeft];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [viewHeader addSubview:lblTitle];
        
        return viewHeader;
    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
       // NSString* sectionFooter = [self tableView:tableView titleForFooterInSection:section];
        
        UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight] - 278)];
        UIView *view = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIHelper getScreenHeight] - 328, [UIHelper getScreenWidth], 50)];
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 20,20)];
        
 
        icon.image = [UIHelper iconImage:[UIImage imageNamed:@"settings-icon.png"]];
        [UIHelper colorIcon:icon withColor:[ColorHelper purpleColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(42, 15, [UIHelper getScreenWidth] - 36, 20)];
        
        [UIHelper applyThinLayoutOnLabel:label];
        label.textColor = [ColorHelper purpleColor];
        label.text = @"Settings";
        [view addSubview:label];
        [view addSubview:icon];
        
        
        [wrapperView addSubview:view];
        return wrapperView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 28;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 0;
    }
    return 28;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        //return @"Section 1";
    }
    
    if(section == 1){
        return  @"Recent";
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //second
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            self.onCellSelection(@"carousel");
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            //self.onCellSelection(@"second");
        }
    }
  
   //  self.availabilityLabel.backgroundColor = [ColorHelper greenColor];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    if(indexPath.section == 0){
        cell.title.text = [list objectAtIndex:indexPath.row];
        
        cell.icon.image = [UIHelper iconImage:[UIImage imageNamed:@"search-icon.png"]];
        [UIHelper colorIcon:cell.icon withColor:[ColorHelper purpleColor]];
    }else{
        cell.title.text = [recentList objectAtIndex:indexPath.row];
        cell.labelSpace.constant = -20;
    }
 
    
    [UIHelper applyThinLayoutOnLabel:cell.title];
    [cell.title setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18]];
    cell.title.textColor = [ColorHelper purpleColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        // Return the number of rows in the section.
           return [list count];
    }
    else{
       
        return [recentList count];
    }
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
