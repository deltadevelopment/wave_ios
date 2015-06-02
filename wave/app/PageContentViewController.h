//
//  PageContentViewController.h
//  wave
//
//  Created by Simen Lie on 30.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropModel.h"
@interface PageContentViewController : UIViewController
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@property (strong, nonatomic) DropModel *drop;
@property (nonatomic) bool isStartingView;
@property (nonatomic) bool isPlaceholderView;
-(void)bindToModel;
-(void)stopVideo;
-(void)startVideo;
@end
