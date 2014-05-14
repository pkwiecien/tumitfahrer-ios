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
#import "CampusRidesViewController.h"
#import "RideSearchResultsViewController.h"
#import "ActionManager.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "CurrentUser.h"
#import "SearchRideViewController.h"
#import "AddRideViewController.h"
#import "YourRidesViewController.h"
#import "AddRideRequestViewController.h"
#import "MMDrawerController.h"
#import "TimelinePageViewController.h"
#import "RidesPageViewController.h"

@interface MenuViewController ()

@property NSArray *timelineSection;
@property NSArray *timelineViewControllers;
@property NSArray *timelineIcons;
@property NSArray *browseRidesSection;
@property NSArray *browseRidesViewControllers;
@property NSArray *browseRidesIcons;
@property NSArray *addRidesSection;
@property NSArray *addRidesViewControllers;
@property NSArray *addRidesIcons;
@property NSArray *profileSection;
@property NSArray *profileViewControllers;
@property NSArray *profileIcons;

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
    TimelinePageViewController *timelinePageVC = [[TimelinePageViewController alloc] init];
    self.timelineViewControllers = [NSArray arrayWithObjects:timelinePageVC, nil];
    
    // section 0 - view controllers
    RidesPageViewController *campusRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeCampusRides];
    RidesPageViewController *activityRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeActivityRides];
//    BrowseRidesViewController *campusRidesVC = [[BrowseRidesViewController alloc] initWithContentType:ContentTypeCampusRides];
//    BrowseRidesViewController *activityRidesVC = [[BrowseRidesViewController alloc] initWithContentType:ContentTypeActivityRides];
    self.browseRidesViewControllers = [NSArray arrayWithObjects:campusRidesVC, activityRidesVC, nil];
    
    // section 1 - view controllers
    AddRideViewController *addRideVC = [[AddRideViewController alloc] init];
    addRideVC.RideDisplayType = ShowAsViewController;
    SearchRideViewController *searchRidesVC = [[SearchRideViewController alloc] init];
    searchRidesVC.SearchDisplayType = ShowAsViewController;
    self.addRidesViewControllers = [NSArray arrayWithObjects: addRideVC, searchRidesVC, nil];
    
    // section 2 - view controllers
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    YourRidesViewController *yourRidesVC = [[YourRidesViewController alloc] init];
    self.profileViewControllers = [NSArray arrayWithObjects:profileVC, yourRidesVC, nil];
    
    // add all sections to view controllers
    self.allViewControllers = [NSArray arrayWithObjects:self.timelineViewControllers, self.browseRidesViewControllers, self.addRidesViewControllers, self.profileViewControllers, nil];
}

-(void)initCellTitles {
    self.timelineSection = [NSArray arrayWithObjects:@"Timeline", nil];
    self.browseRidesSection = [NSArray arrayWithObjects:@"Campus Rides", @"Activity Rides", nil];
    self.addRidesSection = [NSArray arrayWithObjects:@"New Ride/Request", @"Search Rides", nil];
    self.profileSection = [NSArray arrayWithObjects:@"Profile", @"All Your Rides", nil];
    self.allMenuItems = [NSArray arrayWithObjects:self.timelineSection, self.browseRidesSection, self.addRidesSection, self.profileSection, nil];
}

-(void)initCellIcons {
    self.timelineIcons = [NSArray arrayWithObjects:@"ProfileIcon", nil];
    self.browseRidesIcons = [NSArray arrayWithObjects:@"CampusIcon", @"ActivityIcon", nil];
    self.addRidesIcons = [NSArray arrayWithObjects:@"AddBlackIcon", @"QuestionIcon", nil];
    self.profileIcons = [NSArray arrayWithObjects:@"ProfileIcon", @"ScheduleIcon", nil];
    self.allIcons = [NSArray arrayWithObjects:self.timelineIcons, self.browseRidesIcons, self.addRidesIcons, self.profileIcons, nil];
}

-(void)initTableHeaderLabels {
    self.headersLabels = [NSArray arrayWithObjects:@"", @"BROWSE OFFERS", @"ACTIONS", @"YOUR ACCOUNT", nil];
}

#pragma mark - view controller configuration

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackgroundToTableView];
    [self makeHeaderForTableView];
}

-(void)addBackgroundToTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:0.227 green:0.227 blue:0.227 alpha:1];
}

-(void)makeHeaderForTableView {
    UIView *menuTopHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"MenuTopHeaderView" owner:self options:nil] firstObject];
    UILabel *initialsLabel = (UILabel *)[menuTopHeaderView viewWithTag:2];
    UILabel *usernameLabel = (UILabel *)[menuTopHeaderView viewWithTag:3];
    UIButton *settingsButton = (UIButton *)[menuTopHeaderView viewWithTag:4];
    
    usernameLabel.text = [CurrentUser sharedInstance].user.firstName;
    initialsLabel.text = [[[CurrentUser sharedInstance].user.firstName substringToIndex:1] stringByAppendingString:[[CurrentUser sharedInstance].user.lastName substringToIndex:1]];
    [settingsButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"SettingsIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = menuTopHeaderView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // set initally first row selected
    //NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
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
    if (section == 0) {
        return 0;
    }
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
    if(viewController) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self.sideBarController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    }
}


-(void)settingsButtonPressed {
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self.sideBarController setCenterViewController:navController withCloseAnimation:YES completion:nil];
}

@end
