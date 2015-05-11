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

@end
