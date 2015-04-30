//
//  ChatViewController.m
//  wave
//
//  Created by Simen Lie on 29.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"

@interface ChatViewController ()

@end

@implementation ChatViewController{
    NSMutableArray *messages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    messages = [[NSMutableArray alloc]init];
    [messages addObject:@"Take me to heaven"];
    [messages addObject:@"Ikke mye, skal noen ut idag?"];
    [messages addObject:@"hei. hvis dere skal gjøre dette er det viktig at all min tekst kommer med? dere skjønner det"];
    [messages addObject:@"Hva skjer da?"];
    self.replyTextField.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.replyTextField.text = @"Say something...";
    self.replyTextField.delegate = self;
    self.replyTextField.layer.cornerRadius = 2;
    self.replyTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    self.replyTextField.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"169.jpg"]];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
  
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}




-(void)keyboardWillHide {
       self.replyFieldConstraint.constant -= keyboardSize.height;
}


-(void)keyboardWillShow:(NSNotification *)note {
    NSLog(@"hit");
    NSDictionary* info = [note userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    self.replyFieldConstraint.constant += keyboardSize.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
        NSString *text = [messages objectAtIndex:indexPath.row];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        CGRect rect = [text boundingRectWithSize:CGSizeMake(170, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
    NSLog(@"%f", rect.size.height);
    if(rect.size.height <45){
        return 65;
    }
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
    cell.message.text = [messages objectAtIndex:indexPath.row];
   cell.transform = CGAffineTransformMakeRotation(M_PI);
    cell.messageImage.layer.cornerRadius = 20;
    cell.message.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    cell.messageImage.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.message.layer.cornerRadius = 2;
    cell.message.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    cell.message.clipsToBounds = YES;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}

- (IBAction)sendAction:(id)sender {
    [messages insertObject:self.replyTextField.text atIndex:0];
    [self.replyTextField resignFirstResponder];
   
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
     self.replyTextField.text = @"Say something...";
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
@end
