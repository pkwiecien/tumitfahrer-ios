//
//  AddRideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "EditRequestViewController.h"
#import "CustomBarButton.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "Ride.h"
#import "ActionManager.h"
#import "LocationController.h"
#import "RidesStore.h"
#import "NavigationBarUtilities.h"
#import "MMDrawerBarButtonItem.h"
#import "SearchRideViewController.h"
#import "SegmentedControlCell.h"
#import "KGStatusBar.h"
#import "RideDetailViewController.h"
#import "LocationController.h"
#import "Ride.h"

@interface EditRequestViewController () <NSFetchedResultsControllerDelegate, SementedControlCellDelegate>

@property (nonatomic, strong) NSMutableArray *tablePassengerValues;
@property (nonatomic, strong) NSMutableArray *tablePlaceholders;
@property (nonatomic, strong) NSMutableArray *tableValues;
@property (nonatomic, assign) ContentType RideType;

@end

@implementation EditRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTables];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor customLightGray];
}

-(void)initTables {
    self.tableValues = [[NSMutableArray alloc] initWithObjects:self.ride.departurePlace, self.ride.destination, [ActionManager stringFromDate:self.ride.departureTime], @"", nil];
    self.tablePlaceholders = [[NSMutableArray alloc] initWithObjects:@"Departure", @"Destination", @"Time", @"", nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self setupNavigationBar];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    
    // right button of the navigation bar
    CustomBarButton *searchButton = [[CustomBarButton alloc] initWithTitle:@"Save"];
    [searchButton addTarget:self action:@selector(addRideButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    self.title = @"Edit ride";
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tablePlaceholders count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"GeneralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row == [self.tablePlaceholders count]-1) {
        SegmentedControlCell *cell = [SegmentedControlCell segmentedControlCell];
        [cell setFirstSegmentTitle:@"Campus" secondSementTitle:@"Activity"];
        cell.segmentedControl.selectedSegmentIndex = self.RideType;
        cell.delegate = self;
        [cell addHandlerToSegmentedControl];
        cell.controlId = 1;
        return cell;
    }
    
    if (indexPath.row < [self.tableValues count] && [self.tableValues objectAtIndex:indexPath.row] != nil) {
        cell.detailTextLabel.text = [self.tableValues objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Meeting Point"] || [[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Car"]) {
            MeetingPointViewController *meetingPointVC = [[MeetingPointViewController alloc] init];
            meetingPointVC.selectedValueDelegate = self;
            meetingPointVC.indexPath = indexPath;
            meetingPointVC.title = [self.tableValues objectAtIndex:indexPath.row];
            meetingPointVC.startText = [self.tableValues objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:meetingPointVC animated:YES];
        }
        else if (([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Destination"]) || [[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Departure"]) {
            DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
            destinationVC.delegate = self;
            destinationVC.rideTableIndexPath = indexPath;
            [self.navigationController pushViewController:destinationVC animated:YES];
        } else if([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Time"]) {
            RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
            dateSelectionVC.delegate = self;
            [dateSelectionVC show];
        }
    }
}

-(void)addRideButtonPressed {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *queryParams;
    // add enum
    NSString *departurePlace = [self.tableValues objectAtIndex:1];
    NSString *destination = [self.tableValues objectAtIndex:2];
    NSString *departureTime = [self.tableValues objectAtIndex:3];
    
    if (!departurePlace || departurePlace.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No departure time" description:@"To add a ride please specify the departure place"];
        return;
    } else if(!destination || destination.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No destination" description:@"To add a ride please specify the destination"];
        return;
    } else if(!departureTime || departureTime.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No departure time" description:@"To add a ride please specify the departure time"];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
    NSDate *dateString = [formatter dateFromString:departureTime];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSString *time = [formatter stringFromDate:dateString];
    
    NSDictionary *rideParams = nil;
    
    queryParams = @{@"departure_place": departurePlace, @"destination": destination, @"departure_time": time, @"ride_type": [NSNumber numberWithInt:self.RideType], @"is_driving": [NSNumber numberWithBool:NO]};
    
    rideParams = @{@"ride": queryParams};
    
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"apiKey" value:[[CurrentUser sharedInstance] user].apiKey];
    
    NSLog(@"user api key: %@", [CurrentUser sharedInstance].user.apiKey);
    [objectManager postObject:nil path:[NSString stringWithFormat:@"/api/v2/users/%@/rides", [CurrentUser sharedInstance].user.userId] parameters:rideParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Ride *ride = (Ride *)[mappingResult firstObject];
        [[RidesStore sharedStore] addRideToStore:ride];
        
        self.tablePassengerValues = nil;
        [KGStatusBar showSuccessWithStatus:@"Ride added"];
        
        RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
        rideDetailVC.ride = ride;
        rideDetailVC.shouldGoBackEnum = GoBackToList;
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [ActionManager showAlertViewWithTitle:[error localizedDescription]];
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(void)closeButtonPressed {
    [self.navigationController popViewControllerWithFade];
}

#pragma mark - RMDateSelectionViewController Delegates

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateString = [ActionManager stringFromDate:aDate];
    [self.tableValues replaceObjectAtIndex:3 withObject:dateString];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    
}

-(void)didSelectValue:(NSString *)value forIndexPath:(NSIndexPath *)indexPath {
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:value];
}

-(void)selectedDestination:(NSString *)destination indexPath:(NSIndexPath*)indexPath{
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:destination];
    
}

-(void)stepperValueChanged:(NSInteger)stepperValue {
    [self.tableValues replaceObjectAtIndex:4 withObject:[[NSNumber numberWithInt:(int)stepperValue] stringValue]];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)segmentedControlChangedToIndex:(NSInteger)index segmentedControlId:(NSInteger)controlId{
    if(controlId == 1) { //ride type
        if (index == 0) {
            self.RideType = ContentTypeCampusRides;
        } else {
            self.RideType = ContentTypeActivityRides;
        }
    }
}

@end
