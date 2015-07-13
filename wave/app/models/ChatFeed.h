//
//  ChatFeed.h
//  wave
//
//  Created by Simen Lie on 26.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"

@interface ChatFeed : SuperModel<NSStreamDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@property (nonatomic, copy) void (^onMessageRecieved)(void);
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic) int bucketId;
-(void)auth;

-(void)join:(int) bucketId;
-(void)send:(NSString *) message withDropId:(int) dropId;
-(void)part;
@end
