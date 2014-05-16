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

@interface TimelineViewController ()

@property CGFloat previousScrollViewYOffset;
@property UIRefreshControl *refreshControl;

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
    
    [[ActivityStore sharedStore] fetchActivitiesFromWebservice:^(BOOL isFetched) {
        if (isFetched) {
            [[ActivityStore sharedStore] loadAllActivities];
            [self.tableView reloadData];
        }
    }];
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
    return [[[ActivityStore sharedStore] recentActivities] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineCell"];
    
    if(cell == nil){
        cell = [TimelineCell timelineCell];
    }
    
    NSLog(@"index path: %d", indexPath.row);
    NSLog(@"count: %d", [[[ActivityStore sharedStore] recentActivities] count]);
    id result = [[[ActivityStore sharedStore] recentActivities] objectAtIndex:indexPath.row];
    if([result isKindOfClass:[Rating class]]) {
        cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"Rating received with type %d", [((Rating *)result).ratingType intValue]];
    } else if([result isKindOfClass:[Request class]]) {
        cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"Request received with type %@", ((Request *)result).requestedFrom];
    } else {
        cell.activityDescriptionLabel.text = [NSString stringWithFormat:@"Ride added with id %d", ((Ride *)result).rideId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
