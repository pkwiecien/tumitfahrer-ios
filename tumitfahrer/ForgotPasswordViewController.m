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
#import "ActionManager.h"

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
    UIImage *emailIcon = [[ActionManager sharedManager] colorImage:[UIImage imageNamed:@"EmailIcon"] withColor:[UIColor whiteColor]];
    CustomTextField *emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeEmailAddress];
    [self.view addSubview:emailTextField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"road"]];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
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
