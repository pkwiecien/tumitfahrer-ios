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

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
        CustomTextField *emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIconName:@"customIcon" returnKeyType:UIReturnKeyNext];
        emailTextField.delegate = self;
        
        CustomTextField *firstNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding + emailTextField.frame.size.height, cUIElementWidth, cUIElementHeight) placeholderText:@"First name" customIconName:@"customIcon" returnKeyType:UIReturnKeyNext];
        firstNameTextField.delegate = self;
        
        CustomTextField *lastNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop + cUIElementPadding*2 + emailTextField.frame.size.height*2, cUIElementWidth, cUIElementHeight) placeholderText:@"Last name" customIconName:@"customIcon" returnKeyType:UIReturnKeyNext];
        lastNameTextField.delegate = self;
        
        // TODO: show picker instead of department
        CustomTextField *departmentNameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX,cMarginTop + cUIElementPadding*3 + emailTextField.frame.size.height*3, cUIElementWidth, cUIElementHeight) placeholderText:@"Department" customIconName:@"customIcon" returnKeyType:UIReturnKeyDone];
        departmentNameTextField.delegate = self;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        
        [self.view addSubview:imageView ];
        [self.view sendSubviewToBack:imageView ];
        
        [self.view addSubview:emailTextField];
        [self.view addSubview:firstNameTextField];
        [self.view addSubview:lastNameTextField];
        [self.view addSubview:departmentNameTextField];
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
}

- (IBAction)backToLoginButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

@end
