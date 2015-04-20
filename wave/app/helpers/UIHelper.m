//
//  UIHelper.m
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "UIHelper.h"
#import "ColorHelper.h"
static CGRect screenBound;
static CGSize screenSize;
static CGFloat screenWidth;
static CGFloat screenHeight;
@implementation UIHelper

+(void)initialize{
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
}

+(CGFloat)getScreenWidth
{
    return screenWidth;
}

+(CGFloat)getScreenHeight
{
    return screenHeight;
}

+(void)applyLayoutOnButton:(UIButton *) button{
    [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    [[button titleLabel] setTextColor:[ColorHelper whiteColor]];
    [button setTintColor:[ColorHelper whiteColor]];
}

+(void)applyLayoutOnLabel:(UILabel *) label{
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [label setTextColor:[ColorHelper whiteColor]];
    [label setTintColor:[ColorHelper whiteColor]];
}

+(void)applyThinLayoutOnLabel:(UILabel *) label{
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17]];
    [label setTextColor:[ColorHelper whiteColor]];
    [label setTintColor:[ColorHelper whiteColor]];
}

+(void)applyThinLayoutOnLabelH2:(UILabel *) label{
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20]];
    [label setTextColor:[ColorHelper whiteColor]];
    [label setTintColor:[ColorHelper whiteColor]];
}
+(void)applyThinLayoutOnLabelH4:(UILabel *) label{
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]];
    [label setTextColor:[ColorHelper whiteColor]];
    [label setTintColor:[ColorHelper whiteColor]];
}

+(void)colorIcon:(UIImageView *) imageView withColor:(UIColor *) color{
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imageView setTintColor:color];
}

+(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)iconImage:(UIImage *) image{
    return [self imageWithImage:image scaledToSize:CGSizeMake(60, 60)];
}

+(UIImage *)iconImage:(UIImage *) image withSize:(float) size{
    return [self imageWithImage:image scaledToSize:CGSizeMake(size, size)];
}
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage
{
    NSLog(@"----SCALING IMAGE");
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
