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
#import "UIHelper.h"
@interface SuperButton : NSObject

@property (nonatomic, copy) void (^onTap)(NSNumber*(mode));
@property (nonatomic, copy) void (^onDragX)(NSNumber*(xValue));
@property (nonatomic, copy) void (^onDragY)(NSNumber*(yValue));
@property (nonatomic, copy) void (^onDragStartedX)(void);
@property (nonatomic, copy) void (^onDragStartedY)(void);
@property (nonatomic, copy) void (^onDragEndedX)(void);
@property (nonatomic, copy) void (^onDragEndedY)(void);
@property (nonatomic, copy) void (^onDragInStartArea)(void);
@property (nonatomic, copy) void (^onDragInStartAreaEnded)(void);
@property (nonatomic, copy) void (^onDragSwitchedFromX)(void);
@property (nonatomic, copy) void (^onDragSwitchedFromY)(void);
@property (nonatomic, copy) void (^onCancelTap)(void);
@property (nonatomic, copy) void (^onLongPressStarted)(void);
@property (nonatomic, copy) void (^onLongPressEnded)(void);
@property (nonatomic) bool lockActions;

-(id)init:(UIView *)view;

-(UIButton *)getButton;

-(void)changeIcon:(UIImage *)img;
-(void)enableDragX;
-(void)enableDragY;

-(void)discard;
-(void)videoRecorded;
-(void)tapCancelButton;

-(void)animateProgress;


@end
