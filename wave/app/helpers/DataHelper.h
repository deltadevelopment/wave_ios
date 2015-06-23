//
//  DataHelper.h
//  wave
//
//  Created by Simen Lie on 11/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BucketModel.h"
#import "StartViewController.h"
@interface DataHelper : UIView
@property (nonatomic, strong) NSData *data;

+(void)storeData:(NSData*) recievedData withMediaType:(int) media_ty;

+(NSData *)getData;

+(void)addToDeletionQueue:(BucketModel *) bucket;
+(void)storeBucketId:(int)Id;
+(int)getBucketId;
+(void)setCurrentBucketId:(int)bucketId;
+(int)getCurrentBucketId;
+(int)getMediaType;
+(void)setWindow:(UIWindow *) window;
+(UIWindow *)getCurrentWindow;
+(void)storeNotifications:(NSDictionary *)dictionary;
+(void)setStart:(StartViewController *) startViewController;
+(StartViewController *) getStartViewController;
+(void)storeRippleCount:(int) counter;
+(int)getRippleCount;
+(void)setNotificationButton:(UIButton *) button;
+(UIButton *)getNotificationButton;
+(NSMutableArray *)getNotifications;
+(void)setNotificationLabel:(UILabel *) label;
+(UILabel *)getNotificationLabel;
+(NSMutableArray *)getDeletionQueue;

+(void)resetDeletionQueue;
@end
