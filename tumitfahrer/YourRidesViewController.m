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
#import "WebserviceRequest.h"

@interface YourRidesViewController ()

@property (nonatomic, retain) UILabel *zeroRidesLabel;
@property CGFloat previousScrollViewYOffset;
@property (nonatomic, strong) NSArray *pastRides;
@property UIImage *passengerIcon;
@property UIImage *driverIcon;

@end

@implementation YourRidesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareZeroRidesLabel];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.tableView.tableFooterView = footerView;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    CGRect frame = CGRectMake (120.0, 185.0, 80, 80);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    self.activityIndicatorView.color = [UIColor redColor];
    [self.view addSubview:self.activityIndicatorView];
    [[RidesStore sharedStore] fetchPastRidesFromCoreData];
    self.passengerIcon = [UIImage imageNamed:@"PassengerIconBlack"];
    self.driverIcon = [UIImage imageNamed:@"DriverIconBlack"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.delegate willAppearViewWithIndex:self.index];
    
    [self setupNavigationBar];
    [self setupLeftMenuButton];
    [self checkIfAnyRides];
    [self.tableView reloadData];
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
    self.zeroRidesLabel.textColor = [UIColor blackColor];
}

-(void)checkIfAnyRides {
    if ([[self ridesForCurrentIndex] count] == 0) {
        [self.view addSubview:self.zeroRidesLabel];
    } else {
        [self.zeroRidesLabel removeFromSuperview];
    }
}

-(NSArray *)ridesForCurrentIndex {
    NSDate *now = [ActionManager currentDate];
    if (self.index == 0) {
        NSMutableArray *organisedRides = [[NSMutableArray alloc] init];
        for (Ride *ride in [CurrentUser sharedInstance].user.ridesAsOwner) {
            if ([ride.departureTime compare:now] == NSOrderedDescending) {
                [organisedRides addObject:ride];
            }
        }
        return organisedRides;
    } else if(self.index == 1) {
        NSMutableArray *rides = [[NSMutableArray alloc] init];
        for (Ride *ride in [CurrentUser sharedInstance].user.ridesAsPassenger) {
            if ([ride.departureTime compare:now] == NSOrderedDescending) {
                [rides addObject:ride];
            }
        }
        for (Ride *ride in [CurrentUser sharedInstance].user.ridesAsOwner) {
            if (![ride.isRideRequest boolValue] && [ride.departureTime compare:now] == NSOrderedDescending) {
                [rides addObject:ride];
            }
        }
        return rides;
    } else  if(self.index == 2) {
        if ([[RidesStore sharedStore] pastRides].count == 0) {
            [self startActivityIndicator];
            
            [WebserviceRequest getPastRidesForCurrentUserWithBlock:^(NSArray * fetchedRides) {
                [self initPastRidesWithRides:fetchedRides];
                [self stopActivityIndicator];
                [self.zeroRidesLabel removeFromSuperview];
            }];
        } else {
            return [[RidesStore sharedStore] pastRides];
        }
    }
    return nil;
}

-(void)initPastRidesWithRides:(NSArray *)fetchedRides {
    self.pastRides = [NSArray arrayWithArray:fetchedRides];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self ridesForCurrentIndex] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0f;
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
    
    Ride *ride = [[self ridesForCurrentIndex] objectAtIndex:indexPath.row];
    cell.departurePlaceLabel.text = ride.departurePlace;
    cell.destinationLabel.text = ride.destination;
    cell.departureTimeLabel.text = [ActionManager stringFromDate:ride.departureTime];
    if ([ride.isRideRequest boolValue]) {
        cell.driverImageView.image = self.passengerIcon;
        cell.driverLabel.text = @"Ride request";
    } else {
        cell.driverImageView.image = self.driverIcon;
        cell.driverLabel.text = @"You are a driver";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
    rideDetailVC.ride = [[self ridesForCurrentIndex] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:rideDetailVC animated:YES];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)startActivityIndicator {
    [self.activityIndicatorView startAnimating];
}

- (void)stopActivityIndicator {
    [self.activityIndicatorView stopAnimating];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
