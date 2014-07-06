//
//  EditProfileFieldViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/12/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "EditProfileFieldViewController.h"
#import "CustomBarButton.h"
#import "NavigationBarUtilities.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface EditProfileFieldViewController ()

@property (nonatomic, strong) NSString *passwordString;

@end

@implementation EditProfileFieldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    self.textView.delegate = self;
    self.passwordString = @"";
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.updatedFiled == Password) {
        self.textView.text = self.initialDescription = @"";
        [self.textView setSecureTextEntry:YES];
    } else {
        self.textView.text = self.initialDescription;
    }
    [self.textView becomeFirstResponder];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lightestBlue]];
    
    // right button of the navigation bar
    CustomBarButton *rightBarButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
#ifdef DEBUG
    [rightBarButton setAccessibilityLabel:@"Save Button"];
    [rightBarButton setIsAccessibilityElement:YES];
#endif
    [rightBarButton addTarget:self action:@selector(rightBarButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightBarButtonPressed {
    if (self.textView.text.length == 0) {
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Before saving changes, please fill in the text view"];
    } else if(self.updatedFiled == Password && self.textView.text.length < 6) {
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Password needs to be at least 6 characters long"];
    }
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[ActionManager encryptCredentialsWithEmail:[CurrentUser sharedInstance].user.email encryptedPassword:[CurrentUser sharedInstance].user.password]];
    
    NSString *encryptedPassword = [CurrentUser sharedInstance].user.password;

    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:encryptedPassword, @"password", encryptedPassword, @"password_confirmation", [CurrentUser sharedInstance].user.car, @"car",[CurrentUser sharedInstance].user.phoneNumber, @"phone_number", [CurrentUser sharedInstance].user.firstName,@"first_name" , [CurrentUser sharedInstance].user.lastName,  @"last_name",  [CurrentUser sharedInstance].user.department,@"department", nil];
    
    NSString *trimmedString = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *escapedString = [trimmedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // add enum
    switch (self.updatedFiled) {
        case FirstName:
            [queryParams setValue:escapedString forKey:@"first_name"];
            break;
        case LastName:
            [queryParams setValue:escapedString forKey:@"last_name"];
            break;
        case Phone:
            [queryParams setValue:escapedString forKey:@"phone_number"];
            break;
        case Car:
            [queryParams setValue:escapedString forKey:@"car"];
            break;
        case Password:
            encryptedPassword = [ActionManager createSHA512:self.passwordString];
            [queryParams setValue:encryptedPassword forKey:@"password"];
            [queryParams setValue:encryptedPassword forKey:@"password_confirmation"];
            break;
        case Department:
            [queryParams setValue:escapedString forKey:@"department"];
            break;
        default:
            break;
    }
    NSDictionary *userParams = @{@"user": queryParams};
    
    [objectManager putObject:nil path:[NSString stringWithFormat:@"/api/v2/users/%@", [CurrentUser sharedInstance].user.userId] parameters:userParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self updateLocalValues:trimmedString];
        [self.navigationController popViewControllerAnimated:YES];

        NSError *error;
        if (![[CurrentUser sharedInstance].user.managedObjectContext saveToPersistentStore:&error]) {
            NSLog(@"Whoops. Could not save edited values for user profile.");
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
    }];
    
}

-(void)updateLocalValues:(NSString *)string {
    switch (self.updatedFiled) {
        case FirstName:
            [CurrentUser sharedInstance].user.firstName = string;
            break;
        case LastName:
            [CurrentUser sharedInstance].user.lastName = string;
            break;
        case Email:
            break;
        case Phone:
            [CurrentUser sharedInstance].user.phoneNumber = string;
            break;
        case Car:
            [CurrentUser sharedInstance].user.car = string;
            break;
        case Password:
            [CurrentUser sharedInstance].user.password  = [ActionManager createSHA512:self.passwordString];
            break;
        case Department:
            [CurrentUser sharedInstance].user.department  = [NSNumber numberWithInt:[string intValue]];
            break;
        default:
            break;
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    
    if (self.updatedFiled == Password) {
        if (self.textView.text.length > self.passwordString.length) {
            self.passwordString = [self.passwordString stringByAppendingFormat:@"%c",[self.textView.text characterAtIndex:(self.textView.text.length-1)]];
            self.textView.text = [self.textView.text stringByReplacingCharactersInRange:NSMakeRange(self.textView.text.length-1,1) withString:@"●"];
        } else if(self.textView.text.length < self.passwordString.length && self.passwordString.length > 0) {
            self.passwordString = [self.passwordString stringByReplacingCharactersInRange:NSMakeRange(self.passwordString.length-1,1) withString:@""];
        }
    }
}

-(void)dealloc {
    self.textView.delegate = nil;
}
    
@end
