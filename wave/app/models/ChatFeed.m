//
//  ChatFeed.m
//  wave
//
//  Created by Simen Lie on 26.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ChatFeed.h"
#import "AuthHelper.h"
#import "ParserHelper.h"
#import "ChatModel.h"
@implementation ChatFeed{

}

-(id)init{
    self =[super init];
    self.messages = [[NSMutableArray alloc] init];
    [self initNetworkCommunication];
   // [self testData];
    return self;
}

-(NSDate *)transformDate{
    NSTimeInterval unixTimeStamp = 1436471998032 / 1000.0;
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:unixTimeStamp];
    NSLog(@"the date is %@", messageDate);
    NSAssert(messageDate, @"messageDate should not be nil");
    return messageDate;
}

-(void)targetMethod{
    [self send:@"Hei"];
}


-(void)auth{
    //auth
    NSLog(@"Authorized in chat -----------");
    NSData *data = [[NSData alloc] initWithData:[[self authData] dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

-(void)join:(int) bucketId{
    //Join with auth
     NSLog(@"Joined the in chat -----------");
    self.bucketId = bucketId;
    NSData *data = [[NSData alloc] initWithData:[[self joinData] dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

-(void)send:(NSString *) message{
    NSLog(@"send the in chat -----------");
    //send the messages
    NSData *data = [[NSData alloc] initWithData:[[self sendData:message] dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

-(void)part{
//Disconnect
    NSData *data = [[NSData alloc] initWithData:[[self partData] dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    [outputStream close];
    [inputStream close];
    NSLog(@"parted susces");
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    ConfigHelper *configHelper = [[ConfigHelper alloc] init];
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)[configHelper chatUrl], [configHelper chatPort], &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

-(void)getMessagesFromServer{

}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    NSLog(@"stream event %lu", (unsigned long)streamEvent);
    NSLog([[theStream streamError] localizedDescription]);
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                NSLog(@"herefkoewfkowekf");
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        NSData *oute = [[NSData alloc] initWithBytes:buffer length:len];
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            NSError *error;
                            @try {
                                NSArray *messages = [NSJSONSerialization JSONObjectWithData:oute options:kNilOptions error:&error];
                                for (NSMutableDictionary *dic in messages) {
                                    ChatModel *chatModel = [[ChatModel alloc] init:dic];
                                    if (!chatModel.empty) {
                                        [self.messages insertObject:chatModel atIndex:0];
                                        self.onMessageRecieved();
                                    }
                                }

                            }
                            @catch (NSException *exception) {
                                NSLog(@"got error");
                                NSMutableDictionary *errorDic = [ParserHelper parse:oute];
                                //Create a model for the error here and show an alert if the user has turned on debug mode
                            }
                            @finally {
                                //Nothing
                            }
                           
                            
                            
                            
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
}


#pragma data JSON
-(NSString *)authData{
    
    NSDictionary *body = @{
                           @"command":@"auth",
                           @"params":@{
                                   @"userid" : [NSNumber numberWithInt:[[[[AuthHelper alloc] init] getUserId] intValue]],
                                   @"token" : [[[AuthHelper alloc] init] getAuthToken]
                                   }
                           };
    
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:body];
    return jsonData;
}
-(NSString *)joinData{
    NSDictionary *body = @{
                           @"command":@"join",
                           @"params":@{
                                   @"bucket" : [NSNumber numberWithInt:self.bucketId]
                                   }
                           };
  
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:body];
    return jsonData;
}

-(NSString *)sendData:(NSString *) message{
    NSDictionary *body = @{
                           @"command":@"send",
                           @"params":@{
                                   @"bucket" : [NSNumber numberWithInt:self.bucketId],
                                   @"message" : message
                                   }
                           };
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:body];
    return jsonData;
}

-(NSString *)partData{
    NSDictionary *body = @{
                           @"command":@"part",
                           @"params":@{
                                   @"bucket" : [NSNumber numberWithInt:self.bucketId],
                                   }
                           };
    NSString *jsonData = [ApplicationHelper generateJsonFromDictionary:body];
    NSLog(jsonData);
    return jsonData;
}

-(void)testData{
    for (int i = 0; i<5; i++) {
        ChatModel *chat = [[ChatModel alloc] init];
        chat.message = @"Hei du, hva gjor du ? Hvis du gjor dette er det viktig at all min tekst kommer med";
        [self.messages addObject:chat];
    }
}

@end
