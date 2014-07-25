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
#import "ActivityStore.h"

@interface TimelinePageViewController () <TimelineViewControllerDelegate>

@property NSArray *pageTitles;
@property NSInteger currentIndex;

@end

@implementation TimelinePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageTitles = [NSArray arrayWithObjects:@"Timeline", @"Around you", @"Last minute", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.view.backgroundColor = [UIColor customLightGray];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];

    self.currentIndex = 0;
    TimelineViewController *initialViewController = [self viewControllerAtIndex:self.currentIndex];
    initialViewController.delegate = self;
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    // check if current user exists
    if([CurrentUser sharedInstance].user == nil || [CurrentUser sharedInstance].user.apiKey == nil) {
        [self showLoginScreenWithAnimation:NO];
    }

    [self setupLeftMenuButton];
    [self setupNavigationBar];
}

-(void)setupLeftMenuButton {
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
    UIButton *btnMap = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnMapImage = [UIImage imageNamed:@"MapIcon"];
    [btnMap setBackgroundImage:btnMapImage forState:UIControlStateNormal];
    [btnMap addTarget:self action:@selector(mapButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    btnMap.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *btnMapItem = [[UIBarButtonItem alloc] initWithCustomView:btnMap] ;
    self.navigationItem.rightBarButtonItem = btnMapItem;
}

-(void)mapButtonPressed {
    TimelineMapViewController *mapVC = [[TimelineMapViewController alloc] init];
    mapVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    mapVC.contentType = self.currentIndex;
    [self.navigationController pushViewController:mapVC animated:YES];
}

-(void)showLoginScreenWithAnimation:(BOOL)animated {
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
    self.currentIndex = index;
    [self.navigationController.navigationBar setBarTintColor:[UIColor darkestBlue]];
}

@end
