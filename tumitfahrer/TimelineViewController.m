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
    
    UIColor *customGrayColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.view setBackgroundColor:customGrayColor];
    
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
        cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"Request received with type %@", ((Request *)result).requestedFrom];
        cell.iconImageView.image = self.passengerIconWhite;
    } else {
        Ride *ride = (Ride*)result;

        if (ride.driver == nil) {
            cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"New ride request to \n%@", ride.destination];
            cell.iconImageView.image = self.passengerIconWhite;
        } else {
            cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"New ride offer to \n%@", ride.destination];
            cell.iconImageView.image = self.driverIconWhite;
        }
    }
    
    NSDate *now = [NSDate date];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *components = [c components:NSDayCalendarUnit|NSHourCalendarUnit fromDate:[result updatedAt] toDate:now options:0];
    cell.activityDetailLabel.text = [NSString stringWithFormat:@"%d days %d hours ago", components.day, components.hour];

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
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
