//
//  EditProfileViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "EditProfileViewController.h"
#import "NavigationBarUtilities.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "CustomBarButton.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupView];
    [self configureColors];
}

-(void)setupView {
    self.view.backgroundColor = [UIColor customLightGray];
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lightestBlue]];
    self.title = @"Edit Profile";
    
    UIButton *settingsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [settingsView addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingsView setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"DeleteIcon2"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsView];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
    
    // right button of the navigation bar
    CustomBarButton *saveButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [saveButton addTarget:self action:@selector(updateProfileButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
}

-(void)configureColors {
    [self.updateButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"blueButton"] withColor:[UIColor lightestBlue]] forState:UIControlStateNormal];
}

-(void)closeButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)updateProfileButtonPressed {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[ActionManager encryptCredentialsWithEmail:[CurrentUser sharedInstance].user.email encryptedPassword:[CurrentUser sharedInstance].user.password]];

    NSLog(@"user : %@ , pass: %@", [CurrentUser sharedInstance].user.email, [CurrentUser sharedInstance].user.password);
    
    NSDictionary *queryParams;
    // add enum
    NSString *encryptedPassword = [ActionManager createSHA512:self.passwordTextField.text];
    queryParams = @{@"password": encryptedPassword, @"password_confirmation": encryptedPassword, @"car": self.carTextField.text, @"phone_number":self.phoneNumberTextField.text};
    NSDictionary *userParams = @{@"user": queryParams};
    
    [objectManager putObject:nil path:[NSString stringWithFormat:@"/api/v2/users/%@", [CurrentUser sharedInstance].user.userId] parameters:userParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [CurrentUser sharedInstance].user.car = self.carTextField.text;
        [CurrentUser sharedInstance].user.password = encryptedPassword;
        [CurrentUser sharedInstance].user.phoneNumber = self.phoneNumberTextField.text;
        
        NSError *error;
        if (![[CurrentUser sharedInstance].user.managedObjectContext saveToPersistentStore:&error]) {
            NSLog(@"Whoops");
        }

        RKLogInfo(@"Load complete, current user %@!", [CurrentUser sharedInstance].user.firstName);
        [self closeButtonPressed];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
    }];
    
}
@end
