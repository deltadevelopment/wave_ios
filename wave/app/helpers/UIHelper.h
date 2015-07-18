//
//  UIHelper.h
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVFoundation.h>
@interface UIHelper : NSObject
+(void)initialize;
+(CGFloat)getScreenWidth;
+(CGFloat)getScreenHeight;
+(void)applyLayoutOnButton:(UIButton *) button;
+(void)applyLayoutOnLabel:(UILabel *) label;
+(void)applyThinLayoutOnLabel:(UILabel *) label;
+(void)applyThinLayoutOnLabelH2:(UILabel *) label;
+(void)applyThinLayoutOnLabelH4:(UILabel *) label;
+(void)applyThinLayoutOnTextField:(UITextField *) label withSize:(float) size;
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage;
+(UIImage *)iconImage:(UIImage *) image;
+(UIImage *)iconImage:(UIImage *) image withSize:(float) size;
+(void)colorIcon:(UIImageView *) imageView withColor:(UIColor *) color;
+(UIImage *)imageNamed:(UIImage *)img withColor:(UIColor *)color;
+(void)roundedCorners:(UIView *) view withRadius:(float)radius;
+(void)applyThinLayoutOnLabel:(UILabel *) label withSize:(float) size;
+(void)applyThinLayoutOnLabel:(UILabel *) label withSize:(float) size withColor:(UIColor *) color;
+(void)addShadowToView:(UIView *) view;
+(void)addShadowToViewTwo:(UIView *) view;
+(UIImage *)iconImage:(UIImage *) image withPoint:(CGPoint) point;
+(void)applyThinLayoutOnButton:(UIButton *) button;
+(void)applyUIOnButton:(UIButton *) button;
+(UIImage *)thumbnailFromVideo:(NSData *) video;
+(CGRect)fullScreenRect;
+(void)applyLayoutOnLabel:(UILabel *) label withSize:(float) size;
+(void)initAndApplyLayoutOnProfilePictureSmall:(UIImageView *) imageview;
+(void)updateNotificationButton:(UINavigationItem *) item withButton:(UIButton *) button;
+(void)applyCaptionLayoutOnTextField:(UITextField *) label withSize:(float) size;
+ (UIImage *)imageWithColor:(UIColor *)color;
+(void)addShadowToViewBottom:(UIView *) view;
@end
