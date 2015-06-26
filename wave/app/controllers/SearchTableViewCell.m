//
//  SearchTableViewCell.m
//  wave
//
//  Created by Simen Lie on 19.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "TagModel.h"
@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initalizeWithMode:(bool)searchMode withTagMode:(BOOL) tagMode{
    self.isInitialized = YES;
    self.searchMode = searchMode;
    self.tagModeUI = tagMode;
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Drawings here
    self.profilePictureImage =[[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height /2) -15, 30, 30)];
    self.profilePictureImage.layer.cornerRadius = 15;
    self.profilePictureImage.clipsToBounds = YES;
    [self.profilePictureImage setImage:[UIImage imageNamed:@"user-icon-gray.png"]];
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, [UIHelper getScreenWidth] -120, self.frame.size.height -20)];
    [self.usernameLabel setText:@"simenlie"];
    //[self.usernameLabel setBackgroundColor:[UIColor redColor]];
    [UIHelper applyThinLayoutOnLabel:self.usernameLabel];
    if (searchMode && !tagMode) {
        [self.usernameLabel setTextColor:[UIColor whiteColor]];
    }else{
        [self.usernameLabel setTextColor:[UIColor blackColor]];
    }
    //
    
    self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    self.subscribeButton =[UIButton buttonWithType:UIButtonTypeSystem];
    self.subscribeButton.frame = CGRectMake((self.frame.size.width) -50, (self.frame.size.height /2) -12.5, 40, 25);
    
    [self.subscribeButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [[self.subscribeButton layer] setBorderWidth:1.0f];
    
    [[self.subscribeButton layer] setBorderColor:[ColorHelper purpleColor].CGColor];
    self.subscribeButton.layer.cornerRadius = 2;
    self.subscribeButton.imageView.frame = CGRectMake(0, 0, 40, 40);
    [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
    // [[self.subscribeButton imageView] setTintColor:[ColorHelper purpleColor]];
    
    [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 12.5, 5, 12.5)];
    
    
    [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
    [self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
    [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
    
    
    [self addSubview:self.profilePictureImage];
    [self addSubview:self.usernameLabel];
    [self addSubview:self.actionButton];
    [self addSubview:self.subscribeButton];
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    
}

-(void)updateUI:(SuperModel *) superModel withTagmode:(BOOL) tagmode withBucketId:(int)bucketId{
    self.bucketId = bucketId;
    [self.profilePictureImage setImage:[UIImage imageNamed:@"user-icon-gray.png"]];
    // NSLog(@"the tag mode is %@", tagmode ? @"YES":@"NO");
    self.tagMode = tagmode;
    if ([superModel isKindOfClass:[TagModel class]]) {
        TagModel *tag = (TagModel *)superModel;
        self.tage = tag;
        [self.usernameLabel setText:[[tag taggee] username]];
        [[tag taggee] requestProfilePic:^(NSData *data){
            [self.profilePictureImage setImage:[UIHelper iconImage:[UIImage imageWithData:data] withSize:60.0f]];
        }];
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
        [self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
        [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
    }
    if([superModel isKindOfClass:[SubscribeModel class]])
    {
        // do somthing
        self.subscription = (SubscribeModel *)superModel;
        [self.usernameLabel setText:[[self.subscription subscribee] username]];
        [self updateUIWithSubscription:self.subscription];
    }
    else if ([superModel isKindOfClass:[UserModel class]]){
        self.userReturned = (UserModel *)superModel;
        SubscribeModel *subscription = [[SubscribeModel alloc] init];
        subscription.subscribee = self.userReturned;
        [self.usernameLabel setText:[self.userReturned username]];
        [self updateUIWithSubscription:subscription];
    }
}

-(void)updateUIWithSubscription:(SubscribeModel *) subscription{
    if (self.tagMode) {
        if (self.isTagged) {
            [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
            [self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
            [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
          //  [[self.subscribeButton layer] setBorderColor:[ColorHelper purpleColor].CGColor];
        }else{
            [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"plus-icon-simple.png"]
                                                       withSize:40]
                                  forState:UIControlStateNormal];
            [self.subscribeButton setBackgroundColor:[UIColor clearColor]];
             //[[self.subscribeButton layer] setBorderColor:[ColorHelper whiteColor].CGColor];
            [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 12.5, 5, 12.5)];
            [self.subscribeButton setTintColor:[ColorHelper purpleColor]];
        }
        [[subscription subscribee] requestProfilePic:^(NSData *data){
            [self.profilePictureImage setImage:[UIHelper iconImage:[UIImage imageWithData:data] withSize:60.0f]];
        }];
        //Sjekke om brukeren allerede er tagget i bucketen
    }
    else if (subscription.isSubscriberLocal) {
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
        [self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
        [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
        [[self.subscribeButton layer] setBorderColor:[ColorHelper purpleColor].CGColor];
    }else{
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"plus-icon-simple.png"]
                                                   withSize:40]
                              forState:UIControlStateNormal];
        [self.subscribeButton setBackgroundColor:[UIColor clearColor]];
        [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 12.5, 5, 12.5)];
        if (self.searchMode && !self.tagMode) {
            [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
            [[self.subscribeButton layer] setBorderColor:[ColorHelper whiteColor].CGColor];
        }else {
        [self.subscribeButton setTintColor:[ColorHelper purpleColor]];
            [[self.subscribeButton layer] setBorderColor:[ColorHelper purpleColor].CGColor];
        }
        
    }
    [[subscription subscribee] requestProfilePic:^(NSData *data){
        [self.profilePictureImage setImage:[UIHelper iconImage:[UIImage imageWithData:data] withSize:60.0f]];
    }];
    if ([[subscription subscribee] Id] == [[[[AuthHelper alloc] init] getUserId] intValue]) {
        [self.subscribeButton setHidden:YES];
    }else{
    [self.subscribeButton setHidden:NO];
    }
}

-(void)subscribeAction{
    if (self.tagMode) {
        [self tagAction];
    }
    else if (self.tage != nil) {
        [self untagAction];
    }
    else if (self.subscription != nil) {
        [self subscribeActionWithSubscription:self.subscription];
    }else{
        SubscribeModel *subscription = [[SubscribeModel alloc] init];
        subscription.subscribee = self.userReturned;
        subscription.subscriber = [[UserModel alloc] initWithDeviceUser];
        [self subscribeActionWithSubscription:subscription];
    }
}

-(void)untagAction{
    [self.tage delete:^(ResponseModel *response){
        self.onTagDeleted(self.tage);
    } onError:^(NSError *error){
        
    }];
}

-(void)tagAction{
    TagModel *tagModel = [[TagModel alloc] init];
    [tagModel setBucketId:self.bucketId];
    [tagModel setTaggee:self.userReturned];
    [tagModel setTagString:[self.userReturned usernameFormatted]];
    [tagModel saveChanges:^(ResponseModel *response){
        self.onTagCreated(tagModel);
    } onError:^(NSError *error){
        
    }];
}

-(void)subscribeActionWithSubscription:(SubscribeModel *) subscription{
    if (subscription.isSubscriberLocal) {
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"plus-icon-simple.png"] withSize:40] forState:UIControlStateNormal];
        [self.subscribeButton setBackgroundColor:[UIColor clearColor]];
        [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 12.5, 5, 12.5)];
        if (self.searchMode && !self.tagModeUI) {
            [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
             [[self.subscribeButton layer] setBorderColor:[ColorHelper whiteColor].CGColor];
        }else{
            [self.subscribeButton setTintColor:[ColorHelper purpleColor]];
             [[self.subscribeButton layer] setBorderColor:[ColorHelper purpleColor].CGColor];
        }
        
       
        [subscription delete:^(ResponseModel *response){
        } onError:^(NSError *error){}];
    }else{
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
        [self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
        [[self.subscribeButton layer] setBorderColor:[ColorHelper purpleColor].CGColor];
        [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
        [subscription saveChanges:^(ResponseModel *response){
            
            
        } onError:^(NSError *error)
         {
             
             
         }];
    }
}

@end
