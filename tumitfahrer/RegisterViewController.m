//
//  RegisterViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomTextField.h"
#import "Constants.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "StatusResponse.h"
#import "LoginViewController.h"

@interface RegisterViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) CustomTextField *emailTextField;
@property (nonatomic, strong) CustomTextField *firstNameTextField;
@property (nonatomic, strong) CustomTextField *lastNameTextField;
@property (nonatomic, strong) CustomTextField *departmentNameTextField;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
        UIImage *emailIcon = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"EmailIcon"] withColor:[UIColor whiteColor]];
        self.emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeEmailAddress shouldStartWithCapital:NO];
        
        UIImage *profileIcon = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"ProfileIcon"] withColor:[UIColor whiteColor]];
        self.firstNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding + self.emailTextField.frame.size.height, cUIElementWidth, cUIElementHeight) placeholderText:@"First name" customIcon:profileIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeDefault shouldStartWithCapital:YES];
        
        self.lastNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding*2 + self.emailTextField.frame.size.height*2, cUIElementWidth, cUIElementHeight) placeholderText:@"Last name" customIcon:profileIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeDefault shouldStartWithCapital:YES];
        
        // TODO: show picker instead of department
        UIImage *campusIcon = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"CampusIcon"] withColor:[UIColor whiteColor]];
        self.departmentNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX,cMarginTop + cUIElementPadding*3 + self.emailTextField.frame.size.height*3, cUIElementWidth, cUIElementHeight) placeholderText:@"Department" customIcon:campusIcon returnKeyType:UIReturnKeyDone keyboardType:UIKeyboardTypeDefault shouldStartWithCapital:NO];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        
        [self.view addSubview:imageView ];
        [self.view sendSubviewToBack:imageView ];
        
        [self.view addSubview:self.emailTextField];
        [self.view addSubview:self.firstNameTextField];
        [self.view addSubview:self.lastNameTextField];
        [self.view addSubview:self.departmentNameTextField];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)registerButtonPressed:(id)sender {
    // send a register request to the backend
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *queryParams;
    // add enum
    queryParams = @{@"email": self.emailTextField.text, @"first_name": self.firstNameTextField.text, @"last_name":self.lastNameTextField.text, @"department": @"1"};
    NSDictionary *userParams = @{@"user": queryParams};
    
    [objectManager postObject:nil path:@"/api/v2/users" parameters:userParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        LoginViewController *loginVC = (LoginViewController*)self.presentingViewController;
        loginVC.statusLabel.text = @"Login with the password from the email";
        [self backToLoginButtonPressed:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[ActionManager sharedManager] showAlertViewWithTitle:[error localizedDescription]];
        RKLogError(@"Load failed with error: %@", error);
    }];
}

- (IBAction)backToLoginButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

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
        [[ActionManager sharedManager] showAlertViewWithTitle:[error localizedDescription]];
    }
    
    return self.fetchedResultsController;
}

@end
