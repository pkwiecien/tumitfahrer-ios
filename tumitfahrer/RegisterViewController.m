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
@property (nonatomic, strong) CustomIOS7AlertView *alertView;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RoadBackground"]];
        [self prepareInputFields];
        [self preparePickerView];
        
        [self.view addSubview:imageView ];
        [self.view sendSubviewToBack:imageView ];
        
        [self.view addSubview:self.emailTextField];
        [self.view addSubview:self.firstNameTextField];
        [self.view addSubview:self.lastNameTextField];
        [self.view addSubview:self.departmentNameTextField];
        [self.view addSubview:self.pickerView];

        self.alertView  = [[CustomIOS7AlertView alloc] init];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.alertView setContainerView:[self createPickerView]];
    
    // Modify the parameters
    [self.alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", @"Select", nil]];
    [self.alertView setDelegate:self];
    [self.alertView setUseMotionEffects:true];
}

-(void)viewWillAppear:(BOOL)animated {
    self.pickerView.hidden = YES;
}

- (void)prepareInputFields {
    
    float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
    UIImage *emailIcon = [ActionManager colorImage:[UIImage imageNamed:@"EmailIconBlack"] withColor:[UIColor whiteColor]];
    self.emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeEmailAddress shouldStartWithCapital:NO];
    
    UIImage *profileIcon = [ActionManager colorImage:[UIImage imageNamed:@"ProfileIcon"] withColor:[UIColor whiteColor]];
    self.firstNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding + self.emailTextField.frame.size.height, cUIElementWidth, cUIElementHeight) placeholderText:@"First name" customIcon:profileIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeDefault shouldStartWithCapital:YES];
    
    self.lastNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding*2 + self.emailTextField.frame.size.height*2, cUIElementWidth, cUIElementHeight) placeholderText:@"Last name" customIcon:profileIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeDefault shouldStartWithCapital:YES];
    
    
    [self.emailTextField addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventAllTouchEvents];
    [self.firstNameTextField addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventAllTouchEvents];
    [self.lastNameTextField addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventAllTouchEvents];
    
    UIImage *campusIcon = [ActionManager colorImage:[UIImage imageNamed:@"CampusIcon"] withColor:[UIColor whiteColor]];
    self.departmentNameTextField = [[CustomTextField alloc] initNotEditableButton:CGRectMake(centerX,cMarginTop + cUIElementPadding*3 + self.emailTextField.frame.size.height*3, cUIElementWidth, cUIElementHeight) placeholderText:@"Department" customIcon:campusIcon];
    [self.departmentNameTextField addTarget:self action:@selector(showDepartmentPickerView) forControlEvents:UIControlEventAllTouchEvents];
}

- (IBAction)registerButtonPressed:(id)sender {
    NSString *email = [[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *firstName = [[self.firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *lastName = [[self.lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    if (email.length < 6 || firstName.length < 3 || lastName.length < 2 ) {
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Input "];
        return;
    } else if(![ActionManager isValidEmail:email]) {
        [ActionManager showAlertViewWithTitle:@"Invalid email" description:@"Please correct your email"];
        return;
    }

    // send a register request to the backend
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *queryParams;
    // add enum
    queryParams = @{@"email": self.emailTextField.text, @"first_name": self.firstNameTextField.text, @"last_name":self.lastNameTextField.text, @"department": @"1"};
    NSDictionary *userParams = @{@"user": queryParams};
    
    [objectManager postObject:nil path:@"/api/v2/users" parameters:userParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        LoginViewController *loginVC = (LoginViewController*)self.presentingViewController;
        loginVC.statusLabel.text = @"Login with the password from the email";
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
    self.pickerView.hidden = !self.pickerView.hidden;
}

- (IBAction)backToLoginButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    self.pickerView.hidden = YES;
    [self.view endEditing:YES];
}

-(void)preparePickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 440, self.view.frame.size.width, 80)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = [UIColor colorWithRed:70 green:30 blue:180 alpha:0.6];
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.departmentNameTextField.text = [[FacultyManager sharedInstance] nameOfFacultyAtIndex:[self.pickerView selectedRowInComponent:0]];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f;
}

- (UIView *)createPickerView {
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    demoView.backgroundColor = [UIColor greenColor];
    
    return demoView;
}


//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    NSInteger nextTag = textField.tag + 1;
//    //-- try to find next responde
//    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//    
//    if (nextResponder)
//    {
//        //-- found next responce ,so set it
//        [nextResponder becomeFirstResponder];
//    }
//    else
//    {
//        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        //-- not found remove keyboard
//        [textField resignFirstResponder];
//        return YES;
//    }
//    
//    return YES;
//}

-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
    }
    [alertView close];
}

@end
