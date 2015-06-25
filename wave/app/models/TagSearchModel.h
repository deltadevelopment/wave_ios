//
//  TagSearchModel.h
//  wave
//
//  Created by Simen Lie on 25.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperModel.h"
#import "TagModel.h"
@interface TagSearchModel : SuperModel
@property (nonatomic, strong) NSString *searchMode;
@property (nonatomic, strong) MediaController *mediaController;

@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic) bool hasSearchResults;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic) int bucketId;
-(void)getTags:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback;
-(bool)isUserTagged:(UserModel *) user;
@end
