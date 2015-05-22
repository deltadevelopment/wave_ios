//
//  AppDelegate.m
//  wave
//
//  Created by Simen Lie on 10/04/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthHelper.h"
#import "StartViewController.h"
#import "SlideMenuViewController.h"
#import "CarouselViewController.h"
#import "ActivityViewController.h"
#import "BucketViewController.h"
#import "ChatViewController.h"
#import "EditImageViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
AuthHelper *authHelper;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     authHelper = [[AuthHelper alloc] init];
  [authHelper resetCredentials];
    if([authHelper getAuthToken] == nil){
        [self setView:[[StartViewController alloc] init] second:@"startNav"];
    }else{
        //[self setView:[[ViewController alloc] init] second:@"mainView"];

       // [self setView:[[BucketViewController alloc] init] second:@"bucketView"];
        //[self setView:[[NavigationScrollViewController alloc] init] second:@"navigationScrollNav"];
       // [self setView:[[ActivityViewController alloc]init] second:@"activity"];
        
        //[self setView:[[CarouselViewController alloc] init] second:@"carousel"];
       //[self setView:[[SlideMenuViewController alloc] init] second:@"slideMenuView"];
       
        
        // [self setView:[[EditImageViewController alloc] init] second:@"editView"];
       // [self setView:[[ChatViewController alloc]init] second:@"chatView"];
        
      
        
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:controller animated:NO completion:NULL];
}

@end
