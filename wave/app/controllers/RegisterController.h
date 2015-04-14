//
//  RegisterController.h
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationController.h"
#import "UserModel.h"
#import "ResponseModel.h"
@interface RegisterController : ApplicationController
-(void)registerUser:(NSString *) username
               pass:(NSString *) password
              email:(NSString *) email
       onCompletion:(void (^)(UserModel*,ResponseModel*))callback;
@end
