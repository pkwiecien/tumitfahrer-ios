//
//  SearchResultViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "RidesCell.h"
#import "HeaderImageView.h"
#import "Ride.h"
#import "NavigationBarUtilities.h"
#import "ActionManager.h"
#import "RidesStore.h"
#import "CurrentUser.h"
#import "RidesStore.h"
#import "CustomUILabel.h"
#import "ControllerUtilities.h"
#import "PanoramioUtilities.h"

@interface SearchResultViewController () <RideStoreDelegate, PanoramioUtilitiesDelegate>

@property (nonatomic, retain) UILabel *zeroRidesLabel;
@property NSArray *cellsArray;
@property UIImage *passengerIcon;
@property UIImage *driverIcon;
@property NSMutableArray *searchResults;
@property NSInteger page;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[PanoramioUtilities sharedInstance] addObserver:self];
    [[RidesStore sharedStore] addObserver:self];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    self.passengerIcon = [ActionManager colorImage:[UIImage imageNamed:@"PassengerIcon"] withColor:[UIColor customLightGray]];
    self.driverIcon =  [ActionManager colorImage:[UIImage imageNamed:@"DriverIcon"] withColor:[UIColor customLightGray]];
    self.searchResults = [[NSMutableArray alloc] init];
    self.page = 0;
    self.title = @"Results";
    self.navigationItem.backBarButtonItem.title = @"Search";
    [self prepareZeroRidesLabel];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if (self.searchResults == nil || self.searchResults.count == 0) {
        [self fetchResults];
    } else {
        for (Ride *ride in self.searchResults) {
            if (ride == nil) {
                [self.searchResults removeObject:ride];
            }
        }
    }
    [self checkIfAllRidesExist];
    [self setupNavigationBar];
    [self reloadTable];
}

-(void)reloadTable {
    [self.tableView reloadData];
    [self checkIfZeroRides];
}

-(void)checkIfAllRidesExist {
    NSArray *results = [self.searchResults copy];
    for (Ride *ride in results) {
        if ([[RidesStore sharedStore] fetchRideFromCoreDataWithId:ride.rideId] == nil) {
            [self.searchResults removeObject:ride];
        }
    }
}

-(void)checkIfZeroRides {
    if (self.searchResults.count > 0) {
        self.zeroRidesLabel.hidden = YES;
        [self.zeroRidesLabel removeFromSuperview];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    } else {
        [self.view addSubview:self.zeroRidesLabel];
        self.zeroRidesLabel.hidden = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

-(void)prepareZeroRidesLabel {
    self.zeroRidesLabel = [[CustomUILabel alloc] initInMiddle:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) text:@"No rides found :(" viewWithNavigationBar:self.navigationController.navigationBar];
    self.zeroRidesLabel.textColor = [UIColor blackColor];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor darkestBlue]];
}

-(void)fetchResults {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"apiKey" value:[[CurrentUser sharedInstance] user].apiKey];
    
    [objectManager postObject:nil path:API_SEARCH parameters:self.queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSArray* rides = [mappingResult array];
        [self addSearchResults:rides];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [ActionManager showAlertViewWithTitle:@"Error" description:@"Could not retrieve any search results"];
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(void)addSearchResults:(NSArray *)newRides {
    
    for (Ride *ride in newRides) {
        if ([self.searchResults containsObject:ride]) {
            continue;
        }
        
        [self.searchResults addObject:ride];
        if (ride.destinationImage == nil || ride.departureLatitude == 0 || ride.destinationLatitude == 0) {
            [RidesStore initRide:ride index:(self.searchResults.count-1) block:^(NSInteger index) {
                [self reloadTable];
            }];
        }
    }
    
    [self reloadTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.searchResults count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RidesCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RidesCell"];
    
    if (cell == nil) {
        cell = [RidesCell ridesCell];
    }
    
    Ride *ride = [self.searchResults objectAtIndex:indexPath.section];
    
    if(ride.destinationImage == nil) {
        cell.rideImageView.image = [UIImage imageNamed:@"Placeholder"];
        cell.gradientImageView.hidden = YES;
    } else {
        cell.rideImageView.image = [UIImage imageWithData:ride.destinationImage];
    }
    cell.rideImageView.clipsToBounds = YES;
    cell.rideImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.timeLabel.text = [ActionManager timeStringFromDate:[ride departureTime]];
    cell.dateLabel.text = [ActionManager dateStringFromDate:[ride departureTime]];
    if([ride.isRideRequest boolValue]) {
        cell.seatsView.backgroundColor = [UIColor orangeColor];
        cell.roleImageView.image = self.passengerIcon;
    } else {
        cell.seatsView.backgroundColor = [UIColor orangeColor];
        cell.roleImageView.image = self.driverIcon;
    }
    if ([ride.isRideRequest boolValue]) {
        cell.seatsLabel.text = @"offer a ride";
    } else if ([ride.freeSeats intValue] == 1) {
        cell.seatsLabel.text = @"1 seat left";
    } else {
        cell.seatsLabel.text = [NSString stringWithFormat:@"%@ seats left", ride.freeSeats];
    }
    
    cell.directionsLabel.text = [ride.departurePlace componentsSeparatedByString:@", "][0];
    cell.destinationLabel.text = [ride.destination componentsSeparatedByString:@", "][0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [ControllerUtilities viewControllerForRide:[self.searchResults objectAtIndex:indexPath.section]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Observers Handlers

-(void)didReceivePhotoForRide:(NSNumber *)rideId {
    [self reloadTable];
}

-(void)didReceivePhotoForCurrentLocation:(UIImage *)image {
    [LocationController sharedInstance].currentLocationImage = image;
}

-(void)dealloc {
    
    [[PanoramioUtilities sharedInstance] removeObserver:self];
    [[RidesStore sharedStore] removeObserver:self];
}

@end
