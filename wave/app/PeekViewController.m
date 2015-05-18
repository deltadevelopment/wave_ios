//
//  PeekViewController.m
//  wave
//
//  Created by Simen Lie on 27.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "PeekViewController.h"
#import "UIHelper.h"
#import "SubscribeController.h"
#import "AuthHelper.h"

@interface PeekViewController ()

@end

@implementation PeekViewController
SubscribeController *subscribeController;
AuthHelper *authHelper;
- (void)viewDidLoad {
    [super viewDidLoad];
    subscribeController = [[SubscribeController alloc] init];
    authHelper = [[AuthHelper alloc] init];
    // Do any additional setup after loading the view.
    self.location.text = @"Kristiansand";
   // self.displayName.text = @"Anna Holm";
    self.profilePicture.layer.cornerRadius = 50;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    self.availability.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor redColor];
    self.availability.clipsToBounds = YES;
    self.availability.hidden = YES;
    self.subscribeButton.alpha = 0.0;
    [UIHelper applyThinLayoutOnLabel:self.displayName withSize:24.0];
    [UIHelper applyThinLayoutOnLabel:self.location withSize:17.0];
    
    [[self.subscribeButton layer] setBorderWidth:1.0f];
    [[self.subscribeButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.subscribeButton.layer.cornerRadius = 10;
    self.subscribeButton.clipsToBounds = YES;
    [self.subscribeButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
 
   //[self.subscribeButton setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
 
       [self.subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
    //40 150
    /*
    self.subscribeButton.imageView.frame = CGRectMake(0, 0, 40, 40);
   
       [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
    [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 110)];
   [self.subscribeButton setTitleEdgeInsets:UIEdgeInsetsMake(-50, -100, -80, -110)];
    [self.subscribeButton sizeToFit];
   // self.subscribeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.subscribeButton.imageView.frame.size.width, 0, self.subscribeButton.imageView.frame.size.width);
    //self.subscribeButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.subscribeButton.titleLabel.frame.size.width, 0, -self.subscribeButton.titleLabel.frame.size.width);
    */
}

-(void)subscribeAction{
    NSLog(@"subscriving");
    
    [subscribeController subscribeToUser:[[authHelper getUserId] intValue]
                        withSubscribeeId:[[self user] Id]
                            onCompletion:^(ResponseModel *response){
                                //CHANGE BUTTON HERE
                                
                            }
                                 onError:^(NSError *error){
                                     
                                 }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updatePeekView:(UserModel *) user{
    self.user = user;
    self.location.text = [NSString stringWithFormat:@"%d", [user subscribers_count]];
    self.displayName.text = [user display_name] != nil ? [user display_name] : [user username];
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
