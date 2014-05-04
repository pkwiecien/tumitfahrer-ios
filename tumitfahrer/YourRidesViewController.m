//
//  YourRidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/4/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "YourRidesViewController.h"
#import "ActionManager.h"
#import "YourRidesCell.h"

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YourRidesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YourRidesCell"];
    
    if(cell == nil){
        cell = [YourRidesCell yourRidesCell];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected cell %d %d", indexPath.section, indexPath.row);
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}



@end
