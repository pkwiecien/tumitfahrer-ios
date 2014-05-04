//
//  YourRidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "YourRidesViewController.h"
#import "ActionManager.h"

@interface YourRidesViewController ()

@end

@implementation YourRidesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavbar];
    [self makeBackground];
}

-(void)makeBackground {
    UIImageView *imgBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradientBackground"]];
    imgBackgroundView.frame = self.view.bounds;
    [self.view addSubview:imgBackgroundView];
    [self.view sendSubviewToBack:imgBackgroundView];
}

-(void)setupNavbar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    double width = self.navigationController.navigationBar.frame.size.width;
    double height = self.navigationController.navigationBar.frame.size.height;
    
    UIImage *croppedImage = [ActionManager cropImage:[UIImage imageNamed:@"gradientBackground"] newRect:CGRectMake(0, 0, width, height)];
    [self.navigationController.navigationBar setBackgroundImage:croppedImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"YOUR RIDES";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


@end
