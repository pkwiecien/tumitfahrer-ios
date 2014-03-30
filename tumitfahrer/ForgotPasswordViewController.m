//
//  ForgotPasswordViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Constants.h"
#import "CustomTextField.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

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
    
    float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
    CustomTextField *emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIconName:@"customIcon" returnKeyType:UIReturnKeyNext];
    emailTextField.delegate = self;
    [self.view addSubview:emailTextField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"road2"]];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToLoginButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)sendReminderButtonPressed:(id)sender {
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}
@end
