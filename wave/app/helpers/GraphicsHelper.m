//
//  GraphicsHelper.m
//  wave
//
//  Created by Simen Lie on 08/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "GraphicsHelper.h"
#import "UIHelper.h"
@implementation GraphicsHelper

+(UIImage *)mirrorImageWithImage:(UIImage *) image{
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIImage *temp = [self mirrorImage:image WithRect:rect];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:temp.CGImage
                                                scale:temp.scale
                                          orientation:UIImageOrientationUpMirrored];
    return flippedImage;
}

+(UIImage*) mirrorImage: (UIImage*) img WithRect: (CGRect) rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    // draw image
    [img drawInRect:drawRect];
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}


+(UIView *)getErrorView:(NSString *) errorMessage
         withParent:(NSObject *) parent
        withButtonTitle:(NSString *) title
withButtonPressedSelector:(SEL) buttonSelector
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIHelper getScreenWidth], 50)];
    UILabel *errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [UIHelper getScreenWidth] - 100, 30)];

    
 
    [errorMessageLabel setMinimumScaleFactor:12.0/17.0];
    
    errorMessageLabel.adjustsFontSizeToFitWidth = YES;
    [UIHelper applyThinLayoutOnLabel:errorMessageLabel];
    errorMessageLabel.text = errorMessage;
    
    UIButton *errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [UIHelper applyThinLayoutOnButton:errorButton];
    errorButton.frame = CGRectMake([UIHelper getScreenWidth] - 70, 15, 20, 20);
    //[errorButton setTitle:title forState:UIControlStateNormal];
    [errorButton setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [errorButton addTarget:parent action:buttonSelector forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:errorButton];
    [view addSubview:errorMessageLabel];
    return view;
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage
{
    // NSLog(@"THE size is width: %f height: %f", targetSize.width, targetSize.height);
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        
        //NSLog(@"fit height %f", targetSize.width);
        scaleFactor = widthFactor; // scale to fit height
        
        
        
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = 0;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = 0;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
