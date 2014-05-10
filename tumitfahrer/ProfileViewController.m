//
//  ProfileViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/5/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ProfileViewController.h"
#import "ActionManager.h"
#import "NavigationBarUtilities.h"
#import "EditProfileViewController.h"

@interface ProfileViewController ()

@property (nonatomic) UIColor *customGrayColor;
@end

@implementation ProfileViewController

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
    self.customGrayColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.view setBackgroundColor:self.customGrayColor];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // border
    [self.profileView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.profileView.layer setBorderWidth:0.5f];
    
    // drop shadow
    [self.profileView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.profileView.layer setShadowOpacity:0.6];
    [self.profileView.layer setShadowRadius:3.0];
    [self.profileView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    // border
    [self.tableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.tableView.layer setBorderWidth:0.5f];
    
    // drop shadow
    [self.tableView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.tableView.layer setShadowOpacity:0.6];
    [self.tableView.layer setShadowRadius:3.0];
    [self.tableView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    [self.ridesButton setSelected:YES];

    [self.ridesButton setBackgroundImage:[ActionManager imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.ratingButton setBackgroundImage:[ActionManager imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [self.ridesButton setBackgroundImage:[ActionManager imageWithColor:self.customGrayColor] forState:UIControlStateSelected];
    [self.ratingButton setBackgroundImage:[ActionManager imageWithColor:self.customGrayColor] forState:UIControlStateSelected];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self setupNavbar];
    [self setupView];
    
}

-(void)setupView {
    self.view = [NavigationBarUtilities makeBackground:self.view];
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController];
    self.title = @"PROFILE";
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(displayEditProfilePage)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.title = @"PROFILE";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

-(void)displayEditProfilePage {
    
    EditProfileViewController *editProfileVC = [[EditProfileViewController alloc] init];
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:editProfileVC];
    [self.navigationController presentViewController:navBar animated:YES completion:nil];
}

- (IBAction)ridesButtonPressed:(id)sender {
    [self resetButtons];
    [self.ridesButton setSelected:YES];
}
- (IBAction)ratingButtonPressed:(id)sender {
    [self resetButtons];
    [self.ratingButton setSelected:YES];
}


-(void)resetButtons
{
    [self.ridesButton setSelected:NO];
    [self.ratingButton setSelected:NO];
}
@end
