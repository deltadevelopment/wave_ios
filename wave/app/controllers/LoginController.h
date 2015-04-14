//
//  LoginController.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "UserModel.h"
@interface LoginController : ApplicationController
-(void)login:(NSString *) username
        pass:(NSString *) password
onCompletion:(void (^)(UserModel*,ResponseModel*))callback;
-(void)storeCredentials:(NSMutableDictionary *) dic;
@end
