 //
//  ParentPageViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TimelinePageViewController.h"
#import "TimelineViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "LogoView.h"
#import "CurrentUser.h"
#import "LoginViewController.h"
#import "CustomBarButton.h"
#import "NavigationBarUtilities.h"
#import "TimelineMapViewController.h"
#import "MenuViewController.h"
#import "ActionManager.h"

@interface TimelinePageViewController () <TimelineViewControllerDelegate>

@property NSArray *pageTitles;

// activity about new: rides (who add new activity ride, ride request, campus ride), who requests a ride, ride search, rating {activities : { activity_rides : { }, campus_ride: {}, ride_requests: {}, rating{}, }

@end

@implementation TimelinePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageTitles = [NSArray arrayWithObjects:@"Timeline", @"Around you", @"Your activity", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    TimelineViewController *initialViewController = [self viewControllerAtIndex:0];
    initialViewController.delegate = self;
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    // get current user
    NSString *emailLoggedInUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"emailLoggedInUser"];
    
    if (emailLoggedInUser != nil) {
        [CurrentUser fetchUserFromCoreDataWithEmail:emailLoggedInUser];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    // check if current user exists
    if([CurrentUser sharedInstance].user == nil) {
        [self showLoginScreen:NO];
    }
    
    [self setupLeftMenuButton];
    [self setupNavigationBar];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor darkestBlue]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.navigationController.navigationBar.translucent = NO;
    
    self.logo = [[LogoView alloc] initWithFrame:CGRectMake(0, 0, 200, 41) title:[self.pageTitles objectAtIndex:0]];
    [self.navigationItem setTitleView:self.logo];
    
    // right button of the navigation bar
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [ActionManager colorImage:[UIImage imageNamed:@"MapIcon"] withColor:[UIColor customLightGray]];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(mapButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.rightBarButtonItem = backButton;
}

-(void)mapButtonPressed {
    TimelineMapViewController *mapVC = [[TimelineMapViewController alloc] init];
    mapVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:mapVC animated:YES];
}

-(void)showLoginScreen:(BOOL)animated
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:animated completion:nil];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(TimelineViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(TimelineViewController *)viewController index];
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (TimelineViewController *)viewControllerAtIndex:(NSUInteger)index {
    TimelineViewController *timelineViewController = [[TimelineViewController alloc] init];
    timelineViewController.index = index;
    timelineViewController.delegate = self;
    return timelineViewController;
}


#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    
    MenuViewController *menu = (MenuViewController *)self.sideBarController.leftDrawerViewController;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [menu.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

# pragma mark - delegate methods

-(void)willAppearViewWithIndex:(NSInteger)index {
    self.logo.titleLabel.text = [self.pageTitles objectAtIndex:index];
    self.logo.pageControl.currentPage = index;
    [self.navigationController.navigationBar setBarTintColor:[UIColor darkestBlue]];
}

@end
