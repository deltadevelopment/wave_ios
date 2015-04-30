//
//  ChatTableViewCell.h
//  wave
//
//  Created by Simen Lie on 29.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageLabel.h"
#import "UIHelper.h"
@interface ChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UIImageView *messageImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellRightConstraint;
@end
