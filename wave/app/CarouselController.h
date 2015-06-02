//
//  CarouselController.h
//  wave
//
//  Created by Simen Lie on 30.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractFeedViewController.h"
#import "Carousel.h"
#import "SuperViewController.h"
#import "GraphicsHelper.h"
#import "AvailabilityViewController.h"

#import "FilterViewController.h"
@interface CarouselController : SuperViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) AbstractFeedViewController *currentController;
@property (strong, nonatomic) NSMutableArray *carouselObjects;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic)  Carousel *carousel;
-(void)removeBucketAsRoot;
@end
