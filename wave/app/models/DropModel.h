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
@interface DropModel : SuperModel

//Model properties
@property (nonatomic) int Id;
@property (nonatomic,strong) NSString * media_key;
@property (nonatomic,strong) NSString * media_url;
@property (nonatomic,strong) NSString * caption;
@property (nonatomic) int media_type;
@property (nonatomic) int parent_id;
@property (nonatomic) int bucket_id;
@property (nonatomic) int user_id;
@property (nonatomic) int lft;
@property (nonatomic) int rgt;
@property (nonatomic,strong) NSDate * created_at;
@property (nonatomic,strong) NSDate * updated_at;
@property (nonatomic, strong) NSString *thumbnail_key;

//Properties for client
@property (nonatomic,strong) NSData *media_tmp;
@property (nonatomic,strong) UIImage *media_img;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UserModel *user;

@property (nonatomic,strong) NSString *upload_url;

//Test properties
@property (nonatomic,strong) NSString * media;
@property (nonatomic,strong) NSString * username;
@property (nonatomic) int phone_number;

//Methods
//-(id)initWithTestData:(NSString *) media withName:(NSString *) username;
-(id)init:(NSMutableDictionary *)dic;
-(void)requestPhoto:(void (^)(NSData*))completionCallback;
@end
