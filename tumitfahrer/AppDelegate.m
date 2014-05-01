//
//  AppDelegate.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 2/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//
#import <RestKit/RestKit.h>
//#import <UbertestersSDK/Ubertesters.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RideRequestsViewController.h"
#import "ForgotPasswordViewController.h"
#import "MenuViewController.h"
#import "SlideNavigationController.h"
#import "HATransitionController.h"
#import "HACollectionViewSmallLayout.h"
#import "Device.h"
#import "BrowseRidesViewController.h"
#import "UserMapping.h"
#import "SessionMapping.h"
#import "RideMapping.h"
#import "DeviceMapping.h"
#import "LocationController.h"
#import "PanoramioUtilities.h"

@interface AppDelegate ()

@property (nonatomic) SlideNavigationController *navigationController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setupPushNotifications];
    [self setupNavigationController];
    [self setupRestKit];
    [self setupObservers];
    
    // Ubertersters SDK initialization
    //[[Ubertesters shared] initializeWithOptions:UTOptionsManual];
    
    [self.window makeKeyAndVisible];
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
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"Device token is: %@", hexToken);
    [[Device sharedInstance] setDeviceToken:hexToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

-(void)setupPushNotifications {
    
    // register app for receiving push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

-(void)setupNavigationController {
    // init controllers
    BrowseRidesViewController *activityRidesVC = [[BrowseRidesViewController alloc] initWithContentType:ContentTypeCampusRides];
    // RideRequestsViewController *rideRequestVC = [[RideRequestsViewController alloc] init];
    MenuViewController *leftMenu = [[MenuViewController alloc] init];
    
    // init and configure slide panel
    self.navigationController = [[SlideNavigationController alloc] initWithRootViewController:activityRidesVC];
    self.navigationController.avoidSwitchingToSameClassViewController = NO;
    self.navigationController.enableSwipeGesture = YES;
    self.navigationController.portraitSlideOffset = cSlideMenuOffset; // width of visible view controller
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    self.navigationController.navigationBarHidden = YES;
    
    // set root view controller
    self.window.rootViewController = self.navigationController;
}

-(void)setupLeftMenu {
    MenuViewController *menuController = [[MenuViewController alloc] init];
    menuController.preferredContentSize = CGSizeMake(180, 0);
}

-(void)setupRestKit {
    
    NSError *error = nil;
    
    // Initialize RestKit
    NSURL *baseURL = [NSURL URLWithString:API_ADDRESS];

    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // register date formatter compliant with the date format in the backend
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:dateFormatter atIndex:0];
    
    // add mappings to object manager
    [self initMappingsForObjectManager:objectManager];
    
    // complete Core Data stack initialization
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Tumitfahrer.sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if(!persistentStore)
    {
        RKLogError(@"Failed to add persistent store with error: %@", error);
    }
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
}

-(void)initMappingsForObjectManager:(RKObjectManager *)objectManager {
    
    RKEntityMapping *postSessionMapping =[SessionMapping sessionMapping];
    [objectManager addResponseDescriptor:[SessionMapping postSessionResponseDescriptorWithMapping:postSessionMapping]];
    RKObjectMapping *postUserMapping =[UserMapping postUserMapping];
    [objectManager addResponseDescriptor:[UserMapping postUserResponseDescriptorWithMapping:postUserMapping]];
    RKEntityMapping *getRidesMapping = [RideMapping getRidesMapping];
    [objectManager addResponseDescriptor:[RideMapping getRidesResponseDescriptorWithMapping:getRidesMapping]];
    RKObjectMapping *postDeviceTokenMapping = [DeviceMapping postDeviceMapping];
    [objectManager addResponseDescriptor:[DeviceMapping postDeviceResponseDescriptorWithMapping:postDeviceTokenMapping]];
    RKEntityMapping *postRideMapping = [RideMapping postRideMapping];
    [objectManager addResponseDescriptorsFromArray:@[[RideMapping postRideResponseDescriptorWithMapping:postRideMapping]]];
    RKObjectMapping *getRideSearchesMapping = [RideMapping getRideSearchesMapping];
    [objectManager addResponseDescriptor:[RideMapping getRideSearchesResponseDescriptorWithMapping:getRideSearchesMapping]];
}

-(void)setupObservers {
    // for getting location of a specific photo
    [[LocationController sharedInstance] addObserver:[PanoramioUtilities sharedInstance]];
    // for getting location for a specific ride
    [[LocationController sharedInstance] addObserver:[RidesStore sharedStore]];
    // for getting images for a specific location
    [[PanoramioUtilities sharedInstance] addObserver:[RidesStore sharedStore]];
}

@end
