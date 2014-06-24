//
//  RegisterViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomTextField.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "LoginViewController.h"
#import "FacultyManager.h"
#import "CustomIOS7AlertView.h"

@interface RegisterViewController () <CustomIOS7AlertViewDelegate>

@property (nonatomic, strong) CustomTextField *emailTextField;
@property (nonatomic, strong) CustomTextField *firstNameTextField;
@property (nonatomic, strong) CustomTextField *lastNameTextField;
@property (nonatomic, strong) CustomTextField *departmentNameTextField;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RoadBackground.jpg"]];
        [self prepareInputFields];
        
        [self.view addSubview:imageView ];
        [self.view sendSubviewToBack:imageView ];
        
        [self.view addSubview:self.emailTextField];
        [self.view addSubview:self.firstNameTextField];
        [self.view addSubview:self.lastNameTextField];
        [self.view addSubview:self.departmentNameTextField];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Register screen";
}

- (void)prepareInputFields {
    
    float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
    UIImage *emailIcon = [ActionManager colorImage:[UIImage imageNamed:@"EmailIconBlack"] withColor:[UIColor whiteColor]];
    self.emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeEmailAddress shouldStartWithCapital:NO];
    self.emailTextField.tag = 10;
    self.emailTextField.delegate = self;
    
    UIImage *profileIcon = [ActionManager colorImage:[UIImage imageNamed:@"ProfileIcon"] withColor:[UIColor whiteColor]];
    self.firstNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding + self.emailTextField.frame.size.height, cUIElementWidth, cUIElementHeight) placeholderText:@"First name" customIcon:profileIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeDefault shouldStartWithCapital:YES];
    self.firstNameTextField.tag = 11;
    self.firstNameTextField.delegate = self;
    
    self.lastNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding*2 + self.emailTextField.frame.size.height*2, cUIElementWidth, cUIElementHeight) placeholderText:@"Last name" customIcon:profileIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeDefault shouldStartWithCapital:YES];
    self.lastNameTextField.tag = 12;
    self.lastNameTextField.delegate = self;
    
    UIImage *campusIcon = [ActionManager colorImage:[UIImage imageNamed:@"CampusIcon"] withColor:[UIColor whiteColor]];
    self.departmentNameTextField = [[CustomTextField alloc] initNotEditableButton:CGRectMake(centerX,cMarginTop + cUIElementPadding*3 + self.emailTextField.frame.size.height*3, cUIElementWidth, cUIElementHeight) placeholderText:@"Department" customIcon:campusIcon];
    [self.departmentNameTextField addTarget:self action:@selector(showDepartmentPickerView) forControlEvents:UIControlEventTouchDown];
}

- (IBAction)registerButtonPressed:(id)sender {
    NSString *email = [[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *firstName = [[self.firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *lastName = [[self.lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (email.length < 6 || firstName.length < 2 || lastName.length < 2 ) {
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Please correct information about you."];
        return;
    } else if(![ActionManager isValidEmail:email]) {
        [ActionManager showAlertViewWithTitle:@"Invalid email" description:@"Please correct your email"];
        return;
    }

    // send a register request to the backend
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *queryParams;
    // add enum
    queryParams = @{@"email": self.emailTextField.text, @"first_name": self.firstNameTextField.text, @"last_name":self.lastNameTextField.text, @"department": [NSNumber numberWithInt:(int)[[FacultyManager sharedInstance] indexForFacultyName:self.departmentNameTextField.text]]};
    NSDictionary *userParams = @{@"user": queryParams};
    
    [objectManager postObject:nil path:@"/api/v2/users" parameters:userParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        LoginViewController *loginVC = (LoginViewController*)self.presentingViewController;
        loginVC.statusLabel.text = @"Please check your email";
        [self storeEmailInDefaults];
        [self backToLoginButtonPressed:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [ActionManager showAlertViewWithTitle:@"Error" description:@"Could not create new user"];
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(void)storeEmailInDefaults {
    [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:@"storedEmail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showDepartmentPickerView {
    [self.view endEditing:YES];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setContainerView:[self preparePickerView]];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Select", nil]];
    [alertView setDelegate:self];
    [alertView setUseMotionEffects:false];
    [alertView show];
}

- (IBAction)backToLoginButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(UIPickerView *)preparePickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView selectRow:[[FacultyManager sharedInstance] indexForFacultyName:self.departmentNameTextField.text] inComponent:0 animated:NO];
    return self.pickerView;
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.departmentNameTextField.text = [[FacultyManager sharedInstance] nameOfFacultyAtIndex:[self.pickerView selectedRowInComponent:0]];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    //try to find next responder
    CustomTextField *nextTextField = (CustomTextField *)[self.view viewWithTag:nextTag];
    
    if (nextTextField) {
        // found next responce ,so set it
        [nextTextField becomeFirstResponder];
    }
    else {
        // not found remove keyboard
        [textField resignFirstResponder];
        return YES;
    }
    
    return YES;
}

-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([self.departmentNameTextField.text isEqualToString:@""]) {
            self.departmentNameTextField.text = [[FacultyManager sharedInstance] nameOfFacultyAtIndex:0];
        }
    }
    [alertView close];
}

@end
