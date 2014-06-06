//
//  YourRidesPageViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "YourRidesPageViewController.h"
#import "YourRidesViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "LogoView.h"
#import "CurrentUser.h"
#import "LoginViewController.h"
#import "CustomBarButton.h"
#import "NavigationBarUtilities.h"
#import "TimelineMapViewController.h"
#import "MenuViewController.h"
#import "ActionManager.h"

@interface YourRidesPageViewController () <YourRidesViewControllerDelegate>

@property NSArray *pageTitles;

// activity about new: rides (who add new activity ride, ride request, campus ride), who requests a ride, ride search, rating {activities : { activity_rides : { }, campus_ride: {}, ride_requests: {}, rating{}, }

@end

@implementation YourRidesPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageTitles = [NSArray arrayWithObjects:@"Organised rides", @"Upcoming rides", @"Past rides", nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    YourRidesViewController *initialViewController = [self viewControllerAtIndex:0];
    initialViewController.delegate = self;
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

-(void)viewWillAppear:(BOOL)animated {
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
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lightestBlue]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.logo = [[LogoView alloc] initWithFrame:CGRectMake(0, 0, 200, 41) title:[self.pageTitles objectAtIndex:0]];
    [self.navigationItem setTitleView:self.logo];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(YourRidesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(YourRidesViewController *)viewController index];
    
    index++;
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (YourRidesViewController *)viewControllerAtIndex:(NSUInteger)index {
    YourRidesViewController *yourRidesViewController = [[YourRidesViewController alloc] init];
    yourRidesViewController.index = index;
    yourRidesViewController.delegate = self;
    return yourRidesViewController;
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

# pragma mark - delegate methods

-(void)willAppearViewWithIndex:(NSInteger)index {
    self.logo.titleLabel.text = [self.pageTitles objectAtIndex:index];
    self.logo.pageControl.currentPage = index;
    [self.navigationController.navigationBar setBarTintColor:[UIColor lightestBlue]];
}

@end