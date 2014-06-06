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
    UIImage *emailIcon = [ActionManager colorImage:[UIImage imageNamed:@"EmailIcon"] withColor:[UIColor whiteColor]];
    CustomTextField *emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, cMarginTop, cUIElementWidth, cUIElementHeight) placeholderText:@"Your TUM email" customIcon:emailIcon returnKeyType:UIReturnKeyNext keyboardType:UIKeyboardTypeEmailAddress shouldStartWithCapital:NO];
    [self.view addSubview:emailTextField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DayRoadBackground"]];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

-(NSURLRequest*)buildUrlRequest {
    
    NSString *urlString = [API_ADDRESS stringByAppendingString:@"/api/v2/forgot"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    return urlRequest;
}

- (IBAction)sendReminderButtonPressed:(id)sender {
    
    [NSURLConnection sendAsynchronousRequest:[self buildUrlRequest] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            NSLog(@"Could not request password reminder. Error connecting data from server: %@", connectionError.localizedDescription);
        } else {
            NSLog(@"Password reminder sent successfully");
            LoginViewController *loginVC = (LoginViewController*)self.presentingViewController;
            loginVC.statusLabel.text = @"Password sent to your email address";
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
