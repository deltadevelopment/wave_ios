//
//  DataHelper.m
//  wave
//
//  Created by Simen Lie on 11/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DataHelper.h"
static NSData *data;
static int media_type;
static int currentBucketId;
static UIWindow *currentWindow;
static StartViewController *start;
static UIButton *notificationButton;
static UILabel *notificationLabel;
static NSMutableArray *notifications;
@implementation DataHelper

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(void)storeData:(NSData*) recievedData withMediaType:(int) media_ty{
    data = recievedData;
    media_type = media_ty;
}

+(void)setStart:(StartViewController *) startViewController{
    start = startViewController;
}
+(StartViewController *) getStartViewController{
    return start;
}
+(void)setWindow:(UIWindow *) window{
    currentWindow = window;
}
+(UIWindow *)getCurrentWindow{
    return currentWindow;
}

+(NSData *)getData{
    return data;
}

+(int)getMediaType{
    return media_type;
}

+(void)storeBucketId:(int)Id{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setValue:[NSNumber numberWithInt:Id] forKey:@"bucketId"];
 
}

+(void)storeRippleCount:(int) counter{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInt:counter] forKey:@"rippleCounter"];
}

+(int)getRippleCount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:@"rippleCounter"] intValue];
}

+(int)getBucketId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:@"bucketId"] intValue];
}
+(void)setCurrentBucketId:(int)bucketId{
    currentBucketId = bucketId;
}
+(int)getCurrentBucketId{
    return currentBucketId;
}

+(void)setNotificationButton:(UIButton *) button{
    notificationButton = button;
}

+(UIButton *)getNotificationButton{
    return notificationButton;
}

+(void)setNotificationLabel:(UILabel *) label{
    notificationLabel = label;
}

+(UILabel *)getNotificationLabel{
    return notificationLabel;
}


+(void)storeNotifications:(NSDictionary *)dictionary
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray * array = [self getNotifications];
    if(array == nil){
        if(notifications == nil){
            notifications = [[NSMutableArray alloc] init];
        }
    }else{
        notifications =[[NSMutableArray alloc] initWithArray:array];
    }
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh-mm"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    
    [mutDic setObject:resultString forKey:@"date_recieved"];
    
    [notifications addObject:mutDic];
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   // [defaults setValue:notifications forKey:@"notifications"];
    
  
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:notifications];
    [defaults setObject:myEncodedObject forKey:[NSString stringWithFormat:@"notifications"]];
    
}

+(NSArray *)getNotifications{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myDecodedObject = [defaults objectForKey: [NSString stringWithFormat:@"notifications"]];
    
    NSArray *decodedArray = nil;
    @try {
        decodedArray =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", [exception name]);
    }
    @finally {
        NSLog(@"trying");
    }
    
    return decodedArray;
}


@end
