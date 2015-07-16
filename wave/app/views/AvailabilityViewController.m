//
//  AvailabilityViewController.m
//  wave
//
//  Created by Simen Lie on 12.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "UIHelper.h"
@interface AvailabilityViewController ()

@end

@implementation AvailabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hidden = YES;
    self.availabilityText.text = @"BUSY BEE";
    self.view.backgroundColor =[ColorHelper magenta];
    self.view.alpha = 1.0;
    [self.view setBackgroundColor:[[ColorHelper magenta] colorWithAlphaComponent:0.5f]];
    self.voteImageView.hidden = YES;
    
    self.labelEmoji = [[UILabel alloc] initWithFrame:CGRectMake(([UIHelper getScreenWidth]/2) -125, (([UIHelper getScreenHeight]/2) -125)-75, 250, 250)];
    [self.labelEmoji setFont:[UIFont fontWithName:@"HelveticaNeue" size:140]];
    [self.labelEmoji setText:@"\xF0\x9F\x98\x82"];
    [self.labelEmoji setTextAlignment:NSTextAlignmentCenter];
    self.labelEmojiTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                         (([UIHelper getScreenHeight]/2) -25) + 50,
                                                                         [UIHelper getScreenWidth]-20,
                                                                         50)];
    [self.labelEmojiTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:44]];
    //[UIHelper applyLayoutOnLabel:self.labelEmojiTextLabel withSize:44];
    [self.labelEmojiTextLabel setTextColor:[UIColor whiteColor]];
    [self.labelEmojiTextLabel setText:@"COOL"];
    [self.labelEmojiTextLabel setTextAlignment:NSTextAlignmentCenter];
   // [self.labelEmojiTextLabel setBackgroundColor:[UIColor redColor]];

    //[self.labelEmoji setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.labelEmoji];
    [self.view addSubview:self.labelEmojiTextLabel];
    
    
    //[UIHelper initialize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onDragX:(NSNumber *)xPos{
    float middle = ([UIHelper getScreenWidth]/2) - 25;
    if([xPos floatValue] > middle){
        self.view.backgroundColor =[ColorHelper redColor];
    }else{
        self.view.backgroundColor =[ColorHelper greenColor];
    }
}

-(void)onDragY:(NSNumber *)yPos{
    float middle = ([UIHelper getScreenHeight]/2) - 25;
    if([yPos floatValue] > middle){
        //self.view.backgroundColor =[ColorHelper redColor];
        self.vote = 0;
      //  [self.voteImageView setImage:[UIImage imageNamed:@"profile-icon.png"]];
        [self.labelEmoji setText:@"\xF0\x9F\x98\x82"];
        [self.labelEmojiTextLabel setText:@"FUNNY!"];
        [self.labelEmojiTextLabel setText:[NSString stringWithFormat:@"%@!", NSLocalizedString(@"vote_funny_cap", nil)]];
    }else{
       // self.view.backgroundColor =[ColorHelper greenColor];
       // [self.voteImageView setImage:[UIImage imageNamed:@"eye.png"]];
        //SET cool here
        [self.labelEmojiTextLabel setText:@"COOL!"];
           [self.labelEmojiTextLabel setText:[NSString stringWithFormat:@"%@!", NSLocalizedString(@"vote_cool_cap", nil)]];
        [self.labelEmoji setText:@"\xF0\x9F\x91\x8D"];
        //[self]
        self.vote = 1;
    }
}
-(void)dragX:(NSNumber *) xPos{

}
-(void)onDragStarted{
    self.view.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.alpha = 1.0;
                         [self.view setBackgroundColor:[[ColorHelper magenta] colorWithAlphaComponent:0.9f]];
                         //[self.view layoutIfNeeded];
                     }
                     completion:nil];
}

-(void)onDragEnded{
    self.onAction([NSNumber numberWithInt:self.vote]);
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.alpha = 1.0;
                         [self.view setBackgroundColor:[[ColorHelper magenta] colorWithAlphaComponent:1.0f]];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.4f
                                               delay:0.4f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.view.alpha = 0.0;
                                              [self.view setBackgroundColor:[[ColorHelper magenta] colorWithAlphaComponent:0.5f]];
                                          }
                                          completion:^(BOOL finished){
                                              self.view.hidden = YES;
                                              self.onAnimationEnded();
                                          }];
                     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
