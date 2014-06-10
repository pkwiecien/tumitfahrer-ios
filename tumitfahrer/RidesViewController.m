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
#import "HeaderImageView.h"
#import "Ride.h"
#import "RideDetailViewController.h"
#import "NavigationBarUtilities.h"
#import "ActionManager.h"
#import "CurrentUser.h"

@interface RidesViewController ()

@property CGFloat previousScrollViewYOffset;
@property UIRefreshControl *refreshControl;
@property NSCache *imageCache;
@property NSArray *cellsArray;
@property UIImage *passengerIcon;
@property UIImage *driverIcon;

@end

@implementation RidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PanoramioUtilities sharedInstance] addObserver:self];
    [[RidesStore sharedStore] addObserver:self];
    
    [self.view setBackgroundColor:[UIColor customLightGray]];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.tableView.tableHeaderView = headerView;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.tableView.tableFooterView = footerView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing rides"];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.imageCache = [[NSCache alloc] init];
    
    self.passengerIcon = [ActionManager colorImage:[UIImage imageNamed:@"PassengerIcon"] withColor:[UIColor customLightGray]];
    self.driverIcon =  [ActionManager colorImage:[UIImage imageNamed:@"DriverIcon"] withColor:[UIColor customLightGray]];
}

-(void)handleRefresh {
    [[RidesStore sharedStore] fetchNewRides:^(BOOL fetched) {
        if(fetched) {
            [self addToImageCache];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

-(void)addToImageCache {
    int counter = 0;
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];

    for (Ride *ride in [self ridesForCurrentIndex]) {
        UIImage *image = [UIImage imageWithData:ride.destinationImage];
        if (image == nil) {
            image = placeholderImage;
        }
        [_imageCache setObject:image forKey:[NSNumber numberWithInteger:counter]];
        counter++;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self addToImageCache];
    [self.delegate willAppearViewWithIndex:self.index];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self ridesForCurrentIndex] count];
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
    
    Ride *ride = [[self ridesForCurrentIndex] objectAtIndex:indexPath.section];
    UIImage *image = [_imageCache objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    if (image == nil) {
        if(ride.destinationImage == nil) {
            image = [UIImage imageNamed:@"Placeholder"];
        } else {
            image = [UIImage imageWithData:ride.destinationImage];
        }
        [_imageCache setObject:image forKey:[NSNumber numberWithInteger:indexPath.section]];
    }
    cell.rideImageView.image = image;
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
    RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
    rideDetailVC.ride = [[self ridesForCurrentIndex] objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:rideDetailVC animated:YES];
}

#pragma mark - scroll view methods
// http://stackoverflow.com/questions/19819165/imitate-ios-7-facebook-hide-show-expanding-contracting-navigation-bar

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat size = frame.size.height - 21;
    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frame.origin.y = 20;
        self.tableView.frame= CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frame.origin.y = -size;
    } else {
        frame.origin.y = MIN(20, MAX(-size, frame.origin.y - (frame.size.height * (scrollDiff / scrollHeight))));
        // frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
    }
    
    [self.navigationController.navigationBar setFrame:frame];
    [self updateBarButtonItems:(1 - framePercentageHidden)];
    self.previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling
{
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y < 20) {
        [self animateNavBarTo:-(frame.size.height - 21)];
    }
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.navigationController.navigationBar setFrame:frame];
        [self updateBarButtonItems:alpha];
    }];
}

#pragma mark - Observers Handlers

-(void)didReceivePhotoForRide:(NSNumber *)rideId {
    [self.tableView reloadData];
}

-(void)didReceivePhotoForCurrentLocation:(UIImage *)image {
    [LocationController sharedInstance].currentLocationImage = image;
}

-(void)didRecieveRidesFromWebService:(NSArray *)rides
{
    for (Ride *ride in rides) {
        NSLog(@"Ride: %@", ride);
    }
}

-(void)loadNewElements {
    [[RidesStore sharedStore] fetchNewRides:^(BOOL fetched) {
        if (fetched) {
            for (Ride *ride in [[RidesStore sharedStore] allRides]) {
                NSLog(@"ride with id: %@", ride.rideId);
            }
        }
    }];
}

-(NSArray *)ridesForCurrentIndex {
    switch (self.index) {
        case 0:
            return [[RidesStore sharedStore] allRidesByType:self.RideType];
        case 1:
            return [[RidesStore sharedStore] ridesNearbyByType:self.RideType];
        case 2:
            return [[RidesStore sharedStore] favoriteRidesByType:self.RideType];
        default:
            return 0;
    }
}

-(void)dealloc {
    [self.imageCache removeAllObjects];
    self.delegate = nil;
}

@end
