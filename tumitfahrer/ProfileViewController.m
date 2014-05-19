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
#import "MMDrawerBarButtonItem.h"
#import "CustomBarButton.h"
#import "HeaderContentView.h"


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
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.profileImageContentView = [[HeaderContentView alloc] initWithFrame:self.view.bounds];
    self.profileImageContentView.tableViewDataSource = self;
    self.profileImageContentView.tableViewDelegate = self;
    
    self.profileImageContentView.parallaxScrollFactor = 0.3; // little slower than normal.
    
    [self.view addSubview:self.profileImageContentView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self setupLeftMenuButton];
    self.profileImageContentView.selectedImageData = UIImagePNGRepresentation([UIImage imageNamed:@"Face"]);
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor colorWithRed:0.325 green:0.655 blue:0.835 alpha:1] ];
    
    // right button of the navigation bar
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(displayEditProfilePage)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.title = @"PROFILE";
}

-(void)displayEditProfilePage {
    
    EditProfileViewController *editProfileVC = [[EditProfileViewController alloc] init];
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:editProfileVC];
    [self.navigationController presentViewController:navBar animated:YES completion:nil];
}


#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
    }
    
    cell.textLabel.text = @"Default cell";
    
    return cell;
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
