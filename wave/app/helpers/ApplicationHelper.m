//
//  ApplicationHelper.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationHelper.h"
#import "BucketModel.h"
#import "DropModel.h"
static NSIndexPath *currrentIndex = 0;
static UINavigationController *mainNavigationController;
static void (^onNotificationRecieved)(void);
static bool observerIsInitalised;
NSArray *availableTexts;
NSArray *unAvailableTexts;
@implementation ApplicationHelper
-(NSString*) generateUrl:(NSString*) relativePath{
    ConfigHelper *configHelper = [[ConfigHelper alloc] init];
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendString:[configHelper baseUrl]];
    [url appendString:@"/"];
    [url appendString:relativePath];
    return url;
    //base + relative;
}
+(NSString*) generateJsonFromDictionary:(NSDictionary *) dictionary{
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:0
                                                     error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    // This will be the json string in the preferred format
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return jsonString;
}
-(void)setIndex:(NSIndexPath *) path{
    currrentIndex = path;
}
-(NSIndexPath*)getIndex{
    return currrentIndex;
}

-(void)addAvailableTexts{
    availableTexts = [[NSArray alloc] initWithObjects:@"IM FREE", @"LONELY BOY", @"HIT ME UP",@"I LOVE FUN", nil];
}
-(void)addUnAvailableTexts{
    unAvailableTexts = [[NSArray alloc] initWithObjects:@"BUSY BEE", @"AINT GOT TIME", @"LONE RANGER",@"IM INTROVERTED", nil];
}

-(NSString*)getAvailableText{
    return availableTexts[rand()%4];
}
-(NSString*)getUnAvailableText{
    return unAvailableTexts[rand()%4];
}


+(NSMutableArray *)bucketTestData{
    NSMutableArray * buckets = [[NSMutableArray alloc] init];
    for(int i = 0; i<6;i++){
        BucketModel *bucket = [[BucketModel alloc] init];
        bucket.drops = [self createDropsWithNumber:10];
        bucket.title = @"My amazing Bucket";
        [buckets addObject:bucket];
    }
   
    return buckets;

}

+(NSMutableArray *)createDropsWithNumber:(int)count{
    NSMutableArray *tempDrops = [[NSMutableArray alloc] init];
    for (int i = 0; i<count; i++) {
        DropModel *drop = [[DropModel alloc] init];
        drop.media = [self getRandomImage];
        
        [tempDrops addObject:drop];
    }
    return tempDrops;
}

+(NSString *)getRandomImage{
    NSArray *images = [NSArray arrayWithObjects: @"169.jpg", @"miranda-kerr.jpg",
                       @"test1.jpg",@"test2.jpg", nil];
    
    return [images objectAtIndex:rand()%4];

}

+(int)userBucketId{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"user-bucket-id"] intValue];
}

+(UINavigationController *)getMainNavigationController{
    return mainNavigationController;
}

+(void)setMainNavigationController:(UINavigationController *) naivgationController{
    mainNavigationController = naivgationController;
}

+(void)setBlock:(void (^)())completionCallback{
    onNotificationRecieved = completionCallback;
    observerIsInitalised = YES;
}
+(void)executeBlock{
    if(observerIsInitalised){
        onNotificationRecieved();
    }
}


/*
-(void)alertUser:(NSString *) text{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"debugMode"] != nil) {
        bool debugMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"debugMode"];
        if(debugMode){
            NSString *errorMessage = [NSHTTPURLResponse localizedStringForStatusCode:[text intValue]];
            NSString *errorMessageWithStatusCode = [NSString stringWithFormat:@"%@ - %@", text, errorMessage];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                           message:errorMessageWithStatusCode
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil,nil];
            [alert show];
        }
    }
}
*/

@end
