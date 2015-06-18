//
//  TestSuperViewController.m
//  wave
//
//  Created by Simen Lie on 14/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "NavigationControlViewController.h"
#import "ColorHelper.h"
#import "UIHelper.h"
#import "ApplicationHelper.h"
#import "SettingsTableViewController.h"
#import "RipplesViewController.h"
#import "DataHelper.h"
@interface NavigationControlViewController ()

@end

@implementation NavigationControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if([ApplicationHelper getMainNavigationController] == nil){
        [ApplicationHelper setMainNavigationController:self.navigationController];
    }
    /*
     UIImage *image = [self resizeImage:[UIHelper iconImage:[UIImage imageNamed:@"menu.png"] withSize:20 ] newSize:CGSizeMake(10,10)];
     self.menuItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(menuItemSelected)];
     [self.navigationItem setLeftBarButtonItem:self.menuItem];
     */
    [self addLeftButton];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
   // [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[ColorHelper purpleColor]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f]
                                                            }];
    /*
     UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showNotifications)];
     [self.navigationItem setRightBarButtonItem:btnShare];
     */
    [self addRightButton];
    //[self.navigationItem setTitle:@"Feed"];
    
    if (self.navigationItem.hidesBackButton || self.navigationItem.rightBarButtonItem == nil) {
        [self.navigationController.navigationBar setNeedsLayout];
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];
}
-(void)showNotifications{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RipplesViewController *ripples =[storyboard instantiateViewControllerWithIdentifier:@"ripplesView"];
    [[ApplicationHelper getMainNavigationController] pushViewController:ripples animated:YES];
}
-(void)addLeftButton{
    //UIImage* image = [UIHelper iconImage:[UIImage imageNamed:@"wave-logo.png"]];
    UIImage* image = [UIHelper iconImage:[UIImage imageNamed:@"wave-logosss.png"]];
    CGRect frame = CGRectMake(0, 0, 26, 26);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(menuItemSelected) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    
    
    self.menuItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    [self.navigationItem setLeftBarButtonItem:self.menuItem];
}

-(void)showSettings:(UITapGestureRecognizer *) sender{
    SettingsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addRightButton{
    UIImage* image = [UIHelper iconImage:[UIImage imageNamed:@"ripples.png"]];
    CGRect frame = CGRectMake(0, 0, 26, 26);
    UIButton* someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showNotifications) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    [DataHelper setNotificationButton:someButton];
    if([DataHelper getRippleCount]> 0){
        if ([DataHelper getNotificationLabel] == nil) {
            UILabel *ripplesCount = [[UILabel alloc] initWithFrame:CGRectMake(16, -5, 20, 20)];
            ripplesCount.text = [NSString stringWithFormat:@"%d", [DataHelper getRippleCount]];
            ripplesCount.textAlignment = NSTextAlignmentCenter;
            [UIHelper applyThinLayoutOnLabel:ripplesCount];
            [ripplesCount setFont:[UIFont fontWithName:ripplesCount.font.fontName size:14.0f]];
            [ripplesCount setBackgroundColor:[ColorHelper redColor]];
            ripplesCount.layer.cornerRadius = 10;
            ripplesCount.clipsToBounds = YES;
            [DataHelper setNotificationLabel:ripplesCount];
            [someButton addSubview:ripplesCount];
        }else{
            [DataHelper getNotificationLabel].hidden = NO;
            [DataHelper getNotificationLabel].text = [NSString stringWithFormat:@"%d", [DataHelper getRippleCount]];
        }
        
    }
  
    [DataHelper setNotificationButton:someButton];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:someButton]];
}

-(void)didGainFocus{
//implemented by subclasses
}



-(void)viewDidAppear:(BOOL)animated{
 
    
}

-(UIButton *)createButton:(NSString *) img x:(int) xPos{
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *buttonImage = [UIImage imageNamed:img];
    buttonImage = [self resizeImage:buttonImage newSize:CGSizeMake(30,30)];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor colorWithRed:0.4 green:0.157 blue:0.396 alpha:1]  forState:UIControlStateNormal];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    // [navButton bringSubviewToFront:navButton.imageView];
    
    [navButton setFrame:CGRectMake(xPos, 0, 30, 30)];
    return navButton;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)menuItemSelected
{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBucket:(BucketModel *)inputBucket{

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
