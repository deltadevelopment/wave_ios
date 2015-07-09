//
//  ServerCell.m
//  wave
//
//  Created by Simen Lie on 08.07.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ServerCell.h"
#import "UIHelper.h"
#import "AuthHelper.h"
@implementation ServerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initializeWithMode:(BOOL) mode{
    self.serverNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, [UIHelper getScreenWidth] -40, 40)];
    [UIHelper applyThinLayoutOnLabel:self.serverNameLabel];
    [self.serverNameLabel setTextColor:[UIColor blackColor]];
    [self.serverNameLabel removeFromSuperview];
    [self addSubview:self.serverNameLabel];
    if (mode) {
       self.usernameSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        self.accessoryView = self.usernameSwitch;
        [self.usernameSwitch setOn:NO animated:NO];
        [self.usernameSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [self check];
    }else{  
        self.isInitialized = YES;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   // [self setBackgroundColor:[UIColor redColor]];
    
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:switchControl.on forKey:@"debugModeAutoLogin"];
    if (switchControl.on) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"server_section_auto_login", nil)
                                                       message:NSLocalizedString(@"auto_login_fill_in", nil)
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
        
        [alert show];
        
        //Show box
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSString *username = [[alertView textFieldAtIndex:0] text];
        NSString *password = [[alertView textFieldAtIndex:1] text];
        [[[AuthHelper alloc] init] storeCredentialsDebug:username withPassword:password];
    }
}

-(void)check{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"debugModeAutoLogin"] != nil) {
        bool debugMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"debugModeAutoLogin"];
        if(debugMode){
            [self.usernameSwitch setOn:YES];
        }else{
            [self.usernameSwitch setOn:NO];
        }
    }
}

-(void)update{

}

@end
