//
//  UIHelper.h
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIHelper : NSObject
+(void)initialize;
+(CGFloat)getScreenWidth;
+(CGFloat)getScreenHeight;
+(void)applyLayoutOnButton:(UIButton *) button;
@end