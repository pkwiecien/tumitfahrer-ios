//
//  AppDelegate.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 2/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RideRequestsViewController.h"
#import "ForgotPasswordViewController.h"
#import "MenuViewController.h"
#import "SlideNavigationController.h"
#import "Constants.h"
#import "HATransitionController.h"
#import "HACollectionViewSmallLayout.h"
#import <UbertestersSDK/Ubertesters.h>

@interface AppDelegate ()

@property (nonatomic) SlideNavigationController *navigationController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // set color of status bar to light
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // register app for receiving push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    // init controllers
    RideRequestsViewController *rideRequestVC = [[RideRequestsViewController alloc] init];
    MenuViewController *leftMenu = [[MenuViewController alloc] init];
    
    // init slide panel
    self.navigationController = [[SlideNavigationController alloc] initWithRootViewController:rideRequestVC];
    self.navigationController.enableSwipeGesture = NO;
    self.navigationController.portraitSlideOffset = cSlideMenuOffset;     // width of visible view controller
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //Ubertersters SDK initialization
    [[Ubertesters shared] initializeWithOptions:UTOptionsManual|UTOptionsShake];
    
    return YES;

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
