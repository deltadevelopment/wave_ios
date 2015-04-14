//
//  UserModel.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * email;
@property (nonatomic) int phone_number;
@property (nonatomic,strong) NSString * display_name;
@property (nonatomic) int availability;
@property (nonatomic,strong) NSDate * created_at;
@property (nonatomic,strong) NSDate * updated_at;
@property (nonatomic,strong) NSString * password_hash;
@property (nonatomic,strong) NSString * password_salt;
@property (nonatomic) BOOL private_profile;
@property (nonatomic) bool is_followee;
@property (nonatomic) int Id;

-(id)init:(NSMutableDictionary *)dic;
@end