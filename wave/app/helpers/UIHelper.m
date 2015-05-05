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
    //[label setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:20]];
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

+(void)applyThinLayoutOnLabel:(UILabel *) label withSize:(float) size{
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:size]];
    [label setTextColor:[ColorHelper whiteColor]];
    [label setTintColor:[ColorHelper whiteColor]];
}

+(void)applyThinLayoutOnLabel:(UILabel *) label withSize:(float) size withColor:(UIColor *) color{
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:size]];
    [label setTextColor:color];
    [label setTintColor:color];
}

+(void)colorIcon:(UIImageView *) imageView withColor:(UIColor *) color{
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imageView setTintColor:color];
}

+(void)roundedCorners:(UIView *) view withRadius:(float)radius{
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
}

+(void)addShadowToView:(UIView *) view{
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.38;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(1.0f, 0.1f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    
    view.layer.mask = gradientLayer;
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

+(UIImage *)imageNamed:(UIImage *)img withColor:(UIColor *)color{
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
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
