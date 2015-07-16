//
//  RippleModel.m
//  wave
//
//  Created by Simen Lie on 16/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RippleModel.h"

@implementation RippleModel

-(id)init:(NSMutableDictionary *)dic{
    self =[super init];
    self.dictionary = dic;
    
    self.triggee_id =[self getIntValueFromString:@"triggee_id"];
    self.Id =[self getIntValueFromString:@"id"];
    self.trigger_id =[self getIntValueFromString:@"trigger_id"];
    //self.trigger_type =[self getStringValueFromString:@"trigger_type"];
    self.message = [self getStringValueFromString:@"message"];
    self.created_at = [dic objectForKey:@"created_at"];
    //self.user = [[UserModel alloc] init:[self.dictionary objectForKey:@"triggee"]];
    self.interaction_id = [self getIntValueFromString:@"interaction_id"];
    self.interaction = [[InteractionModel alloc] init:[self.dictionary objectForKey:@"interaction"]];

    return self;
};

-(id)initFromPushNotification:(NSMutableDictionary *)dic{
    self =[super init];
    self.dictionary = [dic objectForKey:@"aps"];
    
    self.Id = [self getIntValueFromString:@"id"];
    self.bucket_id = [self getIntValueFromString:@"bucket_id"];
    self.drop_id = [self getIntValueFromString:@"drop_id"];
    self.message = [self getStringValueFromString:@"alert"];
    self.created_at = [dic objectForKey:@"date_recieved"];
    
    return self;
};

-(NSString *)getDate{
    NSString *theString;
    //if the date was later than yesterday
    NSLog(@"the date is %@", self.created_at);
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [f setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [f dateFromString:self.created_at];
    
    NSDate* date2 = [NSDate date];
    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:dateFromString];
    double secondsInAnHour = 3600;
    double minutes = 60;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    NSInteger minutesBetweenDates = distanceBetweenDates / minutes;
    //NSLog(@"%ld", (long)hoursBetweenDates);
   // NSLog(@"%ld", (long)minutesBetweenDates);
    
    NSString *returningDate;
    
    if (distanceBetweenDates > 59) {
        double minutes = 60;
        NSInteger minutesBetweenDates = distanceBetweenDates / minutes;
        if (minutesBetweenDates > 59) {
            double secondsInAnHour = 3600;
             NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
            if (hoursBetweenDates > 24) {
                //is days ago
                NSInteger daysBetweenDays = hoursBetweenDates/24;
                returningDate = [NSString stringWithFormat:@" %ld %@", (long)daysBetweenDays,
                                 daysBetweenDays == 1? NSLocalizedString(@"day_time", nil) :NSLocalizedString(@"days_time", nil)];
                
            }
            else{
            //is hours ago
                returningDate = [NSString stringWithFormat:@" %ld %@", (long)hoursBetweenDates,
                                 hoursBetweenDates == 1? NSLocalizedString(@"hour_time", nil) :NSLocalizedString(@"hours_time", nil)];
            }
        }
        else{
        //is minutes ago
            returningDate = [NSString stringWithFormat:@" %ld %@", (long)minutesBetweenDates,
                             minutesBetweenDates == 1? NSLocalizedString(@"minute_time", nil) :NSLocalizedString(@"minutes_time", nil)];
        }
    }
    else{
    //is seconds ago
        returningDate = [NSString stringWithFormat:@" %ld %@",(long) distanceBetweenDates,
                         distanceBetweenDates == 1? NSLocalizedString(@"second_time", nil) :NSLocalizedString(@"seconds_time", nil)];
    }
    NSLog(@"time %@", returningDate);
    return returningDate;
}

-(NSArray *)getComputedString{
    NSArray *listItems = [self.message componentsSeparatedByString:@" "];
    NSMutableArray *mutable = [[NSMutableArray alloc] initWithArray:listItems];
    [mutable removeObjectAtIndex:0];
    NSString *computedUsername = [listItems objectAtIndex:0];
    NSString *computedMessage = [listItems objectAtIndex:0];

    NSString * result = [[mutable valueForKey:@"description"] componentsJoinedByString:@" "];
    result = [NSString stringWithFormat:@" %@", result];
    NSArray *final = [[NSArray alloc] initWithObjects:computedUsername,result, nil];
    return final;
}

@end
