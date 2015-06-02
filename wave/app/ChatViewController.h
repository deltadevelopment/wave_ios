//
//  ChatViewController.h
//  wave
//
//  Created by Simen Lie on 29.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UIPageViewControllerDelegate>{
CGSize keyboardSize;
}
@property (nonatomic, copy) void (^onChatHidden)(void);
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextView *replyTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyFieldConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyTextHeight;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *replyTextFieldSimple;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyFieldConstraintSimple;
-(void)showChat;
-(void)hideChat;
-(BOOL)isChatVisible;

@end
