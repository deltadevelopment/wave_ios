//
//  ChangePasswordTableViewController.m
//  wzup
//
//  Created by Simen Lie on 24/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ChangePasswordTableViewController.h"
#import "UserModel.h"
#import "AuthHelper.h"
#import "ParserHelper.h"
#import "UIHelper.h"
@interface ChangePasswordTableViewController (){
    UIColor *defaultColor;
}

@end

@implementation ChangePasswordTableViewController{
    UserModel *user;
    AuthHelper *authHelper;
    ParserHelper *parsehelper;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    parsehelper = [[ParserHelper alloc]init];
    user = [[UserModel alloc] initWithDeviceUser];
    authHelper = [[AuthHelper alloc]init];
    //Requesting user
    self.tableView.allowsSelection = NO;
    self.passwordTextField.delegate = self;
    self.repeatedPasswordField.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.passwordTextField){
        [self.passwordTextField resignFirstResponder];
        [self.repeatedPasswordField becomeFirstResponder];
        return YES;
    }
    else if(textField == self.repeatedPasswordField){
        [self.repeatedPasswordField resignFirstResponder];
        return NO;
    }
    return YES;
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
    if([self.passwordTextField.text isEqualToString:self.repeatedPasswordField.text]){
    //Bytt passord
        [user setPassword:self.passwordTextField.text];
        [user saveChanges:^(ResponseModel *response,UserModel *user){
            [self passwordWasChanged:nil];
        } onError:^(NSError *error){
            [self passwordWasNotChanged:nil];
        }];
       
    }else{
        [self errorAnimation];
    }
    
}

-(void)passwordWasChanged:(NSData *) data{
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)passwordWasNotChanged:(NSError *) error{
   NSMutableDictionary *errorMessage = [[error userInfo] objectForKey:@"error"];
    NSArray *passwordErrorArray = [errorMessage objectForKey:@"password"];
    NSString *passwordError = [NSString stringWithFormat:@"Password %@",[passwordErrorArray objectAtIndex:0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 300,50)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:17]];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1]];
    [UIHelper initialize];
    
    label.text = passwordError;
    [self.view addSubview:label];
    [self errorAnimation];
}

-(void)errorAnimation{
    defaultColor = self.view.backgroundColor;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.957 green:0.263 blue:0.212 alpha:1]];
    
    //Animate to black color over period of two seconds (changeable)
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [self.view setBackgroundColor:defaultColor];
    
    [UIView commitAnimations];
}



- (IBAction)cancelAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
