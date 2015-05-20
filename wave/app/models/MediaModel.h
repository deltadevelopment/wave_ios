//
//  MediaModel.h
//  wave
//
//  Created by Simen Lie on 20.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperModel.h"
@interface MediaModel : SuperModel
@property (nonatomic,strong) NSString *upload_url;
@property (nonatomic,strong) NSString *media_key;
@property (nonatomic,strong) NSData *media;
-(id)init:(NSData *) media;
-(void)uploadMedia:(void (^)(NSNumber*))progression
      onCompletion:(void (^)(MediaModel*))completionCallback
           onError:(void(^)(NSError *))errorCallback;
@end
