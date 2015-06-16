//
//  RipplesViewController.h
//  wave
//
//  Created by Simen Lie on 15/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RipplesFeed.h"
@interface RipplesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RipplesFeed *ripplesFeedModel;


@end
