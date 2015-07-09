//
//  ServerCell.h
//  wave
//
//  Created by Simen Lie on 08.07.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerCell : UITableViewCell
@property (nonatomic) BOOL isInitialized;
@property (nonatomic, strong) UILabel *serverNameLabel;
@property (strong, nonatomic) IBOutlet UISwitch *usernameSwitch;
-(void)initializeWithMode:(BOOL) mode;
-(void)update;
@end
