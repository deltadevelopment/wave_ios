//
//  UserModel.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "UserModel.h"
#import "AuthHelper.h"

@implementation UserModel{
    AuthHelper *authHelper;
}
-(id)init:(NSMutableDictionary *)dic{
    [self refresh:dic];
   // NSLog(@"mys di is %@", dic);
    self.mediaController = [[MediaController alloc] init];
    return self;
};

-(id)initWithDeviceUser{
    self = [super init];
    authHelper = [[AuthHelper alloc] init];
    self.mediaController = [[MediaController alloc] init];
    self.Id = [[authHelper getUserId] intValue];
    //[self find:^{} onError:^(NSError *error){}];
    return self;
}



-(id)initWithDeviceUser:(void (^)(UserModel*))completionCallback
                onError:(void(^)(NSError *))errorCallback{
    self.mediaController = [[MediaController alloc] init];
    self = [super init];
    authHelper = [[AuthHelper alloc] init];
    self.Id = [[authHelper getUserId] intValue];
    [self find:completionCallback onError:errorCallback];
    return self;
}

-(void)refresh:(NSMutableDictionary *)dic{
    self.dictionary = dic;
    _username  = [dic objectForKey:@"username"];
    _email  = [dic objectForKey:@"email"];
    if((NSNull*)[dic objectForKey: @"phone_number"] != [NSNull null]){
        _phone_number  = [[dic objectForKey:@"phone_number"] intValue];
    }
    _display_name  = [self getStringValueFromString:@"display_name"];
    _availability  = [[dic objectForKey:@"availability"] intValue];
    _created_at  = [dic objectForKey:@"created_at"];
    _updated_at  = [dic objectForKey:@"updated_at"];
    _password_hash  = [dic objectForKey:@"password_hash"];
    _profile_picture_url  = [self getStringValueFromString:@"profile_picture_url"];
    _profile_picture_key  = [dic objectForKey:@"profile_picture_key"];
    _password_salt  = [dic objectForKey:@"password_salt"];
    _private_profile  = [[dic objectForKey:@"private_profile"] boolValue];
    _Id  = [[dic objectForKey:@"id"] intValue];
    _subscribers_count = [self getIntValueFromString:@"subscribers_count"];
    // NSLog(@"Subscribers count = %d", [[dic objectForKey:@"subscribers_count"] intValue]);
    if((NSNull*)[dic objectForKey:@"is_followee"] != [NSNull null]){
        _is_followee = [[dic objectForKey:@"is_followee"] boolValue];
    }
    _usernameFormatted =[NSString stringWithFormat:@"@%@", _username];
}

-(void)find:(void (^)(UserModel *))completionCallback
    onError:(void(^)(NSError *))errorCallback{
    __weak typeof(self) weakSelf = self;
    [self.applicationController getHttpRequest:[NSString stringWithFormat:@"user/%d", self.Id]
                                  onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                      ResponseModel *responseModel = [self responseModelFromData:data];
                                      [weakSelf refresh:[[responseModel data] objectForKey:@"user"]];
                                      UserModel *returningUser = [[UserModel alloc] init:[[responseModel data] objectForKey:@"user"]];
                                      completionCallback(returningUser);
                                  } onError:errorCallback];
}

-(NSDictionary *)asDictionary{
    NSDictionary *dictionary = nil;
    NSMutableDictionary *updatesDictionary = [[NSMutableDictionary alloc] init];
    dictionary = @{
                   @"email": [self nilChecker:self.email],
                   @"phone_number": [self nilChecker:[NSString stringWithFormat:@"%d", self.phone_number]],
                   @"profile_picture_key":[self nilChecker:self.profile_picture_key],
                   @"password":[self nilChecker:self.password]
                   };
    
    [dictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        // do something with key and obj
        if(![obj isEqualToString:@"-NA-"]){
            [updatesDictionary setObject:obj forKey:key];
        }
    }];
    
    return updatesDictionary;
}
-(NSString *)nilChecker:(NSString *) string{
    if(string == nil || [string isEqualToString:@"" ] || [string isEqualToString:@"0"]){
    return @"-NA-";
    }
    return  string;
}

-(void)upload:(void (^)(void))completionCallback
   onProgress:(void (^)(NSNumber*))progression
      onError:(void(^)(NSError *))errorCallback{
    [self.mediaModel uploadMedia:progression
                    onCompletion:^(MediaModel *mediaModel){
                        self.profile_picture_key = mediaModel.media_key;
                        completionCallback();
                    }
                         onError:errorCallback];
}

-(void)downloadImage:(void (^)(NSData*))completionCallback
{
    //NSLog(@"profile picute url %@", self.profile_picture_url);

    
    if (!self.isDownloading) {
        self.isDownloading = YES;
        [self.mediaController downloadMedia:self.profile_picture_url
                               onCompletion:^(NSData *data){
                                   self.media_tmp = data;
                                   self.isDownloading = NO;
                                   completionCallback(data);
                               }
                                    onError:^(NSError *error){
                                        
                                    }
                                 onProgress:^(NSNumber *progress){
                                     
                                 }];
    }
}

-(void)requestProfilePic:(void (^)(NSData*))completionCallback{
    if (self.profile_picture_url == nil) {
        self.media_tmp = UIImagePNGRepresentation([UIImage imageNamed:@"user-icon-gray.png"]);
        completionCallback(self.media_tmp);
    }else{
        if(self.media_tmp == nil){
            [self downloadImage:completionCallback];
        }else{
            completionCallback(self.media_tmp);
        }
    }
    
}




-(void)saveChanges:(void (^)(ResponseModel *,UserModel *))completionCallback
           onError:(void(^)(NSError *))errorCallback
{
    NSDictionary *body = @{
                           @"user":[self asDictionary]
                           };
        [self.applicationController putHttpRequest:[NSString stringWithFormat:@"user/%d", self.Id]
                                              json:[self asJSON:body]
                                      onCompletion:^(NSURLResponse *response,NSData *data,NSError *error){
                                          ResponseModel *responseModel =[self responseModelFromData:data];
                                          UserModel *user =  [[UserModel alloc] init:[[responseModel data] objectForKey:@"user"]];
                                          completionCallback(responseModel, user);
                                      } onError:errorCallback];
    
    
}

@end
