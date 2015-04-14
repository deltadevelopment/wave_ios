//
//  MenuTableViewController.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *buttonOne;
@property (nonatomic, copy) void (^onCellSelection)(NSString*(storyboardId));

@end
