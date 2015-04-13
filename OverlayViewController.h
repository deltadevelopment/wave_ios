//
//  OverlayViewController.h
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorHelper.h"
@interface OverlayViewController : UIViewController
-(void)onDragStarted;
-(void)onDragEnded;
-(void)onDragX:(NSNumber *) xPos;
-(void)onDragY:(NSNumber *) yPos;
@end
