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
#import "ActivityViewController.h"
#import "ChatViewController.h"
#import "DataHelper.h"
#import "EditImageViewController.h"
#import "TestBoxViewController.h"
#import "BucketController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
AuthHelper *authHelper;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    authHelper = [[AuthHelper alloc] init];
    //[authHelper resetCredentials];
    
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    [self handleNotification:userInfo];
    
    if([authHelper getAuthToken] == nil){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *navigation =[mainStoryboard instantiateViewControllerWithIdentifier:@"startNav"];
        self.window.rootViewController = navigation;
    }else{
        /*
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *navigation =[mainStoryboard instantiateViewControllerWithIdentifier:@"settings"];
        self.window.rootViewController = navigation;
         */
        //[self setView:[[ViewController alloc] init] second:@"mainView"];
        
        // [self setView:[[BucketViewController alloc] init] second:@"bucketView"];
        //[self setView:[[NavigationScrollViewController alloc] init] second:@"navigationScrollNav"];
        // [self setView:[[ActivityViewController alloc]init] second:@"activity"];
        
        //[self setView:[[CarouselViewController alloc] init] second:@"carousel"];
       //[self setView:[[SlideMenuViewController alloc] init] second:@"slideMenuView"];
       
        
        //[self setView:[[EditImageViewController alloc] init] second:@"editView"];
        //[self setView:[[TestBoxViewController alloc] init] second:@"testBox"];
       // [self setView:[[ChatViewController alloc]init] second:@"chatView"];
        
     //   [self setView:[[BucketViewController2 alloc] init] second:@"bucketController2"];
        /*
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *navigation =[mainStoryboard instantiateViewControllerWithIdentifier:@"searchNavigation"];
        [navigation.navigationBar setBarTintColor:[ColorHelper purpleColor]];
        self.window.rootViewController = navigation;
        
*/
        
    }
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    return YES;
}

-(void)handleNotification:(NSDictionary *) userInfo{
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    //[self resetBadgeToZero];
    if(apsInfo) {
        [ApplicationHelper executeBlock];
        //Navigate or take action on the notification
       
        [DataHelper storeRippleCount:[DataHelper getRippleCount] +1];
        
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *str = [[[deviceToken description]
                      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                     stringByReplacingOccurrencesOfString:@" "
                     withString:@""];
    [authHelper storeDeviceId:str];
    
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    if (application.applicationState == UIApplicationStateActive ){
        [ApplicationHelper executeBlock];
        //[self resetBadgeToZero];
        //[DataHelper storeNotifications:userInfo];
        [DataHelper storeRippleCount:[DataHelper getRippleCount] +1];
        //If the application was active we want to force update the ripples count
        if([DataHelper getRippleCount]> 0){
            if ([DataHelper getNotificationLabel] == nil) {
                UILabel *ripplesCount = [[UILabel alloc] initWithFrame:CGRectMake(16, -5, 20, 20)];
                
                ripplesCount.textAlignment = NSTextAlignmentCenter;
                [UIHelper applyThinLayoutOnLabel:ripplesCount];
                [ripplesCount setFont:[UIFont fontWithName:ripplesCount.font.fontName size:14.0f]];
                [ripplesCount setBackgroundColor:[ColorHelper redColor]];
                ripplesCount.layer.cornerRadius = 10;
                ripplesCount.clipsToBounds = YES;
                [DataHelper setNotificationLabel:ripplesCount];
                 [[DataHelper getNotificationButton] addSubview:ripplesCount];
                [DataHelper getNotificationLabel].text = [NSString stringWithFormat:@"%d", [DataHelper getRippleCount]];
            }else {
                NSLog(@"Got notification from active state and unhiding");
                [DataHelper getNotificationLabel].text = [NSString stringWithFormat:@"%d", [DataHelper getRippleCount]];
                [DataHelper getNotificationLabel].hidden = NO;
            }
           
        }
        
        
    }else{
       //If the application was not active, we want to navigate/take action on the ripple
        [self handleNotification:userInfo];
    }
    
    
    
    
}

-(void)resetBadgeToZero{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

-(void) incrementOneBadge{
    NSInteger numberOfBadges = [UIApplication sharedApplication].applicationIconBadgeNumber;
    numberOfBadges +=1;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numberOfBadges];
}

-(void) decrementOneBdge{
    NSInteger numberOfBadges = [UIApplication sharedApplication].applicationIconBadgeNumber;
    numberOfBadges -=1;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numberOfBadges];
}



-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:controller animated:NO completion:NULL];
}

@end
