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
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [ActivityStore sharedStore].delegate = self;
    self.driverIconWhite = [UIImage imageNamed:@"DriverIcon"];
    self.passengerIconWhite = [UIImage imageNamed:@"PassengerIconBig"];
    [[ActivityStore sharedStore] initAllActivitiesFromCoreData];
    [self prepareZeroRidesLabel];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.delegate willAppearViewWithIndex:self.index];
    [self initTableViewSize];
    [self.tableView reloadData];
    [self checkIfAnyRides];
}

-(void)initTableViewSize {
    if (iPhone5) {
        self.view.frame = CGRectMake(0, 0, 480, 568);
        self.tableView.frame = CGRectMake(0, 0, 280, 568);
    } else {
        self.view.frame = CGRectMake(0, 0, 480, 480);
        self.tableView.frame = CGRectMake(0, 0, 280, 480);
    }
}


-(void)checkIfAnyRides {
    if ([[[ActivityStore sharedStore] recentActivitiesByType:self.index] count] == 0) {
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
    self.zeroRidesLabel = [[CustomUILabel alloc] initInMiddle:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) text:@"There are no new activities in TUMitfahrer" viewWithNavigationBar:self.navigationController.navigationBar];
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
    
    id result = [[[ActivityStore sharedStore] recentActivitiesByType:self.index] objectAtIndex:indexPath.row];
    
    if([result isKindOfClass:[Request class]]) {
        cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"Request received for a ride to %@", ((Request *)result).requestedRide.destination];
        cell.iconImageView.image = self.passengerIconWhite;
    } else if ([result isKindOfClass:[RideSearch class]]) {
        RideSearch *search = ((RideSearch *)result);
        if (search.destination == nil || search.destination.length == 0) {
            cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"User searched for a ride from %@", search.departurePlace];
        } else {
            cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"User searched for a ride to %@", search.destination];
        }
        
        cell.iconImageView.image = self.passengerIconWhite;
    } else if([result isKindOfClass:[Ride class]]) {
        Ride *ride = (Ride*)result;

        NSArray* fullDestination = [ride.destination componentsSeparatedByString: @","];
        NSString* destination = [fullDestination objectAtIndex:0];
        
        if ([ride.isRideRequest boolValue]) {
            NSString *descr = [NSString stringWithFormat:@"New ride request to: \n%@", destination];
            // iOS6 and above : Use NSAttributedStrings
            const CGFloat fontSize = 15;
            UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
            UIColor *foregroundColor = [UIColor blackColor];
            
            // Create the attributes
            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   regularFont, NSFontAttributeName,
                                   foregroundColor, NSForegroundColorAttributeName, nil];
            
            // Create the attributed string (text + attributes)
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:descr
                                                   attributes:attrs];
            //[attributedText setAttributes:subAttrs range:range];
            
            // Set it in our UILabel and we are done!
            [cell.activityDescriptionLabel setAttributedText:attributedText];
            [cell.activityDescriptionLabel sizeToFit];
            cell.iconImageView.image = self.passengerIconWhite;
        } else {
            // iOS6 and above : Use NSAttributedStrings
            NSString *descr = [NSString stringWithFormat:@"New ride offer to: \n%@", destination];
            const CGFloat fontSize = 15;
            //UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
            UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
            UIColor *foregroundColor = [UIColor blackColor];
            
            // Create the attributes
            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   regularFont, NSFontAttributeName,
                                   foregroundColor, NSForegroundColorAttributeName, nil];
            // NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys: boldFont, NSFontAttributeName, nil];
            //const NSRange range = NSMakeRange(a,b); // range of " 2012/10/14 ". Ideally this should not be hardcoded
            
            // Create the attributed string (text + attributes)
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:descr
                                                   attributes:attrs];
//            [attributedText setAttributes:subAttrs range:range];
            
            // Set it in our UILabel and we are done!
            [cell.activityDescriptionLabel setAttributedText:attributedText];
            [cell.activityDescriptionLabel sizeToFit];
            cell.iconImageView.image = self.driverIconWhite;
        }
    }
    
    NSDate *now = [ActionManager currentDate];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *components = [c components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[ActionManager localDateWithDate:[result updatedAt]] toDate:now options:0];
    components.timeZone = [NSTimeZone localTimeZone];
    if (components.day > 0) {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"%d days ago", components.day];
    } else if(components.hour > 0) {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"%d hours ago", components.hour];
    } else if(components.minute > 0) {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"%d minutes ago", components.minute];
    } else {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"Added just now"];
    }

    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id result = [[[ActivityStore sharedStore] recentActivitiesByType:self.index] objectAtIndex:indexPath.row];

    if ([result isKindOfClass:[Ride class]]) {
        Ride *ride = (Ride *)result;
        UIViewController *vc = [ControllerUtilities viewControllerForRide:ride];
        [self.navigationController pushViewController:vc animated:YES];
    } else if([result isKindOfClass:[Request class]]) {
        Request *res = (Request *)result;
        
        Ride *ride = [[RidesStore sharedStore] containsRideWithId:res.rideId];
        
        if (ride != nil) {
            res.requestedRide = ride;
            UIViewController *vc = [ControllerUtilities viewControllerForRide:ride];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:res.rideId block:^(BOOL completed) {
                if(completed) {
                    Ride *ride = [[RidesStore sharedStore] fetchRideFromCoreDataWithId:res.rideId];
                    UIViewController *vc = [ControllerUtilities viewControllerForRide:ride];
                    [self.navigationController pushViewController:vc animated:YES];
                }
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
