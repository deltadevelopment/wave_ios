//
//  SearchModel.m
//  wave
//
//  Created by Simen Lie on 23.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
{
    AuthHelper *authHelper;
    NSString *url;
    int offset;
    
    
}
-(id)init{
    self =[super init];
    authHelper = [[AuthHelper alloc] init];
    //searchModes = @[@"user",@"hashtag"];
    url = @"search";
    self.searchMode = @"user";
    self.mediaController = [[MediaController alloc] init];
    return self;
}

-(void)search:(NSString *)searchString withCompletion:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback{
    self.searchResults = [[NSMutableArray alloc] init];
    self.searchString = searchString;
    
    [self.mediaController search:[NSString stringWithFormat:@"%@/%@/%@/%d", url, self.searchMode,self.searchString,offset]
                    onCompletion:^(NSData *data){
                        NSLog(@"Got here");
                        NSMutableDictionary *dic = [ParserHelper parse:data];
                        NSLog(@"mys di is %@", dic);
                        NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(strdata);
                        ResponseModel *responseModel = [[ResponseModel alloc] init:dic];
                        [self feedFromResponseModel:responseModel];
                        completionCallback();
                    } onError:errorCallback];
}

-(void)stopSearchConnection{
    [self.mediaController stopConnection];
}

-(void)feedFromResponseModel:(ResponseModel *) response{
    if ([response success]) {
        NSLog(@"users was returned");
        self.hasSearchResults = YES;
        NSMutableArray *rawFeed = [[response data] objectForKey:@"results"];
        for(NSMutableDictionary *rawBucket in rawFeed){
            UserModel *user = [[UserModel alloc] init:rawBucket];
            [self.searchResults addObject:user];
        }
    }else{
        self.hasSearchResults = NO;
    }
    
}

@end
