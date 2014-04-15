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
#import "LoginViewController.h"
#import "FacultyManager.h"

@interface RegisterViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) CustomTextField *emailTextField;
@property (nonatomic, strong) CustomTextField *firstNameTextField;
@property (nonatomic, strong) CustomTextField *lastNameTextField;
@property (nonatomic, strong) CustomTextField *departmentNameTextField;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        [self prepareInputFields];
        [self preparePickerView];
        
        [self.view addSubview:imageView ];
        [self.view sendSubviewToBack:imageView ];
        
        [self.view addSubview:self.emailTextField];
        [self.view addSubview:self.firstNameTextField];
        [self.view addSubview:self.lastNameTextField];
        [self.view addSubview:self.departmentNameTextField];
        [self.view addSubview:self.pickerView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    self.pickerView.hidden = YES;
}

- (void)prepareInputFields {
    
    float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
    UIImage *emailIcon = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"EmailIcon"] withColor:[UIColor whiteColor]];
    self.emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeEmailAddress shouldStartWithCapital:NO];
    
    UIImage *profileIcon = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"ProfileIcon"] withColor:[UIColor whiteColor]];
    self.firstNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding + self.emailTextField.frame.size.height, cUIElementWidth, cUIElementHeight) placeholderText:@"First name" customIcon:profileIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeDefault shouldStartWithCapital:YES];
    
    self.lastNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding*2 + self.emailTextField.frame.size.height*2, cUIElementWidth, cUIElementHeight) placeholderText:@"Last name" customIcon:profileIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeDefault shouldStartWithCapital:YES];
    
    
    [self.emailTextField addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventAllTouchEvents];
    [self.firstNameTextField addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventAllTouchEvents];
    [self.lastNameTextField addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventAllTouchEvents];
    
    // TODO: show picker instead of department
    UIImage *campusIcon = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"CampusIcon"] withColor:[UIColor whiteColor]];
    self.departmentNameTextField = [[CustomTextField alloc] initNotEditableButton:CGRectMake(centerX,cMarginTop + cUIElementPadding*3 + self.emailTextField.frame.size.height*3, cUIElementWidth, cUIElementHeight) placeholderText:@"Department" customIcon:campusIcon];
    [self.departmentNameTextField addTarget:self action:@selector(showDepartmentPickerView) forControlEvents:UIControlEventAllTouchEvents];
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

- (void)showDepartmentPickerView {
    [self.view endEditing:YES];
    self.pickerView.hidden = !self.pickerView.hidden;
}

- (IBAction)backToLoginButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    self.pickerView.hidden = YES;
    [self.view endEditing:YES];
}

-(NSFetchedResultsController *)fetchedResultsController {
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

-(void)preparePickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 440, self.view.frame.size.width, 80)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = [UIColor colorWithRed:70 green:30 blue:180 alpha:0.6];

    // alternative to pickerView:didSelect
//    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
//    tapGesture.cancelsTouchesInView = NO;
//    tapGesture.delegate = self;
//    [self.pickerView addGestureRecognizer:tapGesture];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

- (void)hidePickerView {
    self.pickerView.hidden = YES;
}

#pragma mark - picker view delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[[FacultyManager sharedInstance] allFaculties] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[FacultyManager sharedInstance] nameOfFacultyAtIndex:row];
}

/*
- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = self.pickerView.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, self.pickerView.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
        self.departmentNameTextField.text = [[FacultyManager sharedInstance] nameOfFacultyAtIndex:[self.pickerView selectedRowInComponent:0]];
        self.pickerView.hidden = YES;
    }
} */

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.departmentNameTextField.text = [[FacultyManager sharedInstance] nameOfFacultyAtIndex:[self.pickerView selectedRowInComponent:0]];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f;
}

@end
