//
//  AnotherActivitiesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AnotherActivitiesViewController.h"
#import "ActionManager.h"

@interface AnotherActivitiesViewController ()

@end

@implementation AnotherActivitiesViewController

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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupNavbar];
}

-(void)setupNavbar
{
    UIColor *navBarColor = [UIColor colorWithRed:0 green:0.361 blue:0.588 alpha:1]; /*#0e3750*/
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:navBarColor];
    
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AddSmallIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showUnimplementedAlertView)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.tabBar.delegate = self;
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    self.title = item.title;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

-(void)showUnimplementedAlertView
{
    [[ActionManager sharedManager] showAlertViewWithTitle:@"Add a ride"];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.title = item.title;
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (IBAction)addIconPressed:(id)sender {
       [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

@end
