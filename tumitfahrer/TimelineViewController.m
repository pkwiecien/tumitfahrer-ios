//
//  TimelineViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/10/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TimelineViewController.h"
#import "TimelineCell.h"
#import "TimelinePageViewController.h"
#import "LogoView.h"
#import "ActivityStore.h"
#import "Request.h"
#import "Ride.h"
#import "Rating.h"
#import "ActionManager.h"
#import "RidesStore.h"
#import "RideSearch.h"
#import "User.h"
#import "CurrentUser.h"
#import "Ride.h"
#import "OfferViewController.h"
#import "ControllerUtilities.h"
#import "CustomUILabel.h"
#import "BadgeUtilities.h"
#import "WebserviceRequest.h"
#import "LocationController.h"

@interface TimelineViewController () <ActivityStoreDelegate>

@property (nonatomic, retain) UILabel *zeroRidesLabel;
@property CGFloat previousScrollViewYOffset;
@property UIRefreshControl *refreshControl;
@property UIImage *driverIconWhite;
@property UIImage *passengerIconWhite;
@property UIImage *requestIconWhite;

@end

@implementation TimelineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing timeline"];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor darkestBlue];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [ActivityStore sharedStore].delegate = self;
    self.driverIconWhite = [UIImage imageNamed:@"DriverIcon"];
    self.passengerIconWhite = [UIImage imageNamed:@"PassengerIconBig"];
    [[ActivityStore sharedStore] initAllActivitiesFromCoreData];
    [self prepareZeroRidesLabel];
    
    if (iPhone5) {
        self.tableView.frame = CGRectMake(0, 0, 320, 498);
    } else {
        self.tableView.frame = CGRectMake(0, 0, 320, 408);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = [NSString stringWithFormat:@"Timeline screen: %d", self.index];

    [self.delegate willAppearViewWithIndex:self.index];
    [self.tableView reloadData];
    [self checkIfAnyRides];
    [BadgeUtilities updateMyRidesDateInBadge:[ActionManager currentDate]];
    NSLog(@"%f %f", self.view.frame.size.width, self.view.frame.size.height);
}

-(void)checkIfAnyRides {
    if ([[[ActivityStore sharedStore] recentActivitiesByType:self.index] count] == 0) {
        if (self.index == 1 && ![LocationController locationServicesEnabled]) { // around me
            self.zeroRidesLabel.text = @"Please enable location services on your iPhone:\n\nSettings -> Privacy -> Location Services -> TUMitfahrer";
        } else {
            self.zeroRidesLabel.text = @"Currenlty no new activities";
        }
        [self.view addSubview:self.zeroRidesLabel];
        self.zeroRidesLabel.hidden = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.zeroRidesLabel removeFromSuperview];
        self.zeroRidesLabel.hidden = YES;
    }
}

-(void)prepareZeroRidesLabel {
    self.zeroRidesLabel = [[CustomUILabel alloc] initInMiddle:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) text:@"Currenlty no new activities" viewWithNavigationBar:self.navigationController.navigationBar];
    self.zeroRidesLabel.textColor = [UIColor blackColor];
}

- (void)handleRefresh:(id)sender {
    [[ActivityStore sharedStore] fetchActivitiesFromWebservice:^(BOOL isFetched) {
        if (isFetched) {
            [[ActivityStore sharedStore] initAllActivitiesFromCoreData];
            [self.refreshControl endRefreshing];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ActivityStore sharedStore] recentActivitiesByType:self.index] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineCell"];
    
    if(cell == nil){
        cell = [TimelineCell timelineCell];
    }
    
    // TODO: potential bug
    id result = [[[ActivityStore sharedStore] recentActivitiesByType:self.index] objectAtIndex:indexPath.row];
    
    NSDate *now = [ActionManager currentDate];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *components = [c components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[ActionManager localDateWithDate:[result updatedAt]] toDate:now options:0];
    components.timeZone = [NSTimeZone localTimeZone];
    if (components.day > 0) {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"%d days ago", (int)components.day];
    } else if(components.hour > 0) {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"%d hours ago", (int)components.hour];
    } else if(components.minute > 0) {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"%d minutes ago", (int)components.minute];
    } else {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"Added just now"];
    }
    
    NSString *rideDescription = @"";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if([result isKindOfClass:[Request class]]) {
        Request *request = (Request *)result;
        rideDescription = [NSString stringWithFormat:@"Request received for a ride to %@", request.requestedRide.destination];
        cell.iconImageView.image = self.passengerIconWhite;
        if (self.index == 2) {
            NSArray *timeValues = [ActionManager shortestTimeFromNowFromDate:request.requestedRide.departureTime];
            
            if ([[timeValues objectAtIndex:1] intValue]< 60) {
                cell.activityDetailLabel.text = [NSString stringWithFormat:@"Join in %@ minutes", [timeValues objectAtIndex:1]];
                cell.activityDetailLabel.textColor = [UIColor redColor];
            } else if([[timeValues objectAtIndex:0] intValue] < 12){
                cell.activityDetailLabel.text = [NSString stringWithFormat:@"Join in %@ hours", [timeValues objectAtIndex:0]];
                cell.activityDetailLabel.textColor = [UIColor orangeColor];
            } else {
                cell.activityDetailLabel.text = [NSString stringWithFormat:@"Join in %@ hours", [timeValues objectAtIndex:0]];
                cell.activityDetailLabel.textColor = [UIColor darkGrayColor];
            }
        }
    } else if ([result isKindOfClass:[RideSearch class]] ) {
        RideSearch *search = ((RideSearch *)result);
        if (search.destination == nil || search.destination.length == 0) {
            rideDescription = [NSString stringWithFormat:@"User searched for a ride from %@", search.departurePlace];
        } else {
            rideDescription = [NSString stringWithFormat:@"User searched for a ride to %@", search.destination];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.iconImageView.image = self.passengerIconWhite;
        
    } else if([result isKindOfClass:[Ride class]]) {
        Ride *ride = (Ride*)result;
        
        NSArray* fullDestination = [ride.destination componentsSeparatedByString: @","];
        NSString* destination = [fullDestination objectAtIndex:0];
        
        if ([ride.isRideRequest boolValue]) {
            rideDescription = [NSString stringWithFormat:@"New ride request to: \n%@", destination];
            cell.iconImageView.image = self.passengerIconWhite;
        } else {
            rideDescription = [NSString stringWithFormat:@"New ride offer to: \n%@", destination];
            cell.iconImageView.image = self.driverIconWhite;
        }
        
        if (self.index == 2) {
            
            NSArray *timeValues = [ActionManager shortestTimeFromNowFromDate:ride.departureTime];
            
            if ([[timeValues objectAtIndex:1] intValue]< 60) {
                cell.activityDetailLabel.text = [NSString stringWithFormat:@"Join in %@ minutes", [timeValues objectAtIndex:1]];
                cell.activityDetailLabel.textColor = [UIColor redColor];
            } else if([[timeValues objectAtIndex:0] intValue] < 12){
                cell.activityDetailLabel.text = [NSString stringWithFormat:@"Join in %@ hours", [timeValues objectAtIndex:0]];
                cell.activityDetailLabel.textColor = [UIColor orangeColor];
            } else {
                cell.activityDetailLabel.text = [NSString stringWithFormat:@"Join in %@ hours", [timeValues objectAtIndex:0]];
                cell.activityDetailLabel.textColor = [UIColor darkGrayColor];
            }
        }
    }
    cell.textView.text = rideDescription;
    cell.textView.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id result = [[[ActivityStore sharedStore] recentActivitiesByType:self.index] objectAtIndex:indexPath.row];
    
    if ([result isKindOfClass:[Ride class]]) {
        Ride *ride = (Ride *)result;
        Ride *coreDataRide = [[RidesStore sharedStore] fetchRideFromCoreDataWithId:ride.rideId];
        if (coreDataRide == nil) {
            
            [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:ride.rideId block:^(Ride *fetchedRide) {
                UIViewController *vc = [ControllerUtilities viewControllerForRide:fetchedRide];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        } else {
            UIViewController *vc = [ControllerUtilities viewControllerForRide:coreDataRide];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if([result isKindOfClass:[Request class]]) {
        Request *res = (Request *)result;
        Request *request = [RidesStore fetchRequestFromCoreDataWithId:res.requestId];
        if (request != nil) {
            UIViewController *vc = [ControllerUtilities viewControllerForRide:request.requestedRide];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [WebserviceRequest getRequestForRideId:res.rideId requestId:res.requestId block:^(Request *newRequest) {
                UIViewController *vc = [ControllerUtilities viewControllerForRide:newRequest.requestedRide];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - delegate methods

-(void)didRecieveActivitiesFromWebService {
    [self.tableView reloadData];
    [self checkIfAnyRides];
}

-(void)dealloc {
    self.delegate = nil;
}

@end
