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


@end
