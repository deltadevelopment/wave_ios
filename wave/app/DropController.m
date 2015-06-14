//
//  PageContentViewController.m
//  wave
//
//  Created by Simen Lie on 30.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DropController.h"
#import "DropView.h"
#import "DataHelper.h"
@interface DropController ()

@end

@implementation DropController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    //self.titleLabel.text = self.titleText;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    DropView *contentView = [[DropView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
}

-(void)bindToModel{
    NSLog(@" ---- About to request media for drop id %d", self.drop.Id);
    //Bind all ui text etc and images
    DropView *dropView = (DropView *)self.view;
    [dropView setDropUI:self.drop];
    if([self.drop media_type] == 1 && self.isPlaceholderView){
        //IS video, should get thumbnail
        [self.drop requestThumbnail:^(NSData *media){
            
         [dropView setMedia:[UIImage imageWithData:media] withIndexId:[self.drop Id]];
        }];
        
    }else{
        if([self.drop media_type] == 1){
            if([self.drop thumbnail_tmp] != nil){
              [dropView setMedia:[UIImage imageWithData:[self.drop thumbnail_tmp]] withIndexId:[self.drop Id]];
            }
          
        }
        [self.drop requestPhoto:^(NSData *media){
            if([self.drop media_type] == 0){
                //IMAGE
                // [dropView setImage:[UIImage imageWithData:media]];
                [dropView setMedia:[UIImage imageWithData:media] withIndexId:[self.drop Id]];
                [[dropView spinner] stopAnimating];
                
                
                
            }else{
                //VIDEO
                
                [dropView setMedia:media withIndexId:[self.drop Id]];
                [[dropView spinner] stopAnimating];
                if([self isStartingView]){
                    [dropView playVideo];
                }else if(self.isDisplaying){
                    [dropView playVideo];
                }
                //[self startStopVideo:nil];
                // playButton.hidden = NO;
                //  [dropView playMediaWithButton:playButton];
            }
            
        }];
    }
    
}
-(void)stopVideo{
    DropView *dropView = (DropView *)self.view;
    if([dropView hasVideo]){
        [dropView stopVideo];
    }
}

-(void)startVideo{
    DropView *dropView = (DropView *)self.view;
    if([dropView hasVideo]){
        [dropView playVideo];
    }
}

-(void)bindTemperatureChanges{
    DropView *dropView = (DropView *)self.view;
    [dropView temperatureAnimation];
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
