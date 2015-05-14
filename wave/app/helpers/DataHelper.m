//
//  DataHelper.m
//  wave
//
//  Created by Simen Lie on 11/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DataHelper.h"
static NSData *data;
@implementation DataHelper

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(void)storeData:(NSData*) recievedData{
    data = recievedData;
}

+(NSData *)getData{
    return data;
}

+(void)storeBucketId:(int)Id{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setValue:[NSNumber numberWithInt:Id] forKey:@"bucketId"];
 
}

+(int)getBucketId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:@"bucketId"] intValue];
}

@end
