//
//  ApplicationHelper.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationHelper.h"
static NSIndexPath *currrentIndex = 0;
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
-(NSString*) generateJsonFromDictionary:(NSDictionary *) dictionary{
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
