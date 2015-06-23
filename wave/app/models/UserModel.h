//
//  UserModel.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperModel.h"
#import "MediaModel.h"
#import "CacheHelper.h"
@interface UserModel : SuperModel
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * usernameFormatted;
@property (nonatomic,strong) NSString * email;
@property (nonatomic) int phone_number;
@property (nonatomic,strong) NSString * display_name;
@property (nonatomic) int availability;
@property (nonatomic,strong) NSDate * created_at;
@property (nonatomic,strong) NSDate * updated_at;
@property (nonatomic,strong) NSString * password_hash;
@property (nonatomic,strong) NSString * profile_picture_key;
@property (nonatomic,strong) NSString * password;
@property (nonatomic,strong) NSString * password_salt;
@property (nonatomic) BOOL private_profile;
@property (nonatomic) bool is_followee;
@property (nonatomic) int Id;
@property (nonatomic) int subscribers_count;
@property (nonatomic, strong) NSString *profile_picture_url;
@property (nonatomic,strong) NSData *media_tmp;
@property (nonatomic,strong) MediaModel *mediaModel;
@property (nonatomic) bool isDownloading;
@property (nonatomic,strong) MediaController *mediaController;
@property (nonatomic, strong) CacheHelper *cacheHelper;
-(id)init:(NSMutableDictionary *)dic;
-(void)find:(void (^)(UserModel *))completionCallback
    onError:(void(^)(NSError *))errorCallback;
-(id)initWithDeviceUser;
-(id)initWithDeviceUser:(void (^)(UserModel*))completionCallback
                onError:(void(^)(NSError *))errorCallback;
-(void)saveChanges:(void (^)(ResponseModel *,UserModel *))completionCallback
           onError:(void(^)(NSError *))errorCallback;

-(void)upload:(void (^)(void))completionCallback
   onProgress:(void (^)(NSNumber*))progression
      onError:(void(^)(NSError *))errorCallback;

-(void)requestProfilePic:(void (^)(NSData*))completionCallback;
@end
