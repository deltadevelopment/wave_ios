//
//  UIHelper.m
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "UIHelper.h"
#import "ColorHelper.h"
#import "GraphicsHelper.h"
#import "DataHelper.h"
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

+(void)applyUIOnButton:(UIButton *) button{
    button.layer.cornerRadius = 25;
    [button setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
}

+(void)applyLayoutOnButton:(UIButton *) button{
    [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    [[button titleLabel] setTextColor:[ColorHelper whiteColor]];
    [button setTintColor:[ColorHelper whiteColor]];
}

+(void)applyThinLayoutOnButton:(UIButton *) button{
    [[button titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17]];
    [[button titleLabel] setTextColor:[ColorHelper whiteColor]];
    [button setTintColor:[ColorHelper whiteColor]];
}

+(void)applyLayoutOnLabel:(UILabel *) label{
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    //[label setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:20]];
    [label setTextColor:[ColorHelper whiteColor]];
    [label setTintColor:[ColorHelper whiteColor]];
}

+(void)applyLayoutOnLabel:(UILabel *) label withSize:(float) size{
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:size]];
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

+(void)applyThinLayoutOnTextField:(UITextField *) label withSize:(float) size{
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:size]];
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
    gradientLayer.shadowPath = [UIBezierPath bezierPathWithRect:gradientLayer.bounds].CGPath;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(1.0f, 0.1f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    
    view.layer.mask = gradientLayer;
}

+(void)addShadowToViewTwo:(UIView *) view{
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    view.alpha = 1.0;
    NSObject * transparent = (NSObject *) [[UIColor colorWithWhite:0 alpha:0] CGColor];
    NSObject * opaque = (NSObject *) [[UIColor colorWithWhite:0 alpha:1] CGColor];
    
    
    

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradientLayer.colors = [NSArray arrayWithObjects: transparent, opaque,
                            opaque, transparent, nil];
    //gradientLayer.startPoint = CGPointMake(1.0f, 0.1f);
   // gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:0.2],
                               [NSNumber numberWithFloat:1.0 - 0.2],
                               [NSNumber numberWithFloat:1], nil];
    
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

+(UIImage *)iconImage:(UIImage *) image withPoint:(CGPoint) point{
    return [self imageWithImage:image scaledToSize:CGSizeMake(point.x, point.y)];
}
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage
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

+(UIImage *)thumbnailFromVideo:(NSData *) video{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"MyFile%@.mov", @"thumb"]];
    [video writeToFile:appFile atomically:YES];
    NSURL *movieUrl = [NSURL fileURLWithPath:appFile];
    AVAsset *asset = [AVAsset assetWithURL:movieUrl];
    
    //  Get thumbnail at the very start of the video
    CMTime thumbnailTime = [asset duration];
    thumbnailTime.value = 0;
    
    //  Get image from the video at the given time
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbnail;
}

+(CGRect)fullScreenRect{
    return CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
}


+(void)initAndApplyLayoutOnProfilePictureSmall:(UIImageView *) imageview{
    imageview =[[UIImageView alloc] initWithFrame:CGRectMake(10, (imageview.frame.size.height /2) -15, 30, 30)];
    imageview.layer.cornerRadius = 15;
    imageview.clipsToBounds = YES;
}


+(void)updateNotificationButton:(UINavigationItem *) item withButton:(UIButton *) button
{
    NSLog(@"Ripple count %d", [DataHelper getRippleCount]);
    if([DataHelper getRippleCount]> 0){
        if ([DataHelper getNotificationLabel] == nil) {
            UILabel *ripplesCount = [[UILabel alloc] initWithFrame:CGRectMake(16, -5, 20, 20)];
            ripplesCount.text = [NSString stringWithFormat:@"%d", [DataHelper getRippleCount]];
            ripplesCount.textAlignment = NSTextAlignmentCenter;
            [UIHelper applyThinLayoutOnLabel:ripplesCount];
            [ripplesCount setFont:[UIFont fontWithName:ripplesCount.font.fontName size:14.0f]];
            [ripplesCount setBackgroundColor:[ColorHelper redColor]];
            ripplesCount.layer.cornerRadius = 10;
            ripplesCount.clipsToBounds = YES;
            [DataHelper setNotificationLabel:ripplesCount];
            [button addSubview:ripplesCount];
        }else{
            [DataHelper getNotificationLabel].hidden = NO;
            [DataHelper getNotificationLabel].text = [NSString stringWithFormat:@"%d", [DataHelper getRippleCount]];
        }
        
    }
    [item setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}


@end
