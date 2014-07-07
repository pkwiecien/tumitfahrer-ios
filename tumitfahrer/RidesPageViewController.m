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
#import "AddRideViewController.h"
#import "SearchRideViewController.h"
#import "RidesStore.h"
#import "Ride.h"
#import "MenuViewController.h"

@interface RidesPageViewController () <RidesViewControllerDelegate, UIGestureRecognizerDelegate>

@property NSArray *pageTitles;
@property UIColor *pageColor;

@end

@implementation RidesPageViewController {
    UIScreenEdgePanGestureRecognizer *_swipeInLeftGestureRecognizer;
}

-(instancetype)initWithContentType:(ContentType)contentType {
    self = [super init];
    if (self) {
        NSArray *campusTitles = [NSArray arrayWithObjects:@"All Campus", @"Around you", @"Get a car", nil];
        NSArray *activityTitles = [NSArray arrayWithObjects:@"All Activity", @"Around you", @"Get a car", nil];
        self.pageTitles = [NSArray arrayWithObjects:campusTitles, activityTitles, nil];
        self.pageColor = [UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1];
        self.RideType = contentType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    RidesViewController *initialViewController = [self viewControllerAtIndex:0];

    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    self.view.backgroundColor = [UIColor customLightGray];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // You can customize the way in which gestures can work
    // Enabling multiple gestures will allow all of them to work together, otherwise only the topmost view's gestures will work (i.e. PanGesture view on bottom)
    return YES;
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (self.logo.pageControl.currentPage == 0) {
        NSLog(@"left: being in first ine");
    } else if(self.logo.pageControl.currentPage == 1) {
        NSLog(@"left: being in second ine");
    } else {
        NSLog(@"SHOULD BE HERE!!");
        
        RidesViewController *initialViewController = [self viewControllerAtIndex:1];
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}


-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self setupLeftMenuButton];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonPressed)];
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnAdd, btnSearch, nil]];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:self.pageColor];
    self.navigationController.navigationBar.translucent = YES;
    
    self.logo = [[LogoView alloc] initWithFrame:CGRectMake(0, 0, 200, 41) title:[[self.pageTitles objectAtIndex:self.RideType] objectAtIndex:0]];
    [self.navigationItem setTitleView:self.logo];
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
    ridesViewController.RideType = self.RideType;
    return ridesViewController;
}


#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    MenuViewController *menu = (MenuViewController *)self.sideBarController.leftDrawerViewController;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:self.RideType inSection:1];
    [menu.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)searchButtonPressed {
    SearchRideViewController *searchRideVC = [[SearchRideViewController alloc] init];
    searchRideVC.SearchDisplayType = ShowAsModal;
    [self.navigationController pushViewControllerWithFade:searchRideVC];
}

-(void)addButtonPressed {
    AddRideViewController *addRideVC = [[AddRideViewController alloc] init];
    addRideVC.RideType = self.RideType;
    addRideVC.TableType = Driver;
    addRideVC.RideDisplayType = ShowAsModal;
    [self.navigationController pushViewControllerWithFade:addRideVC];
}

-(void)willAppearViewWithIndex:(NSInteger)index {
    self.logo.titleLabel.text = [[self.pageTitles objectAtIndex:self.RideType] objectAtIndex:index];
    self.logo.pageControl.currentPage = index;
    [self.navigationController.navigationBar setBarTintColor:self.pageColor];
}

@end
