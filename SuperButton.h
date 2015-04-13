//
//  SuperButton.h
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ColorHelper.h"
@interface SuperButton : NSObject

@property (nonatomic, copy) void (^onTap)(void);
@property (nonatomic, copy) void (^onDragX)(NSNumber*(xValue));
@property (nonatomic, copy) void (^onDragY)(NSNumber*(yValue));
@property (nonatomic, copy) void (^onDragStartedX)(void);
@property (nonatomic, copy) void (^onDragStartedY)(void);
@property (nonatomic, copy) void (^onDragEndedX)(void);
@property (nonatomic, copy) void (^onDragEndedY)(void);
-(void)enableDragX;
-(void)enableDragY;
- (id)init:(UIViewController *)superViewController;
@end
