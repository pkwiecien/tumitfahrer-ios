//
//  AppDelegate.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 2/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//
#import <RestKit/RestKit.h>
#import <UbertestersSDK/Ubertesters.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "MenuViewController.h"
#import "Device.h"
#import "UserMapping.h"
#import "SessionMapping.h"
#import "RideMapping.h"
#import "DeviceMapping.h"
#import "RequestMapping.h"
#import "LocationController.h"
#import "PanoramioUtilities.h"
#import "CurrentUser.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "TimelineViewController.h"
#import "TimelinePageViewController.h"
#import "ActivityMapping.h"
#import "RidesStore.h"
#import "ActivityStore.h"
#import "ConversationMapping.h"
#import "MessageMapping.h"
#import "SearchResultMapping.h"
#import "BadgeMapping.h"
#import "RatingMapping.h"

@interface AppDelegate ()

@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // register app for receiving push notifications
    //[self setupPushNotifications];
    
	// Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [self setupNavigationController];
    [self setupRestKit];
    [self setupObservers];
    
    // Ubertersters SDK initialization
    //[[Ubertesters shared] initializeWithOptions:UTOptionsManual];
    
    // Load the FBLoginView class (needed for login)
    [FBLoginView class];
    
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
    [self saveContext];
}

- (void)saveContext
{
    NSLog(@"user is still with apssword: %@", [CurrentUser sharedInstance].user.password);
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [RKManagedObjectStore defaultStore].
    mainQueueManagedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
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
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

-(void)setupNavigationController {
    // init controllers
    MenuViewController *leftMenu = [[MenuViewController alloc] init];
    
    TimelinePageViewController *parentVC = [[TimelinePageViewController alloc] init];
    UINavigationController *navControler = [[UINavigationController alloc] initWithRootViewController:parentVC];

    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navControler
                             leftDrawerViewController:leftMenu
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:NO];
    
    [self.drawerController setMaximumLeftDrawerWidth:280];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    // set root view controller
    self.window.rootViewController = self.drawerController;
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
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
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
    [objectManager addResponseDescriptor:[UserMapping putUserResponseDescriptorWithMapping:postUserMapping]];
    RKEntityMapping *generalRidesMapping = [RideMapping generalRideMapping];
    [objectManager addResponseDescriptor:[RideMapping getRidesResponseDescriptorWithMapping:generalRidesMapping]];
    [objectManager addResponseDescriptor:[RideMapping getSimpleRidesResponseDescriptorWithMapping:generalRidesMapping]];
    [objectManager addResponseDescriptor:[RideMapping getSingleRideResponseDescriptorWithMapping:generalRidesMapping]];
    RKObjectMapping *postDeviceTokenMapping = [DeviceMapping postDeviceMapping];
    [objectManager addResponseDescriptor:[DeviceMapping postDeviceResponseDescriptorWithMapping:postDeviceTokenMapping]];
    RKEntityMapping *postRideMapping = [RideMapping postRideMapping];
    [objectManager addResponseDescriptorsFromArray:@[[RideMapping postRideResponseDescriptorWithMapping:postRideMapping]]];
    RKEntityMapping *requestMapping = [RequestMapping requestMapping];
    [objectManager addResponseDescriptor:[RequestMapping postRequestResponseDescriptorWithMapping:requestMapping]];
    RKEntityMapping *activitiesMapping = [ActivityMapping generalActivityMapping];
    [objectManager addResponseDescriptor:[ActivityMapping getActivityResponseDescriptorWithMapping:activitiesMapping]];
    
    RKEntityMapping *conversationsMapping = [ConversationMapping conversationMapping];
    [objectManager addResponseDescriptor:[ConversationMapping getConversationsResponseDescriptorWithMapping:conversationsMapping]];
    RKEntityMapping *postMessageMapping =[MessageMapping messageMapping];
    [objectManager addResponseDescriptor:[MessageMapping postMessageResponseDescriptorWithMapping:postMessageMapping]];
    
    RKObjectMapping *getRidesIdsMapping = [RideMapping getRideIds];
    [objectManager addResponseDescriptor:[RideMapping getRideIdsresponseDescriptorWithMapping:getRidesIdsMapping]];
    
    [objectManager addResponseDescriptor:[SearchResultMapping postSearchResponseDescriptorWithMapping:generalRidesMapping]];
    
    RKObjectMapping *putRequestMapping = [RequestMapping putRequestMapping];
    [objectManager addResponseDescriptor:[RequestMapping putRequestResponseDescriptorWithMapping:putRequestMapping]];
    
    RKObjectMapping *putRideMapping = [RideMapping putRideMapping];
    [objectManager addResponseDescriptor:[RideMapping putRideResponseDescriptorWithMapping:putRideMapping]];
    
    RKEntityMapping *getUserMapping =[UserMapping userMapping];
    [objectManager addResponseDescriptor:[UserMapping getUserResponseDescriptorWithMapping:getUserMapping]];
    
    RKEntityMapping *getBadgesMapping =[BadgeMapping badgeMapping];
    [objectManager addResponseDescriptor:[BadgeMapping getBadgesResponseDescriptorWithMapping:getBadgesMapping]];
    
    RKEntityMapping *postRatingMapping =[RatingMapping ratingMapping];
    [objectManager addResponseDescriptor:[RatingMapping postRatingResponseDescriptorWithMapping:postRatingMapping]];
}

-(void)setupObservers {
    // for getting location of a specific photo
    [[LocationController sharedInstance] addObserver:[PanoramioUtilities sharedInstance]];
    [[LocationController sharedInstance] addObserver:[RidesStore sharedStore]];
    [[LocationController sharedInstance] addObserver:[ActivityStore sharedStore]];
    // for getting images for a specific location
    [[PanoramioUtilities sharedInstance] addObserver:[RidesStore sharedStore]];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication
             fallbackHandler:
     ^(FBAppCall *call) {
         // Parse the incoming URL to look for a target_url parameter
         NSString *query = [url query];
         NSDictionary *params = [self parseURLParams:query];
         // Check if target URL exists
         NSString *appLinkDataString = [params valueForKey:@"al_applink_data"];
         if (appLinkDataString) {
             NSError *error = nil;
             NSDictionary *applinkData =
             [NSJSONSerialization JSONObjectWithData:[appLinkDataString dataUsingEncoding:NSUTF8StringEncoding]
                                             options:0
                                               error:&error];
             if (!error &&
                 [applinkData isKindOfClass:[NSDictionary class]] &&
                 applinkData[@"target_url"]) {
                 self.refererAppLink = applinkData[@"referer_app_link"];
                 NSString *targetURLString = applinkData[@"target_url"];
                 // Show the incoming link in an alert
                 // Your code to direct the user to the
                 // appropriate flow within your app goes here
                 [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                             message:targetURLString
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }
         }
     }];
    
    return urlWasHandled;
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}
@end
