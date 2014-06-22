//
//  ForgotPasswordViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "CustomTextField.h"
#import "ActionManager.h"
#import "LoginViewController.h"

@interface ForgotPasswordViewController ()

@property (nonatomic, strong) CustomTextField *emailTextField;
@end

@implementation ForgotPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float centerX = (self.view.frame.size.width - cUIElementWidth)/2;
    UIImage *emailIcon = [ActionManager colorImage:[UIImage imageNamed:@"EmailIconBlack"] withColor:[UIColor whiteColor]];
     self.emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeEmailAddress shouldStartWithCapital:NO];
    [self.view addSubview:self.emailTextField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DayRoadBackground.jpg"]];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}


-(void)viewWillAppear:(BOOL)animated {
    NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:@"storedEmail"];
    if (email!=nil) {
        self.emailTextField.text = email;
    }
}
-(NSURLRequest*)buildUrlRequest {
    
    NSString *urlString = [API_ADDRESS stringByAppendingString:[NSString stringWithFormat:@"/api/v2/forgot?email=%@", self.emailTextField.text]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    return urlRequest;
}

- (IBAction)sendReminderButtonPressed:(id)sender {
    
    if (self.emailTextField.text.length == 0 || ![ActionManager isValidEmail:self.emailTextField.text]) {
        [ActionManager showAlertViewWithTitle:@"Invalid input" description:@"Your email is invalid, please correct it"];
        return;
    }
    
    [NSURLConnection sendAsynchronousRequest:[self buildUrlRequest] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            NSLog(@"Could not request password reminder. Error connecting data from server: %@", connectionError.localizedDescription);
        } else {
            NSLog(@"Password reminder sent successfully");
            LoginViewController *loginVC = (LoginViewController*)self.presentingViewController;
            loginVC.statusLabel.text = @"Please check your email";
            [self backToLoginButtonPressed:nil];
        }
    }];
}

- (IBAction)backToLoginButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}
@end
