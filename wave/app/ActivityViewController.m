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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    feed = [[NSMutableArray alloc]init];
    [feed addObject:@"Simen"];
    [feed addObject:@"Christian"];
    //self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
// or it must be some other method
{
    NSLog(@"ff");
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([indexPath isEqual:indexCurrent] && shouldExpand)
    {
        return [UIHelper getScreenHeight] - 64;
    }
    else if([indexPath isEqual:indexCurrent]){
        return 231;
    }
    else {
        return 231;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [feed count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"activityCell";
    ActivityTableViewCell *cell = (ActivityTableViewCell  *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.bucketImage.contentMode = UIViewContentModeCenter;
    cell.bucketImage.clipsToBounds = YES;
    cell.bucketImage.image = [self createImage];
    [cell.bucketImage setUserInteractionEnabled:YES];
    [cell setUserInteractionEnabled:YES];
    if(cell == nil){
        cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(cameraMode && indexPath.row == 0){
     [cell.bucketImage addSubview:cameraView];
    }
    cell.translatesAutoresizingMaskIntoConstraints=NO;
    return cell;

}

-(UIImage*)createImage{
    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    return  [UIHelper imageByScalingAndCroppingForSize:size img:[UIImage imageNamed:@"test2.jpg"]];
}

-(void)prepareCamera:(UIView *)view{
    //[self.tableView addSubview:view];
    cameraView = view;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"dsipla");
    if(cameraMode && indexPath.row == 0){
        CGRect frame = cell.frame;
        frame.size.height = 0;
        cell.frame = frame;
       
    }
  
}

-(void)onCameraOpen{
    
    [feed insertObject:@"Chris" atIndex:0];
    cameraMode = YES;
   [self.tableView reloadData];

    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                         
                     }];
    
    
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
