//
//  TemperatureController.m
//  wave
//
//  Created by Simen Lie on 02.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "TemperatureController.h"
#import "TemperatureView.h"
#import "UIHelper.h"
@interface TemperatureController ()

@end

@implementation TemperatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.temperatureLabel.text = @"40°";
    [UIHelper applyThinLayoutOnLabel:self.temperatureLabel withSize:40];

}

-(void)loadView{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    TemperatureView *contentView = [[TemperatureView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor redColor];
    self.view = contentView;
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
    /*
    float middle = ([UIHelper getScreenHeight]/2) - 25;
    if([yPos floatValue] > middle){
        self.view.backgroundColor =[ColorHelper redColor];
    }else{
        self.view.backgroundColor =[ColorHelper greenColor];
    }
    */
    //START = 20 slutt = 532
    float limit =[UIHelper getScreenHeight] - 64 - 40 - 31 - 20;
    float yVal =[yPos floatValue]-20;
    float result = (yVal/limit)*100;
    float roundedResult = roundf(result);
    int resultInt = (int)roundedResult;
    [((TemperatureView *)self.view) setTemperature:[NSString stringWithFormat:@"%d°", resultInt]];
    [((TemperatureView *)self.view) setBackgroundColorWithPercentage:result];
}
-(void)dragX:(NSNumber *) xPos{
    
}
-(void)onDragStarted{
    self.view.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.alpha = 0.9;
                         //[self.view layoutIfNeeded];
                     }
                     completion:nil];
}

-(void)onDragEnded{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.alpha = 1.0;
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.4f
                                               delay:0.4f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.view.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished){
                                              self.view.hidden = YES;
                                          }];
                     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
