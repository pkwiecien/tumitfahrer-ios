//
//  LoginViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "RideRequestsViewController.h"
#import <SlideNavigationController.h>
#import "Ride.h"

@interface LoginViewController () <NSFetchedResultsControllerDelegate>

@property CustomTextField *emailTextField;
@property CustomTextField *passwordTextField;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
        UIImage *emailWhiteIcon = [ActionManager colorImage:[UIImage imageNamed:@"EmailIcon"] withColor:[UIColor whiteColor]];
        self.emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailWhiteIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeEmailAddress shouldStartWithCapital:NO];
        
        UIImage *passwordWhiteIcon = [ActionManager colorImage:[UIImage imageNamed:@"PasswordIcon"] withColor:[UIColor whiteColor]];
        self.passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop+self.emailTextField.frame.size.height + cUIElementPadding, cUIElementWidth, cUIElementHeight) placeholderText:@"Your password" customIcon:passwordWhiteIcon returnKeyType:UIReturnKeyDone keyboardType:UIKeyboardTypeDefault secureInput:YES];
        
        [self.view addSubview:self.emailTextField];
        [self.view addSubview:self.passwordTextField];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized)];
    tapRecognizer.delegate = self;
    // Add the gesture to the view
    [self.view addGestureRecognizer:tapRecognizer];
    
    // Set debug logging level to 'RKLogLevelTrace' to see JSON payload
    RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:@"storedEmail"];
    if (email!=nil) {
        self.emailTextField.text = email;
    }
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"highway-nosound@2x" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    
    if(self.moviePlayerController == nil) {
        self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(introMovieFinished:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayerController];
        
        // Hide the video controls from the user
        [self.moviePlayerController setControlStyle:MPMovieControlStyleNone];
        
        [self.moviePlayerController prepareToPlay];
        [self.moviePlayerController.view setFrame: CGRectMake(0, 0, 416, 1100)];
        [self.view addSubview:self.moviePlayerController.view];
        [self.view sendSubviewToBack:self.moviePlayerController.view];
    }
    [self.moviePlayerController play];
}

- (void)introMovieFinished:(NSNotification *)notification
{
    [self.moviePlayerController play];
}

- (IBAction)loginButtonPressed:(id)sender {
    
    // firstly check if the user was previously stored in core data
    if ([CurrentUser fetchUserFromCoreDataWithEmail:self.emailTextField.text encryptedPassword:[ActionManager createSHA512:self.passwordTextField.text]] ) {
        // user fetched successfully from core data
        [self storeCurrentUserInDefaults];
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // new user, get account from webservice
        [self createUserSession];
    }
}

- (void)createUserSession {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[ActionManager encryptCredentialsWithEmail:self.emailTextField.text password:self.passwordTextField.text]];
    
    [objectManager postObject:nil path:@"/api/v2/sessions" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        User *user = (User *)[mappingResult firstObject];
        user.password = [ActionManager createSHA512:self.passwordTextField.text];
        [CurrentUser sharedInstance].user = user;
        
        RKLogInfo(@"Load complete, current user %@ with id: %d!", [CurrentUser sharedInstance].user, [CurrentUser sharedInstance].user.userId);
        
        NSError *error;
        if (![[CurrentUser sharedInstance].user.managedObjectContext saveToPersistentStore:&error]) {
            NSLog(@"Whoops");
        }
        
        // check if everything is OK with user rides as driver
        for (Ride *ride in [CurrentUser sharedInstance].user.ridesAsDriver) {
            NSLog(@"ride of user: %d %@", ride.rideId, ride.destination);
        }
        
        RKLogInfo(@"Load complete, current user %@ with id: %d!", [CurrentUser sharedInstance].user, [CurrentUser sharedInstance].user.userId);

        
        // check if fetch user has assigned a device token
        [self checkDeviceToken];
                
        [self storeCurrentUserInDefaults];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [ActionManager showAlertViewWithTitle:@"Invalid email/password" description:@"Could not authenticate, please check your credentials."];
        RKLogError(@"Load failed with error: %@", error);
    }];
}


/*-(void)getUserRidesAsDriver {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSString *path = [NSString stringWithFormat:@"/api/v2/users/%d/rides?driver", [CurrentUser sharedInstance].user.userId];
    [objectManager getObject:self path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *rides = [mappingResult array];
        for (Ride *ride in rides) {
            NSLog(@"ride id: %d, destination: %@", ride.rideId, ride.destination);
        }
//
//        NSFetchRequest *request = [[NSFetchRequest alloc] init];
//        NSEntityDescription *e = [NSEntityDescription entityForName:@"User"
//                                             inManagedObjectContext:[RKManagedObjectStore defaultStore].
//                                  mainQueueManagedObjectContext];
//        NSPredicate *predicate;
//        predicate = [NSPredicate predicateWithFormat:@"(userId = %d)", [CurrentUser sharedInstance].user.userId];
//        
//        [request setPredicate:predicate];
//        [request setReturnsObjectsAsFaults:NO];
//        
//        request.entity = e;
//        
//        NSError *error;
//        NSArray *fetchedObjects = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:request error:&error];
//        if (!fetchedObjects) {
//            [NSException raise:@"Fetch failed"
//                        format:@"Reason: %@", [error localizedDescription]];
//        }
        
//        User *user = [fetchedObjects firstObject];
        [CurrentUser sharedInstance].user.ridesAsDriver = [NSSet setWithArray:rides];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}*/


-(void)checkDeviceToken {
    
    [[CurrentUser sharedInstance] hasDeviceTokenInWebservice:^(BOOL tokenExistsInDatabase) {
        // device token is not in db, need to send it
        if (!tokenExistsInDatabase && [CurrentUser sharedInstance].user.userId > 0) {
            [[CurrentUser sharedInstance] sendDeviceTokenToWebservice];
        }
    }];
}

-(void)storeCurrentUserInDefaults {
    [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:@"emailLoggedInUser"];
    [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:@"storedEmail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// show register view
- (IBAction)registerButtonPressed:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self presentViewController:registerVC animated:NO completion:nil];
}

// show forgot password view
- (IBAction)forgotPasswordButtonPressed:(id)sender {
    ForgotPasswordViewController *forgotVC = [[ForgotPasswordViewController alloc] init];
    [self presentViewController:forgotVC animated:NO completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(void)tapRecognized
{
    
}

#pragma mark - Fetched results controller

-(NSFetchedResultsController *)fetchedResultsController
{
    if (self.fetchedResultsController != nil) {
        return self.fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[RKManagedObjectStore defaultStore].
                                     mainQueueManagedObjectContext
                                     sectionNameKeyPath:nil cacheName:@"User"];
    self.fetchedResultsController.delegate = self;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        [ActionManager showAlertViewWithTitle:[error localizedDescription]];
    }
    
    return self.fetchedResultsController;
}


@end
