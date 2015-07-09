//
//  EditProfileTableViewController.m
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "EditProfileTableViewController.h"
#import "UserModel.h"
#import "AuthHelper.h"
#import "ApplicationHelper.h"
@interface EditProfileTableViewController ()

@end

@implementation EditProfileTableViewController{
   // SettingsController *settingsController;
    //ProfileController *profileController;
    UserModel *user;
    AuthHelper *authHelper;
    ApplicationHelper *applicationHelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // settingsController = [[SettingsController alloc]init];
    //profileController = [[ProfileController alloc]init];
    applicationHelper = [[ApplicationHelper alloc]init];
    authHelper = [[AuthHelper alloc]init];
    //Requesting user
    user = [[UserModel alloc] initWithDeviceUser:^(UserModel *returningUser){
      [self userWasReturned];
    } onError:^(NSError *error){}];
    
    self.tableView.allowsSelection = NO;
    self.emailTextField.delegate = self;
    self.displayNameTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
    [self.navigationController.navigationBar setTintColor:[ColorHelper purpleColor]];
    [self.navigationController.navigationBar setBackgroundColor:[ColorHelper purpleColor]];
    [self.navigationController.navigationBar setBarTintColor:[ColorHelper purpleColor]];
    [self.emailTextField setPlaceholder:NSLocalizedString(@"email_placeholder", nil)];
    [self.phoneNumberTextField setPlaceholder:NSLocalizedString(@"phonenumber_placeholder", nil)];
    [self.emailLabel setText:NSLocalizedString(@"email_placeholder", nil)];
    [self.phoneNumberLabel setText:NSLocalizedString(@"phonenumber_placeholder", nil)];
    
    [self.navigationItem setTitle:NSLocalizedString(@"settings_edit_profile_txt", nil)];
    
    
}



-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if(textField == self.phoneNumberTextField){
        if ([string isEqualToString:@""]) {
            int length = textField.text.length;
            if([[textField.text substringFromIndex:length - 1] isEqualToString:@" "]){
                textField.text = [textField.text substringToIndex:textField.text.length-1];
            }
        }else{
            self.phoneNumberTextField.text = [self formatNumber:textField.text];
        }
    }
  
    return YES;
}

-(NSString *)formatNumber:(NSString *)text
{
    if(text.length == 3){
        text=[NSString stringWithFormat:@"%@ ", text];
    }
    else  if(text.length == 6){
        text=[NSString stringWithFormat:@"%@ ", text];
    }
  
    return text;
}
-(NSString *)formatPhoneNumber:(NSString *) text
{
  
NSString *finalString = [NSString stringWithFormat:@"%@ %@ %@", [text substringWithRange:NSMakeRange(0, 3)],[text substringWithRange:NSMakeRange(3, 2)],[text substringWithRange:NSMakeRange(5, 3)]];
    
    return  finalString;
}


-(void)userWasReturned{
    NSString *phoneNumber = [user phone_number] == 0 ? @"" : [NSString stringWithFormat:@"%d", [user phone_number]];
    self.emailTextField.text = [user email];
    self.displayNameTextField.text = [user display_name];
    if([phoneNumber length] == 8){
        self.phoneNumberTextField.text = [self formatPhoneNumber:phoneNumber];
    }
}


-(void)userWasNotReturned:(NSError *) error{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *phoneNumber = [self.phoneNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [user setDisplay_name:self.displayNameTextField.text];
    [user setPhone_number:[phoneNumber intValue]];
    [user setEmail:self.emailTextField.text];
    [user saveChanges:^(ResponseModel *response, UserModel *user){
        
        [self userWasSaved:nil];
    } onError:^(NSError *error){
        [self userWasNotSaved:nil];
        
    }];
    

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)userWasSaved:(NSData *) data{
    NSLog(@"user saved");
}

-(void)userWasNotSaved:(NSError *) error{
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = NSLocalizedString(@"settings_edit_profile_txt", nil);
            
    
    
    return sectionName;
}


- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
