//
//  LoginViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "RideRequestsViewController.h"

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
        CustomTextField *emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, 100, buttonWidth, 40)];
        emailTextField.delegate = self;
        
        CustomTextField *passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(centerX, 160, buttonWidth, 40)];
        passwordTextField.delegate = self;
        
        [self.view addSubview:emailTextField];
        [self.view addSubview:passwordTextField];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        
        [self.view addSubview:imageView ];
        [self.view sendSubviewToBack:imageView ];
        /*
        UIImage *backgroundImage= [UIImage imageNamed:@"background"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];*/
                
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:@"emailLoggedInUser"];
    if (email) {
//        self.emailField.text = email;
    }
    
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
