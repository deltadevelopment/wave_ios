//
//  NotificationHelper.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ParserHelper.h"
#import "UIHelper.h"
#import "ColorHelper.h"
@interface NotificationHelper : NSObject
-(id) initNotification;
-(void)addNotificationToView:(UIView *) view;
-(void)setNotificationMessage:(NSString *) text;
@end
