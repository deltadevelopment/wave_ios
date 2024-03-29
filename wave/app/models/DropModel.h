//
//  DropModel.h
//  wave
//
//  Created by Simen Lie on 05/05/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "SuperModel.h"
#import "MediaModel.h"
#import "CacheHelper.h"
#import "TemperatureModel.h"
@interface DropModel : SuperModel


@property (nonatomic, strong) CacheHelper *cacheHelper;

//Model properties
@property (nonatomic) int Id;
@property (nonatomic,strong) NSString * media_key;
@property (nonatomic,strong) NSString * media_url;
@property (nonatomic,strong) NSString * caption;
@property (nonatomic) int media_type;
@property (nonatomic) int parent_id;
@property (nonatomic) int bucket_id;
@property (nonatomic) int temperature;
@property (nonatomic) int user_id;
@property (nonatomic) int lft;
@property (nonatomic) int rgt;
@property (nonatomic,strong) NSDate * created_at;
@property (nonatomic,strong) NSDate * updated_at;
@property (nonatomic, strong) NSString *thumbnail_key;
@property (nonatomic, strong) NSString *thumbnail_url;
@property (nonatomic) int most_votes;
@property (nonatomic) int total_votes_count;
@property (nonatomic) int drop_id;



-(void)redrop:(void (^)(ResponseModel *))completionCallback
      onError:(void (^)(NSError *))errorCallback;

//Properties for client
@property (nonatomic,strong) NSData *media_tmp;
@property (nonatomic,strong) NSData *thumbnail_tmp;
@property (nonatomic,strong) UIImage *media_img;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UserModel *user;
@property (nonatomic,strong) UserModel *originator;
@property (nonatomic,strong) MediaModel *mediaModel;

@property (nonatomic,strong) NSString *upload_url;

//Test properties
@property (nonatomic,strong) NSString * media;
@property (nonatomic,strong) NSString * username;
@property (nonatomic) int phone_number;

@property (nonatomic) bool isDownloading;
-(void)cancelDownload;
@property (nonatomic, strong) MediaController *mediaController;


@property (nonatomic, strong) NSMutableArray *funnyVotes;
@property (nonatomic, strong) NSMutableArray *coolVotes;
-(BOOL)hasVotedAlready;
-(void)cacheVote;

//Methods
//-(id)initWithTestData:(NSString *) media withName:(NSString *) username;
-(id)init:(NSMutableDictionary *)dic;
-(void)requestPhoto:(void (^)(NSData*))completionCallback;
-(void)requestMedia:(void (^)(NSData*))completionCallback onProgress:(void (^)(NSNumber*))progression;
-(void)requestThumbnail:(void (^)(NSData*))completionCallback;
-(void)saveChanges:(void (^)(void))completionCallback
        onProgress:(void (^)(NSNumber*))progression
           onError:(void(^)(NSError *))errorCallback;
-(void)saveChangesToDrop:(void (^)(ResponseModel*, DropModel*))completionCallback
              onProgress:(void (^)(NSNumber*))progression
                 onError:(void(^)(NSError *))errorCallback;

-(void)delete:(void (^)(ResponseModel*))completionCallback onError:(void(^)(NSError *))errorCallback;
-(NSDictionary *)asDictionary;

-(void)fetchVotes:(void (^)(void))completionCallback onError:(void(^)(NSError *))errorCallback;

@end
