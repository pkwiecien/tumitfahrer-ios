//
//  RidesViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RidesViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "RidesCell.h"
#import "RideDetailHeaderView.h"
#import "Ride.h"
#import "RideDetailViewController.h"
#import "NavigationBarUtilities.h"

@interface RidesViewController ()

@end

@implementation RidesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[PanoramioUtilities sharedInstance] addObserver:self];
    [[RidesStore sharedStore] addObserver:self];
    
    UIColor *customGrayColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.view setBackgroundColor:customGrayColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self setupLeftMenuButton];
    [self.delegate willAppearViewWithIndex:self.index];
    [self.tableView reloadData];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor colorWithRed:0.227 green:0.227 blue:0.227 alpha:1]];
    self.title = @"Settings";
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[RidesStore sharedStore] allRidesByType:self.RideType] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RidesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RidesCell"];
    
    if(cell == nil){
        cell = [RidesCell ridesCell];
    }
    
    Ride *ride = [[[RidesStore sharedStore] allRidesByType:self.RideType] objectAtIndex:indexPath.row];
    if(ride.destinationImage == nil) {
        cell.rideImageView.image = [UIImage imageNamed:@"PlaceholderImage"];
    } else {
        cell.rideImageView.image = [UIImage imageWithData:ride.destinationImage];
    }
    cell.rideImageView.clipsToBounds = YES;
    cell.rideImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.directionsLabel.text = [ride.departurePlace stringByAppendingString:[NSString stringWithFormat:@" -> %@", ride.destination]];
    [cell.directionsLabel sizeToFit];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
    rideDetailVC.ride = [[[RidesStore sharedStore] allRidesByType:self.RideType] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:rideDetailVC animated:YES];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)didReceivePhotoForRide:(NSInteger)rideId {
    [self.tableView reloadData];
}

-(void)didReceivePhotoForCurrentLocation:(UIImage *)image
{
    [LocationController sharedInstance].currentLocationImage = image;
}

-(void)didRecieveRidesFromWebService:(NSArray *)rides
{
    for (Ride *ride in rides) {
        NSLog(@"Ride: %@", ride);
    }
}

-(void)loadNewElements {
    [[RidesStore sharedStore] fetchNextRides:^(BOOL fetched) {
        if (fetched) {
            for (Ride *ride in [[RidesStore sharedStore] allRides]) {
                NSLog(@"ride with id: %d", ride.rideId);
                //[self.collectionView reloadData];
            }
        }
    }];
}

@end
