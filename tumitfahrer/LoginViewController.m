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

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
        float buttonWidth = 253;
        float centerX = (self.view.frame.size.width - buttonWidth)/2;
        CustomTextField *emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, 100, buttonWidth, 40) placeholderText:@"Your TUM email" customIconName:@"customIcon"];
        emailTextField.delegate = self;
        
        CustomTextField *passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, 160, buttonWidth, 40) placeholderText:@"Your password" customIconName:@"customIcon"];
        passwordTextField.delegate = self;
        
        [self.view addSubview:emailTextField];
        [self.view addSubview:passwordTextField];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        
        [self.view addSubview:imageView ];
        [self.view sendSubviewToBack:imageView ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:@"emailLoggedInUser"];
    if (email) {
//        self.emailField.text = email;
    }
}

- (IBAction)loginButtonPressed:(id)sender {

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
