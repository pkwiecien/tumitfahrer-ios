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
#import "RideDetailViewController.h"
#import "RidesStore.h"

@interface TimelineViewController ()

@property CGFloat previousScrollViewYOffset;
@property UIRefreshControl *refreshControl;
@property UIImage *driverIconWhite;
@property UIImage *passengerIconWhite;
@property UIImage *requestIconWhite;

@end

@implementation TimelineViewController

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
    [self.view setBackgroundColor:[UIColor customLightGray]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing timeline"];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [[ActivityStore sharedStore] fetchActivitiesFromWebservice:^(BOOL isFetched) {
        if (isFetched) {
            [[ActivityStore sharedStore] loadAllActivitiesFromCoreData];
            [self.tableView reloadData];
        }
    }];
    
    self.driverIconWhite = [ActionManager colorImage:[UIImage imageNamed:@"DriverIcon"] withColor:[UIColor whiteColor]];
    self.passengerIconWhite = [ActionManager colorImage:[UIImage imageNamed:@"PassengerIcon"] withColor:[UIColor whiteColor]];
}

- (void)handleRefresh:(id)sender {
    [[ActivityStore sharedStore] fetchActivitiesFromWebservice:^(BOOL isFetched) {
        if (isFetched) {
            [[ActivityStore sharedStore] loadAllActivitiesFromCoreData];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.delegate willAppearViewWithIndex:self.index];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ActivityStore sharedStore] recentActivitiesByType:self.index] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineCell"];
    
    if(cell == nil){
        cell = [TimelineCell timelineCell];
    }
    
    NSLog(@"index path: %ld", (long)indexPath.row);
    NSLog(@"count: %lu", (unsigned long)(int)[[[ActivityStore sharedStore] recentActivitiesByType:self.index] count]);
    id result = [[[ActivityStore sharedStore] recentActivitiesByType:self.index] objectAtIndex:indexPath.row];
    if([result isKindOfClass:[Rating class]]) {
        cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"Rating received with type %d", [((Rating *)result).ratingType intValue]];
    } else if([result isKindOfClass:[Request class]]) {
        cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"Request received for a ride to %@", ((Request *)result).requestedFrom];
        cell.iconImageView.image = self.passengerIconWhite;
    } else {
        Ride *ride = (Ride*)result;

        NSArray* fullDestination = [ride.destination componentsSeparatedByString: @","];
        NSString* destination = [fullDestination objectAtIndex:0];
        
        if (ride.driver == nil) {
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
            UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
            UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
            UIColor *foregroundColor = [UIColor blackColor];
            
            // Create the attributes
            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   regularFont, NSFontAttributeName,
                                   foregroundColor, NSForegroundColorAttributeName, nil];
            NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                      boldFont, NSFontAttributeName, nil];
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
    
    NSDate *now = [NSDate date];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *components = [c components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[result updatedAt] toDate:now options:0];
    if (components.day > 0) {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"%d days %d hours ago", components.day, components.hour];
    } else if(components.hour > 0) {
        cell.activityDetailLabel.text = [NSString stringWithFormat:@"%d hours %d minutes ago", components.hour, components.minute];
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
        RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
        rideDetailVC.ride = (Ride *)result;
        [self.navigationController pushViewController:rideDetailVC animated:YES];
    } else if([result isKindOfClass:[Request class]]) {
        Request *res = (Request *)result;
        Ride *ride = [[RidesStore sharedStore] containsRideWithId:[res.rideId intValue]];
        if (ride != nil) {
            res.requestedRide = ride;
            RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
            rideDetailVC.ride = ride;
            [self.navigationController pushViewController:rideDetailVC animated:YES];
        } else {
            [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:[res.rideId intValue] block:^(BOOL completed) {
                if(completed) {
                    RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
                    Ride *ride = [[RidesStore sharedStore] fetchRideFromCoreDataWithId:[res.rideId intValue]];
                    rideDetailVC.ride = ride;
                    [self.navigationController pushViewController:rideDetailVC animated:YES];
                }
            }];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
