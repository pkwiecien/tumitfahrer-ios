//
//  RidesPageViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RidesPageViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "LogoView.h"
#import "CurrentUser.h"
#import "CustomBarButton.h"
#import "RidesViewController.h"
#import "NavigationBarUtilities.h"

@interface RidesPageViewController () <RidesViewControllerDelegate>

@property NSArray *pageTitles;
@property NSArray *pageColors;

// activity about new: rides (who add new activity ride, ride request, campus ride), who requests a ride, ride search, rating {activities : { activity_rides : { }, campus_ride: {}, ride_requests: {}, rating{}, }

@end

@implementation RidesPageViewController

-(instancetype)initWithContentType:(ContentType)contentType {
    self = [super init];
    if (self) {
        self.pageTitles = [NSArray arrayWithObjects:@"All Campus Rides", @"Around you", @"Favourite destinations", nil];
        self.pageColors = [NSArray arrayWithObjects:[UIColor colorWithRed:0 green:0.443 blue:0.737 alpha:1], [UIColor colorWithRed:0.008 green:0.4 blue:0.62 alpha:1], [UIColor colorWithRed:0 green:0.294 blue:0.459 alpha:1], nil];
        self.RideType = contentType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    RidesViewController *initialViewController = [self viewControllerAtIndex:0];
    initialViewController.delegate = self;
    initialViewController.RideType = self.RideType;
    
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
    [NavigationBarUtilities setupNavbar:&navController withColor:[self.pageColors objectAtIndex:0]];
    
    self.logo = [[LogoView alloc] initWithFrame:CGRectMake(0, 0, 200, 41) title:[self.pageTitles objectAtIndex:0]];
    [self.navigationItem setTitleView:self.logo];
}

-(void)mapButtonPressed {
    
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(RidesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(RidesViewController *)viewController index];
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (RidesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    RidesViewController *ridesViewController = [[RidesViewController alloc] init];
    ridesViewController.index = index;
    ridesViewController.delegate = self;
    
    return ridesViewController;
}


#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)willAppearViewWithIndex:(NSInteger)index {
    self.logo.titleLabel.text = [self.pageTitles objectAtIndex:index];
    self.logo.pageControl.currentPage = index;
    [self.navigationController.navigationBar setBarTintColor:[self.pageColors objectAtIndex:index]];
}

@end
