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
@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initalizeWithMode:(bool)searchMode{
    self.isInitialized = YES;
    NSLog(@"Is initalised");
    self.searchMode = searchMode;
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Drawings here
    self.profilePictureImage =[[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height /2) -15, 30, 30)];
    self.profilePictureImage.layer.cornerRadius = 15;
    self.profilePictureImage.clipsToBounds = YES;
    [self.profilePictureImage setImage:[UIImage imageNamed:@"miranda-kerr.jpg"]];
    
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, [UIHelper getScreenWidth] -120, self.frame.size.height -20)];
    [self.usernameLabel setText:@"simenlie"];
  //[self.usernameLabel setBackgroundColor:[UIColor redColor]];
    [UIHelper applyThinLayoutOnLabel:self.usernameLabel];
    [self.usernameLabel setTextColor:[UIColor blackColor]];
    
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
    
}

-(void)updateUI:(SuperModel *) superModel{
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
    if (subscription.isSubscriberLocal) {
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
        [self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
        [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
    }else{
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"plus-icon-simple.png"] withSize:40] forState:UIControlStateNormal];
        [self.subscribeButton setBackgroundColor:[ColorHelper whiteColor]];
        [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 12.5, 5, 12.5)];
        [self.subscribeButton setTintColor:[ColorHelper purpleColor]];
    }
}

-(void)subscribeAction{
    if (self.subscription != nil) {
        [self subscribeActionWithSubscription:self.subscription];
    }else{
        SubscribeModel *subscription = [[SubscribeModel alloc] init];
        subscription.subscribee = self.userReturned;
        subscription.subscriber = [[UserModel alloc] initWithDeviceUser];
        [self subscribeActionWithSubscription:subscription];
    }
}

-(void)subscribeActionWithSubscription:(SubscribeModel *) subscription{
    if (subscription.isSubscriberLocal) {
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"plus-icon-simple.png"] withSize:40] forState:UIControlStateNormal];
        [self.subscribeButton setBackgroundColor:[ColorHelper whiteColor]];
        [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 12.5, 5, 12.5)];
        [self.subscribeButton setTintColor:[ColorHelper purpleColor]];
        [subscription delete:^(ResponseModel *response){
            NSLog(@"Deleted");
        } onError:^(NSError *error){}];
    }else{
        [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
        [self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
        [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
        [subscription saveChanges:^(ResponseModel *response){
            
            
        } onError:^(NSError *error)
         {
             
             
         }];
    }
}

@end
