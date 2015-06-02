//
//  SettingsTableViewController.m
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UserModel.h"
#import "AuthHelper.h"
#import "StartViewController.h"
#import "DataHelper.h"
#import "AppDelegate.h"
@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController{
    UserModel *user;
    AuthHelper *authHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"debugMode"] != nil) {
        bool debugMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"debugMode"];
        if(debugMode){
            [self.showErrorsSwitch setOn:YES];
        }else{
            [self.showErrorsSwitch setOn:NO];
        }
    }
    else{
        [self.showErrorsSwitch setOn:NO];
    }
    authHelper = [[AuthHelper alloc]init];
    //Requesting user
    
    user =[[UserModel alloc] initWithDeviceUser:^(UserModel *returningUser){
         [self userWasReturned];
    } onError:^(NSError *error){
        
        
    }];
    self.profileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.changePasswordCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.serverCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.logoutCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.profilePictureCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    

}
-(void)userWasReturned{
    NSLog(@"user was returned %@", user.username);
    [self.privateToggleSwitch setOn:[user private_profile] animated:YES];
    self.usernameLabel.text = [user username];
}

-(void)userWasNotReturned:(NSError *) error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(indexPath.row == 2){
            
            [self showLogoutAlert];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
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

- (IBAction)togglePrivateProfile:(id)sender {
    /*
    [settingsController changePrivateProfile:self.privateToggleSwitch.isOn withObject:self withSuccess:@selector(didChangePrivateProfile:) withError:@selector(didNotChangePrivateProfile:)];
    */
}

-(void)didChangePrivateProfile:(NSData *) data{
    NSLog(@"profile private changed");
}

-(void)didNotChangePrivateProfile:(NSError *) error{
    NSLog(@"error");
}



- (IBAction)editProfileAction:(id)sender {
}

- (IBAction)changePasswordAction:(id)sender {
}

- (IBAction)logoutAction:(id)sender {


}

-(void)showLogoutAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Log out"
                                                   message:@"Are you sure you want to log out?"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Ok",nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //ikke logg ut
    }else{
        //Logg ut
        [authHelper resetCredentials];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        StartViewController *navigation =[mainStoryboard instantiateViewControllerWithIdentifier:@"startNav"];      
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        appDelegateTemp.window.rootViewController = navigation;
    
    }
}

- (IBAction)showErrorsToggle:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.showErrorsSwitch.isOn forKey:@"debugMode"];
    
}

- (IBAction)toggleServerAction:(id)sender {

}
@end
