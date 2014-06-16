//
//  CampusRidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SettingsViewController.h"
#import "ActionManager.h"
#import "LoginViewController.h"
#import "NavigationBarUtilities.h"
#import "LogoView.h"
#import "MMDrawerBarButtonItem.h"
#import "PrivacyViewController.h"
#import "ReminderViewController.h"
#import "FeedbackViewController.h"
#import "CarsharingViewController.h"
#import "EAIntroView.h"
#import "ControllerUtilities.h"
#import "TeamViewController.h"

@interface SettingsViewController () <EAIntroDelegate>

@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) NSArray *readOptions;
@property (nonatomic, strong) NSArray *readIcons;
@property (nonatomic, strong) NSArray *actionOptions;
@property (nonatomic, strong) NSArray *actionIcons;
@property (nonatomic, strong) NSArray *contactOptions;
@property (nonatomic, strong) NSArray *contactIcons;
@property (nonatomic, strong) NSArray *tableValues;
@property (nonatomic, strong) NSArray *tableIcons;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.headers = [[NSArray alloc] initWithObjects:@"Feedback", @"General", @"About TUMitfahrer", nil];
        self.actionOptions = [[NSArray alloc] initWithObjects:@"Send Feedback", @"Report a problem", nil];
        self.actionIcons = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"FeedbackIconBlack"], [UIImage imageNamed:@"ProblemIconBlack"], nil];
        self.readOptions = [[NSArray alloc] initWithObjects:@"Reminder", @"Privacy", @"Licenses", @"Carsharing", nil];
        self.readIcons = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ReminderIconBlack"], [UIImage imageNamed:@"PrivacyIconBlack"], [UIImage imageNamed:@"LicenseIconBlack"], [UIImage imageNamed:@"CarIconBlack"], nil];
        self.contactOptions = [[NSArray alloc] initWithObjects:@"About TUMitfahrer", @"Team", @"Contact us", nil];
        self.contactIcons = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"InfoIconBlack"], [UIImage imageNamed:@"TeamIconBlack"], [UIImage imageNamed:@"EmailIconBlackSmall"], nil];
        self.tableValues = [[NSArray alloc] initWithObjects:self.actionOptions, self.readOptions, self.contactOptions, nil];
        self.tableIcons = [[NSArray alloc] initWithObjects:self.actionIcons, self.readIcons, self.contactIcons, nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.tableView.tableFooterView = footerView;
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupLeftMenuButton];
    [self setupNavigationBar];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor customDarkGray]];
    self.title = @"Settings";
    
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"LogoutIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonPressed:)];
    
    // set label for kif test
    [self.navigationItem setAccessibilityLabel:@"Back Setting Button"];
    [self.navigationItem setIsAccessibilityElement:YES];
    
    [self.navigationItem setRightBarButtonItem:refreshButtonItem];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    
    // set label for kif test
    [leftDrawerButton setAccessibilityLabel:@"Menu Button"];
    [leftDrawerButton setIsAccessibilityElement:YES];
    
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.tableValues objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.tableValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [[self.tableIcons objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        if (indexPath.row == 0) {
            feedbackVC.title = @"Send Feedback";
        } else if(indexPath.row == 1) {
            feedbackVC.title = @"Report Problem";
        } else if(indexPath.row == 2) {
            feedbackVC.title = @"Mail to TUMitfahrer";
        }
        [self.navigationController pushViewController:feedbackVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        ReminderViewController *reminderVC = [[ReminderViewController alloc] init];
        [self.navigationController pushViewController:reminderVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        PrivacyViewController *privacyVC = [[PrivacyViewController alloc] init];
        [self.navigationController pushViewController:privacyVC animated:YES];
    } else if(indexPath.section == 1 && indexPath.row == 2) {
        
        // TODO: add licenses
        PrivacyViewController *privacyVC = [[PrivacyViewController alloc] init];
        [self.navigationController pushViewController:privacyVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        CarsharingViewController *carsharingVC = [[CarsharingViewController alloc] init];
        carsharingVC.title = @"Carsharing";
        [self.navigationController pushViewController:carsharingVC animated:YES];
    } else if(indexPath.section == 2 && indexPath.row == 0) {
        [self showIntroButtonPressed];
    } else if(indexPath.section == 2 && indexPath.row == 1) {
        TeamViewController *teamVC = [[TeamViewController alloc] init];
        [self.navigationController pushViewController:teamVC animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        feedbackVC.title = @"Contact us";
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headers objectAtIndex:section];
}

- (IBAction)sendFeedbackButtonPressed:(id)sender {
}

- (void)showIntroButtonPressed {
    EAIntroView *intro = (EAIntroView *)[ControllerUtilities prepareIntroForView:self.view];
    intro.delegate = self;
    [intro showInView:self.view animateDuration:0.0];
}

- (IBAction)logoutButtonPressed:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"emailLoggedInUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


@end
