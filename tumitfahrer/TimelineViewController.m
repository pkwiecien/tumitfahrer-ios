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
}

-(void)viewWillAppear:(BOOL)animated {
    
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 0, 10, 0);
    self.tableView.contentInset = inset;
    self.screenNumberLabel.text = [NSString stringWithFormat:@"Screen #%d", self.index];

    [self.delegate willAppearViewWithIndex:self.index];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ActivityStore sharedStore] recentActivities] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineCell"];
    
    if(cell == nil){
        cell = [TimelineCell timelineCell];
    }
    
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
