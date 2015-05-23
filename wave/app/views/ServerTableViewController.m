//
//  ServerTableViewController.m
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ServerTableViewController.h"
#import "AuthHelper.h"
@interface ServerTableViewController ()

@end

@implementation ServerTableViewController{
    NSMutableDictionary *servers;
    NSString *selected;
    AuthHelper *authHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    servers = [[NSMutableDictionary alloc]init];
    authHelper = [[AuthHelper alloc]init];
    [servers setObject:@"http://wzap.herokuapp.com" forKey:@"Heroku"];
    [servers setObject:@"http://wave.apps.ddev.no" forKey:@"Smith"];
   
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.picker.delegate = self;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    selected =[[servers allKeys] objectAtIndex:row];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows =  [[servers allKeys] count];
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    
    title = [[servers allKeys] objectAtIndex:row];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
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

- (IBAction)doneAction:(id)sender {
    if(selected != nil){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"currentServer"] != nil) {
            NSString *storedBaseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentServer"];
            if(![storedBaseUrl isEqualToString:[servers objectForKey:selected]]){
                [defaults setObject:[servers objectForKey:selected] forKey:@"currentServer"];
                [authHelper resetCredentials];
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                UINavigationController *navigation =[mainStoryboard instantiateViewControllerWithIdentifier:@"startNav"];
                [self presentViewController:navigation animated:NO completion:nil];
            }
        }else{
            [defaults setObject:[servers objectForKey:selected] forKey:@"currentServer"];
            [authHelper resetCredentials];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UINavigationController *navigation =[mainStoryboard instantiateViewControllerWithIdentifier:@"startNav"];
            [self presentViewController:navigation animated:NO completion:nil];
        }
    }else{
    [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
