//
//  ChatViewController.m
//  wave
//
//  Created by Simen Lie on 29.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "UIHelper.h"
#import "ChatFeed.h"
#import "ChatModel.h"
@interface ChatViewController ()

@end

@implementation ChatViewController{
   // NSMutableArray *messages;
    bool keyBoardShown;
    float replyPosition;
    ChatFeed *chatFeed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    messages = [[NSMutableArray alloc]init];
    [messages addObject:@"Take me to heaven"];
    [messages addObject:@"Ikke mye, skal noen ut idag?"];
    [messages addObject:@"Hei. hvis dere skal gjøre dette er det viktig at all min tekst kommer med? dere skjønner det"];
    [messages addObject:@"Hva skjer da?"];

  */
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.replyTextFieldSimple setLeftViewMode:UITextFieldViewModeAlways];
    [self.replyTextFieldSimple setLeftView:spacerView];
    self.replyTextFieldSimple.placeholder = @"Say something...";
    self.replyTextFieldSimple.delegate = self;
    self.replyTextFieldSimple.layer.cornerRadius = 2;
    self.replyTextFieldSimple.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    self.replyTextFieldSimple.clipsToBounds = YES;
    
    self.replyTextFieldSimple.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Say something..." attributes:@{                                                                                                                                 NSForegroundColorAttributeName: [[UIColor whiteColor]colorWithAlphaComponent:0.4]                                                              }];
    self.tableView.scrollEnabled = NO;
    self.replyTextField.hidden = YES;
    self.replyTextField.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.replyTextField.text = @"Say something...";
    self.replyTextField.delegate = self;
    self.replyTextField.layer.cornerRadius = 2;
    self.replyTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    self.replyTextField.clipsToBounds = YES;
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"169.jpg"]];
    self.view.backgroundColor = [UIColor clearColor];
     //self.view.backgroundColor = [UIColor redColor]
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    replyPosition = self.replyFieldConstraintSimple.constant;
    
   //UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, [UIHelper getScreenWidth], [UIHelper getScreenHeight]/4)];
   //[UIHelper addShadowToViewTwo:self.tableView];
    //[self.view addSubview:shadowView];
    //[self.view insertSubview:self.tableView belowSubview:shadowView];
    
    //self.tableView.hidden = YES;
    //self.view.hidden = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;  // this prevents the gesture recognizers to 'block' touches
    if (chatFeed == nil) {
         __weak typeof(self) weakSelf = self;
        chatFeed = [[ChatFeed alloc] init];
        chatFeed.onMessageRecieved = ^{
            [weakSelf.tableView reloadData];
        };
        [chatFeed auth];
    }
   
  
}

-(void)joinChat:(int) bucketId{
    if (chatFeed == nil) {
        __weak typeof(self) weakSelf = self;
        chatFeed = [[ChatFeed alloc] init];
        chatFeed.onMessageRecieved = ^{
            [weakSelf.tableView reloadData];
        };
        [chatFeed auth];
    }
    if (!self.hasJoined) {
        [chatFeed join:bucketId];
        self.hasJoined = YES;
    }
    
}

-(void)partChat{
    [chatFeed part];
    NSLog(@"parting chat on close");
}

-(void)hideKeyboard{
    if([self.replyTextFieldSimple isFirstResponder]){
        self.replyTextFieldSimple.text = @"";
     [self.replyTextFieldSimple resignFirstResponder];
    }else{
        if([self isChatVisible]){
            [self hideChat];
        }else{
            [self showChat];
        }
    }
   
}


-(void)showChat{
    self.tableView.hidden = NO;
    self.view.hidden = NO;
}
-(void)hideChat{
    self.onChatHidden();
    self.tableView.hidden = YES;
    self.view.hidden = YES;
}

-(BOOL)isChatVisible{
    //return !self.tableView.hidden;
    return !self.view.hidden;
}



- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.replyTextField.text = @"";
    self.replyTextField.textColor = [UIColor whiteColor];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length == 0){
        textView.text = @"Say something...";
        [textView resignFirstResponder];
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    self.replyTextHeight.constant = newFrame.size.height;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqual:@"\n"]){
        [self.replyTextField resignFirstResponder];
        [self sendAction:nil];
        
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendAction:nil];
    return YES;
}

-(void)keyboardWillHide {
    self.replyFieldConstraint.constant = replyPosition;
    self.replyFieldConstraintSimple.constant = replyPosition;
}

-(void)keyboardWillChange:(NSNotification *)note {
 

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]] ) {
        if(![self isChatVisible]){
            return NO;
        }
        return YES;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.replyTextFieldSimple isFirstResponder] && [touch view] != self.replyTextFieldSimple) {
        [self.replyTextFieldSimple resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)keyboardWillShow:(NSNotification *)note {
 self.tableView.hidden = NO;
    NSDictionary* info = [note userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    self.replyFieldConstraintSimple.constant = replyPosition + keyboardSize.height;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ChatModel *chatModel = [[chatFeed messages] objectAtIndex:indexPath.row];
    NSString *text = chatModel.message;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [text boundingRectWithSize:CGSizeMake(170, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
    if(rect.size.height <45){
        return 50 + 15;
    }
   // return rect.size.height - 6;
     return rect.size.height + 25;
}

-(float)getHeightFromText:(NSString *) text{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect rect = [text boundingRectWithSize:CGSizeMake(170, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    
    return rect.size.height;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell" forIndexPath:indexPath];
    
    if(!cell.isInitialized){
        [cell initalize];
    }
    ChatModel *chatModel = [[chatFeed messages] objectAtIndex:indexPath.row];
    cell.message.text = chatModel.message;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[chatFeed messages] count];
}

- (IBAction)sendAction:(id)sender {
    ChatModel *chatModel = [[ChatModel alloc] init];
    [chatModel setMessage:self.replyTextFieldSimple.text];
   [[chatFeed messages] insertObject:chatModel atIndex:0];
    [chatFeed send:self.replyTextFieldSimple.text];
    //[self.replyTextField resignFirstResponder];
    [self.replyTextFieldSimple resignFirstResponder];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    self.replyTextFieldSimple.text = @"";
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)sendFromSimpleReply{
   
    
}




@end
