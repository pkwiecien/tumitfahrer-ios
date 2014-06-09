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
#import "NavigationBarUtilities.h"
#import "CurrentUser.h"
#import "Ride.h"
#import "RideDetailViewController.h"
#import "RidesStore.h"
#import "CustomUILabel.h"
#import "MMDrawerBarButtonItem.h"

@interface YourRidesViewController ()

@property (nonatomic, retain) UILabel *zeroRidesLabel;
@property CGFloat previousScrollViewYOffset;
@property UIRefreshControl *refreshControl;

@end

@implementation YourRidesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareZeroRidesLabel];
    [self.view setBackgroundColor:[UIColor customLightGray]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.delegate willAppearViewWithIndex:self.index];

    [self setupNavigationBar];
    [self setupLeftMenuButton];
    [[CurrentUser sharedInstance] refreshUserRides];
    [self.tableView reloadData];
    [self checkIfAnyRides];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lightestBlue]];
}

-(void)prepareZeroRidesLabel {
    self.zeroRidesLabel = [[CustomUILabel alloc] initInMiddle:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) text:@"You don't have any rides" viewWithNavigationBar:self.navigationController.navigationBar];
}

-(void)checkIfAnyRides {
    if ([[[CurrentUser sharedInstance] userRides] count] == 0) {
        [self.view addSubview:self.zeroRidesLabel];
    } else {
        [self.zeroRidesLabel removeFromSuperview];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[CurrentUser sharedInstance] userRides] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YourRidesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YourRidesCell"];
    
    if(cell == nil){
        cell = [YourRidesCell yourRidesCell];
    }

    Ride *ride = [[[CurrentUser sharedInstance] userRides] objectAtIndex:indexPath.section];
    cell.departurePlaceLabel.text = ride.departurePlace;
    cell.destinationLabel.text = ride.destination;
    cell.departureTimeLabel.text = [ActionManager stringFromDate:ride.departureTime];
    
    if(ride.destinationImage == nil) {
        cell.rideImage.image = [UIImage imageNamed:@"Placeholder"];
    } else {
        cell.rideImage.image = [UIImage imageWithData:ride.destinationImage];;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
    rideDetailVC.ride = [[[CurrentUser sharedInstance] userRides] objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:rideDetailVC animated:YES];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
