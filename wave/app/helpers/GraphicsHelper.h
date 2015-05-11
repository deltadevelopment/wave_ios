//
//  GraphicsHelper.h
//  wave
//
//  Created by Simen Lie on 08/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GraphicsHelper : NSObject
+(UIImage *)mirrorImageWithImage:(UIImage *) image;
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage;
+(UIView *)getErrorView:(NSString *) errorMessage
             withParent:(NSObject *) parent
        withButtonTitle:(NSString *) title
withButtonPressedSelector:(SEL) buttonSelector;
@end
