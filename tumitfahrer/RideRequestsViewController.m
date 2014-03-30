//
//  RideRequestsViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideRequestsViewController.h"
#import "LoginViewController.h"
#import "CustomTextField.h"
#import "ColorFullView.h"
#import "ForgotPasswordViewController.h"
#import "RegisterViewController.h"
#import "MenuViewController.h"

@interface RideRequestsViewController ()

@property NSMutableArray *viewControllers;

@end

@implementation RideRequestsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MenuViewController *menuController = [[MenuViewController alloc] init];
    menuController.preferredContentSize = CGSizeMake(180, 0);
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
}
-(void)viewDidAppear:(BOOL)animated
{
    BOOL isUserLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];

//    if (!isUserLoggedIn) {
//        [self showLoginScreen:YES];
//  }
}

-(void)showLoginScreen:(BOOL)animated
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


#pragma mark - IBActions -
- (IBAction)menuButtonPressed:(id)sender {
    UIViewController *test = [SlideNavigationController sharedInstance].leftMenu;
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

@end
