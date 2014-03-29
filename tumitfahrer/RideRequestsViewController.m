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
#import <MCPanelViewController.h>
#import "MenuViewController.h"

@interface RideRequestsViewController ()

@property NSMutableArray *viewControllers;
@property MCPanelViewController *menuPanelViewController;

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
    menuController.preferredContentSize = CGSizeMake(150, 0);
    
    self.menuPanelViewController = [menuController viewControllerInPanelViewController];
    self.menuPanelViewController.backgroundStyle = MCPanelBackgroundStyleLight;
    self.menuPanelViewController.tintColor = [UIColor colorWithRed:0.7 green:0.7 blue:1 alpha:1];
    
    self.navigationController.navigationBar.hidden = YES;

}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController addGestureRecognizerToViewForScreenEdgeGestureWithPanelViewController:self.menuPanelViewController withDirection:MCPanelAnimationDirectionLeft];
}
-(void)viewDidAppear:(BOOL)animated
{
    BOOL isUserLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];

    if (!isUserLoggedIn) {
        //[self showLoginScreen:YES];
    }
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


- (IBAction)menuButtonPressed:(id)sender {
    [self.navigationController presentPanelViewController:self.menuPanelViewController withDirection:MCPanelAnimationDirectionLeft];
}
@end
