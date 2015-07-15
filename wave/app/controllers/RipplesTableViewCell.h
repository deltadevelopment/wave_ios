//
//  RipplesTableViewCell.h
//  wave
//
//  Created by Simen Lie on 16/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RippleModel.h"
@interface RipplesTableViewCell : UITableViewCell<UITextViewDelegate>
@property (strong, nonatomic) UILabel *notificationLabel;
@property (strong, nonatomic) RippleModel *ripple;
@property (nonatomic) bool isInitialized;
@property (nonatomic, copy) void (^onUserTap)(RippleModel*(ripple));
@property (nonatomic, copy) void (^onBucketTap)(RippleModel*(ripple), RipplesTableViewCell*(cell));
@property (nonatomic, copy) void (^onDropTap)(RippleModel*(ripple), RipplesTableViewCell*(cell));
-(void)initalize;
@property (strong, nonatomic)  UILabel *NotificationTimeLabel;
@property (strong, nonatomic)  UIImageView *profilePictureImage;
@property (strong, nonatomic)  UIButton *actionButton;
@property (strong, nonatomic)  UIButton *subscribeButton;
@property (strong, nonatomic)  UIButton *temperatureButton;
@property (strong, nonatomic) UIButton *userButton;
@property (strong, nonatomic)  UIButton *userButtonAction;
@property (strong, nonatomic) UITextView *textView;
- (IBAction)actionButtonAction:(id)sender;
-(void)calculateHeight;
-(void)updateUiWithHeight:(float) height;
-(void)initActionButton:(RippleModel *) ripple withCellHeight:(float) height;
-(CGRect)makeTextClickableAndLayout:(NSString *) username
                     withRestOfText:(NSString *) restofText
                       withRippleId:(int)rippleId
                         withRipple:(RippleModel *) ripple;
@end
