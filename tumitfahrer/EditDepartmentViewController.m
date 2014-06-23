//
//  EditRepartmentViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "EditDepartmentViewController.h"
#import "FacultyManager.h"
#import "NavigationBarUtilities.h"
#import "CustomBarButton.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface EditDepartmentViewController ()

@property NSUInteger chosenFaculty;

@end

@implementation EditDepartmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.chosenFaculty = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor customLightGray];
    [self.pickerView selectRow:[[CurrentUser sharedInstance].user.department intValue] inComponent:0 animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    
    // right button of the navigation bar
    CustomBarButton *rightBarButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [rightBarButton addTarget:self action:@selector(rightBarButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[FacultyManager sharedInstance] allFaculties].count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.chosenFaculty = row;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[FacultyManager sharedInstance] nameOfFacultyAtIndex:row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50.0f;
}

-(void)rightBarButtonPressed {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient setDefaultHeader:@"Authorization: Basic" value:[ActionManager encryptCredentialsWithEmail:[CurrentUser sharedInstance].user.email encryptedPassword:[CurrentUser sharedInstance].user.password]];
    
    NSString *encryptedPassword = [CurrentUser sharedInstance].user.password;

    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:encryptedPassword, @"password", encryptedPassword, @"password_confirmation", [CurrentUser sharedInstance].user.car, @"car",[CurrentUser sharedInstance].user.phoneNumber, @"phone_number", [CurrentUser sharedInstance].user.firstName,@"first_name" , [CurrentUser sharedInstance].user.lastName,  @"last_name",  [CurrentUser sharedInstance].user.department,@"department", nil];
    
    NSDictionary *userParams = @{@"user": queryParams};
    NSNumber *facultyNumber =[NSNumber numberWithInt:(int)self.chosenFaculty];
    [queryParams setValue:facultyNumber forKey:@"department"];

    [objectManager putObject:nil path:[NSString stringWithFormat:@"/api/v2/users/%@", [CurrentUser sharedInstance].user.userId] parameters:userParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [CurrentUser sharedInstance].user.department = facultyNumber;
        [self.navigationController popViewControllerAnimated:YES];
        
        NSError *error;
        if (![[CurrentUser sharedInstance].user.managedObjectContext saveToPersistentStore:&error]) {
            NSLog(@"Whoops. Could not save edited values for user profile.");
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Load failed with error: %@", error);
    }];
    
}
@end
