//
//  SuperViewController.m
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SuperViewController.h"
#import "UIHelper.h"
#import "CameraViewController.h"
@interface SuperViewController ()

@end

@implementation SuperViewController{
    OverlayViewController *xView;
    OverlayViewController *yView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSuperButton];
    _camera = [[CameraViewController alloc]init];
   
    __weak typeof(self) weakSelf = self;
    _camera.onCameraReady = ^{
        [weakSelf showCamera];
    };
    _camera.onCameraOpen =^{
        [weakSelf onCameraOpen];
    };
    _camera.onCameraClose=^{
        [weakSelf onCameraClose];
    };
    _camera.onImageTaken =^(UIImage*(image)){
        [weakSelf onImageTaken:image];
    };
  
   
}

-(void)prepareCamera{
    [self.view insertSubview:_camera.view atIndex:0];
}

-(void)onImageTaken:(UIImage *)image{
    CGSize size = CGSizeMake([UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[_camera imageByScalingAndCroppingForSize:size img:image]]];
}

-(void)showCamera{
    NSLog(@"Sow");
}

-(void)onDragX:(NSNumber *) xValue{
    if(xView != nil){
        [xView onDragX:xValue];
    }
    
}
-(void)onDragY:(NSNumber *) yValue{
    if(yView != nil){
        [yView onDragY:yValue];
    }
    
}
-(void)onDragStartedX{
    if(xView != nil){
        [xView onDragStarted];
    }
    
}
-(void)onDragStartedY{
    if(yView != nil){
        [yView onDragStarted];
    }
    
}
-(void)onDragEndedX{
    if(xView != nil){
        [xView onDragEnded];
    }
    
}
-(void)onDragEndedY{
    if(yView != nil){
        [yView onDragEnded];
    }
    
}

-(void)onTap{
    //[self showCamera];
    [_camera onTap];
    
}

-(void)onCameraOpen{
    [_camera prepareCamera];
}

-(void)onCameraClose
{
    
}

-(void)attachSuperButtonToView{
    _superButton = [[SuperButton alloc]init:self.view];
}

-(void)initSuperButton{
    [self attachSuperButtonToView];
    __weak typeof(self) weakSelf = self;
    self.superButton.onDragX =^(NSNumber*(xValue)){
        [weakSelf onDragX:xValue];
    };
    self.superButton.onDragY =^(NSNumber*(yValue)){
        [weakSelf onDragY:yValue];
    };
    self.superButton.onDragStartedX =^{
        [weakSelf onDragStartedX];
    };
    self.superButton.onDragStartedY =^{
        [weakSelf onDragStartedY];
    };
    self.superButton.onDragEndedX =^{
        [weakSelf onDragEndedX];
    };
    self.superButton.onDragEndedY =^{
        [weakSelf onDragEndedY];
    };
    self.superButton.onTap = ^{
        [weakSelf onTap];
    };
}

-(OverlayViewController *)createViewControllerWithStoryboardId:(NSString *) identifier
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    OverlayViewController  *viewController = [sb instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}

-(void)attachViews:(OverlayViewController *) x withY:(OverlayViewController *) y
{
    xView = x;
    yView = y;
    if(xView != nil)
    {
        [_superButton enableDragX];
        [self.view insertSubview:xView.view belowSubview:[self.superButton getButton]];
        [self addConstraints:xView.view];
    }
    if(yView != nil)
    {
        [_superButton enableDragY];
        [self.view insertSubview:yView.view atIndex:0];
        [self addConstraints:yView.view];
    }
     [self prepareCamera];
  
}

-(void)addConstraints:(UIView *) view
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];

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
