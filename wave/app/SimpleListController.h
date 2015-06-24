//
//  SimpleListController.h
//  wave
//
//  Created by Simen Lie on 24.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserFeed.h"
#import "CaptionTextField.h"
@interface SimpleListController : UITableViewController

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic) float yPos;
-(id)initWithSize:(float) yPos;
-(void)searchForUser:(NSString *) username withTextField:(CaptionTextField *) captionTextField;
@property (strong, nonatomic) UserFeed *userFeed;
@property (strong, nonatomic)  CaptionTextField *captionTextField;

@property (nonatomic, copy) void (^onHide)(void);
@property (nonatomic, copy) void (^onShow)(void);
@end
