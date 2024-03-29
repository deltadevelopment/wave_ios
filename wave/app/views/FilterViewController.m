//
//  FilterViewController.m
//  wave
//
//  Created by Simen Lie on 21/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FilterViewController.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "PartialTransparentView.h"
@interface FilterViewController ()

@end

@implementation FilterViewController{
    NSMutableArray *filterValues;
    NSMutableArray *filterImages;
    NSMutableArray *filterIcons;
    NSMutableArray *filterTexts;
    bool notFirstFilter;
    int currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.alpha = 0.0;
    self.filterImage.alpha = 0.0;
    self.filterTimeLine.layer.cornerRadius = 15;
    self.filterTimeLine.clipsToBounds = YES;
    self.filterTimeLine.backgroundColor = [UIColor clearColor];
    self.view.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.051 green:0.875 blue:0.843 alpha:0.0];
    [UIHelper colorIcon:self.filterImage withColor:[ColorHelper darkBlueColor]];
    filterValues = [[NSMutableArray alloc] init];
    filterImages = [[NSMutableArray alloc] init];
    filterIcons = [[NSMutableArray alloc] init];
     filterTexts = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [self addFilterWithCapacity:340 withNumberOfFilter:4];
    [self addFilterImagesAndTexts];
    currentIndex = -1;
}

-(void)addFilterImagesAndTexts{
    [filterImages addObject:@"bucket.png"];
    [filterImages addObject:@"people-icon.png"];
    [filterImages addObject:@"bucket.png"];
    [filterImages addObject:@"bucket.png"];
    
    [filterIcons addObject:@"bucket-white.png"];
    [filterIcons addObject:@"people-icon-white.png"];
    [filterIcons addObject:@"bucket.png"];
    [filterIcons addObject:@"bucket.png"];
    
    [filterTexts addObject:@"BUCKETS"];
    [filterTexts addObject:@"PEOPLE"];
    [filterTexts addObject:@"EVENTS"];
    [filterTexts addObject:@"BUCKETS4"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //
    // Dispose of any resources that can be recreated.
}

-(void)onDragStarted{
    currentIndex = -1;
    self.view.hidden = NO;
    /*
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.alpha = 1.0;
                         self.filterImage.alpha = 0.5;
                         self.filterTimeLine.alpha = 1.0;
                         self.view.backgroundColor = [UIColor colorWithRed:0.051 green:0.875 blue:0.843 alpha:0.9];
                         //[self.view layoutIfNeeded];
                     }
                     completion:nil];
     */
    self.view.alpha = 1.0;
    self.filterImage.alpha = 0.5;
    self.filterTimeLine.alpha = 1.0;
    self.view.backgroundColor = [UIColor colorWithRed:0.051 green:0.875 blue:0.843 alpha:0.9];
}



-(void)onDragEnded{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.alpha = 1.0;
                         self.filterTimeLine.alpha = 0.0;
                         self.view.layer.backgroundColor = [UIColor colorWithRed:0.051 green:0.875 blue:0.843 alpha:1.0].CGColor;

                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.4f
                                               delay:0.4f
                                             options: UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.view.alpha = 0.0;
                                              
                                              self.view.layer.backgroundColor = [UIColor colorWithRed:0.051 green:0.875 blue:0.843 alpha:0.0].CGColor;
                                              [self.view layoutIfNeeded];
                                              
                                          }
                                          completion:^(BOOL finished){
                                              self.view.hidden = YES;
                                          }];
                     }];
}

-(void)onDragX:(NSNumber *)xPos{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // feed = [feedController getFeed];
        float x = [xPos floatValue];
        int index = 0;
        for(NSNumber *number in filterValues){
            if(index == [filterValues count]-1){
                
                if(x + 46 >[number floatValue]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                               [self changeUIBasedOnFilter:index];
                    });
             
                }
            }else{
                if(x + 46 >[number floatValue] && x + 46 < [[filterValues objectAtIndex:index + 1] floatValue]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        [self changeUIBasedOnFilter:index];
                    });
                }
            }
            index++;
        }
    });
}

-(void)changeUIBasedOnFilter:(int) index{
    //NSLog(@"knapp er over, %d", index);
    self.filterImage.image = [UIImage imageNamed:[filterImages objectAtIndex:index]];
    self.filterBottomText.text = [filterTexts objectAtIndex:index];
    if(currentIndex != index){
        self.changeIcon([UIImage imageNamed:[filterIcons objectAtIndex:index]]);
        currentIndex = index;
    }
}

-(void)addFilterWithCapacity:(float)size withNumberOfFilter:(float)filterNum
{
    
    float res = (filterNum*15) + 15;
    float spacing = (size - res)/(filterNum-2) - ((filterNum-2)*7.5);
    
    for(int i = 0; i<filterNum;i++){
        if(i == 0){
            [self addfilter: 7.5 isLast:false];
        }
        else if(i == filterNum - 1){
            [self addfilter: size - (7.5 + 15) isLast:true];
        }
        else{
            [self addfilter:spacing * (i) isLast:false];
        }
    }
    
    
}

-(void)addfilter:(float) xPos isLast:(bool)last{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 7.5, 15, 15)];
  
  //  NSLog(@"CENTER %f", label.center.x);
    NSNumber *num = [NSNumber numberWithFloat:label.center.x];
    [filterValues addObject:num];  
    if(last){
        UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        imagev.image = [UIHelper iconImage:[UIImage imageNamed:@"slider-cross.png"] withSize:30];
        [label addSubview:imagev];
        label.backgroundColor  =[UIColor clearColor];
    }
    else{
        label.layer.cornerRadius = 7.5;
        label.clipsToBounds = YES;
        label.backgroundColor  =[ColorHelper whiteColor];
    }
    [self.filterTimeLine addSubview:label];
}

-(void)createTimeLine{
    UIView *timeline = [[UIView alloc]init];
    timeline.backgroundColor = [ColorHelper purpleColor];
    [self.view insertSubview:timeline aboveSubview:self.filterImage];
    [self addConstraint:self.view withSubview:timeline];
}

-(void)addConstraint:(UIView *) rootView withSubview:(UIView *)subview
{
subview.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:rootView
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:subview
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:30.0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:rootView
                                                      attribute:NSLayoutAttributeTrailingMargin
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:subview
                                                      attribute:NSLayoutAttributeTrailing
                                                     multiplier:1.0
                                                       constant:30.0]];
    
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:rootView
                                                         attribute:NSLayoutAttributeBottomMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:subview
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:30.0]];
    [subview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview(==50)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(subview)]];
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
