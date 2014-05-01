//
//  MenuViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 3/29/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "SettingsViewController.h"
#import "RideRequestsViewController.h"
#import "BrowseRidesViewController.h"
#import <SlideNavigationController.h>
#import "CampusRidesViewController.h"
#import "RideSearchResultsViewController.h"
#import "ActionManager.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "CurrentUser.h"
#import "SearchRideViewController.h"
#import "AddRideViewController.h"
#import "AddRideRequestViewController.h"

@interface MenuViewController ()

@property NSArray *browseRidesSection;
@property NSArray *browseRidesViewControllers;
@property NSArray *browseRidesIcons;
@property NSArray *addRidesSection;
@property NSArray *addRidesViewControllers;
@property NSArray *addRidesIcons;
@property NSArray *profileSection;
@property NSArray *profileViewControllers;
@property NSArray *profileIcons;
@property NSArray *searchRidesViewControllers;
@property NSArray *searchRidesIcons;
@property NSArray *searchRidesSection;

@property NSArray *allMenuItems;
@property NSArray *allViewControllers;
@property NSArray *allIcons;

@property NSArray *headersLabels;

@end

@implementation MenuViewController

#pragma mark - initializers
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initViewControllers];
        [self initCellTitles];
        [self initCellIcons];
        [self initTableHeaderLabels];
    }
    return self;
}

-(void)initViewControllers {
    // section 0 - view controllers
    BrowseRidesViewController *campusRidesVC = [[BrowseRidesViewController alloc] initWithContentType:ContentTypeCampusRides];
    BrowseRidesViewController *activityRidesVC = [[BrowseRidesViewController alloc] initWithContentType:ContentTypeActivityRides];
    BrowseRidesViewController *existingRequestsVC = [[BrowseRidesViewController alloc] initWithContentType:ContentTypeExistingRequests];
    self.browseRidesViewControllers = [NSArray arrayWithObjects:campusRidesVC, activityRidesVC, existingRequestsVC, nil];
    
    // section 1 - view controllers
    AddRideViewController *addRideVC = [[AddRideViewController alloc] init];
    addRideVC.DisplayType = ShowAsViewController;
    AddRideRequestViewController *addRideRequestVC = [[AddRideRequestViewController alloc] init];
    self.addRidesViewControllers = [NSArray arrayWithObjects: addRideVC, addRideRequestVC, nil];
    
    // section 1 - search view controllers
    SearchRideViewController *searchRidesVC = [[SearchRideViewController alloc] init];
    RideSearchResultsViewController *searchResultsVC = [[RideSearchResultsViewController alloc] init];
    self.searchRidesViewControllers = [NSArray arrayWithObjects:searchRidesVC, searchResultsVC, nil];
    
    // section 3 - view controllers
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    self.profileViewControllers = [NSArray arrayWithObjects:profileVC, [NSNull null], [NSNull null], settingsVC, nil];
    
    // add all sections to view controllers
    self.allViewControllers = [NSArray arrayWithObjects:self.browseRidesViewControllers, self.addRidesViewControllers, self.searchRidesViewControllers, self.profileViewControllers, nil];
}

-(void)initCellTitles {
    self.browseRidesSection = [NSArray arrayWithObjects:@"Campus Rides", @"Activities", @"Existing Requests", nil];
    self.addRidesSection = [NSArray arrayWithObjects:@"New Ride", @"Ride Request", nil];
    self.searchRidesSection = [NSArray arrayWithObjects:@"Search Rides", @"Results of Search", nil];
    self.profileSection = [NSArray arrayWithObjects:@"Profile", @"Schedule", @"Messages", @"Settings", nil];
    self.allMenuItems = [NSArray arrayWithObjects:self.browseRidesSection, self.addRidesSection, self.searchRidesSection, self.profileSection, nil];
}

-(void)initCellIcons {
    self.browseRidesIcons = [NSArray arrayWithObjects:@"CampusIcon", @"ActivityIcon", @"ListIcon", nil];
    self.addRidesIcons = [NSArray arrayWithObjects:@"AddBlackIcon", @"QuestionIcon", nil];
    self.searchRidesIcons = [NSArray arrayWithObjects:@"RequestIcon", @"ResultsIcon", nil];
    self.profileIcons = [NSArray arrayWithObjects:@"ProfileIcon", @"ScheduleIcon", @"MessageIcon",  @"SettingsIcon", nil];
    self.allIcons = [NSArray arrayWithObjects:self.browseRidesIcons, self.addRidesIcons, self.searchRidesIcons, self.profileIcons, nil];
}

-(void)initTableHeaderLabels {
    self.headersLabels = [NSArray arrayWithObjects:@"BROWSE OFFERS", @"ADD", @"SEARCH", @"YOUR ACCOUNT", nil];
}

#pragma mark - view controller configuration

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackgroundToTableView];
    [self makeHeaderForTableView];
}

-(void)addBackgroundToTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradientBackground"]];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

-(void)makeHeaderForTableView {
    UIView *menuTopHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"MenuTopHeaderView" owner:self options:nil] firstObject];
    UILabel *initialsLabel = (UILabel *)[menuTopHeaderView viewWithTag:2];
    UILabel *usernameLabel = (UILabel *)[menuTopHeaderView viewWithTag:3];
    
    usernameLabel.text = [CurrentUser sharedInstance].user.firstName;
    initialsLabel.text = [[[CurrentUser sharedInstance].user.firstName substringToIndex:1] stringByAppendingString:[[CurrentUser sharedInstance].user.lastName substringToIndex:1]];
    self.tableView.tableHeaderView = menuTopHeaderView;
}

-(void)viewWillAppear:(BOOL)animated {
    
    // set initally first row selected
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark - table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allMenuItems count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.allMenuItems objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuTableViewCell";
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    
    cell.menuLabel.text = [[self.allMenuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    // add icon to the cell
    UIColor *almostWhiteColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:0.8];
    UIImage *newImg = [ActionManager colorImage:[UIImage imageNamed:[[self.allIcons objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]] withColor:almostWhiteColor];
    cell.iconMenuImageView.image = newImg;
    // set background of cell to transparent
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    // configure background of selected cell
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:70 green:30 blue:180 alpha:0.3];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

// avoid sticky header in the table
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headersLabels objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    [headerView setBackgroundColor:[UIColor clearColor]];

    UILabel *label= [[UILabel alloc]initWithFrame:CGRectMake(15,20,self.view.frame.size.width,20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [self.headersLabels objectAtIndex:section];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];//font size and style
    [label setTextColor:[UIColor whiteColor]];
    
    [headerView addSubview:label];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = [[self.allViewControllers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(viewController)
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController withCompletion:nil];
}


@end
