//
//  SearchModel.h
//  wave
//
//  Created by Simen Lie on 23.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"
#import "UserModel.h"
#import "MediaController.h"
@interface SearchModel : SuperModel
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic) bool hasSearchResults;
@property (nonatomic, strong) NSString *searchMode;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) MediaController *mediaController;

-(void)search:(NSString *)searchString withCompletion:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback;
-(void)stopSearchConnection;
@end
