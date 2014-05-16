//
//  TimlineMapViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TimelineMapViewController.h"
#import "NavigationBarUtilities.h"

@interface TimelineMapViewController ()

@end

@implementation TimelineMapViewController

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

}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor colorWithRed:0.059 green:0.216 blue:0.314 alpha:1]];
    self.title = @"Timeline Map";
}

@end
