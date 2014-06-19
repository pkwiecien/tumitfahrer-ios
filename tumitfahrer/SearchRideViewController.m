//
//  SearchRideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SearchRideViewController.h"
#import "ActionManager.h"
#import "RideSearch.h"
#import "NavigationBarUtilities.h"
#import "CurrentUser.h"
#import "MMDrawerBarButtonItem.h"
#import "SegmentedControlCell.h"
#import "SliderCell.h"
#import "ButtonCell.h"
#import "DestinationViewController.h"
#import "SearchResultViewController.h"
#import "LocationController.h"
#import "RecentPlace.h"
#import "RecentPlaceUtilities.h"
#import "RidesStore.h"

@interface SearchRideViewController () <SegmentedControlCellDelegate, DestinationViewControllerDelegate, RMDateSelectionViewControllerDelegate, SliderCellDelegate, ButtonCellDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D departureCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D destinationCoordinate;
@property (nonatomic) UIColor *customGrayColor;
@property (nonatomic, assign) NSInteger searchType;
@property (nonatomic, strong) NSMutableArray *tableValues;
@property (nonatomic, strong) NSMutableArray *tablePlaceholders;

@end

@implementation SearchRideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableValues = [[NSMutableArray alloc] initWithObjects:@"", @"", @"15", @"", @"15", @"", @"", @"", nil];
        self.tablePlaceholders = [[NSMutableArray alloc] initWithObjects:@"", @"Departure", @"", @"Destination", @"", @"Time", @"", nil];
        self.navigationItem.backBarButtonItem.title = @"Search";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.view setBackgroundColor:[UIColor customLightGray]];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];

    if ([[self.tableValues objectAtIndex:1] isEqualToString:@""]) {
        [self setDepartureLabelForCurrentLocation];
    }
    
    if(self.SearchDisplayType == ShowAsViewController)
        [self setupLeftMenuButton];
}


-(void)setDepartureLabelForCurrentLocation {
    NSString *departurePlace = [LocationController sharedInstance].currentAddress;
    
    if(departurePlace!=nil) {
        [self.tableValues replaceObjectAtIndex:1 withObject:departurePlace];
        self.departureCoordinate = [LocationController sharedInstance].currentLocation.coordinate;
    }
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    self.title = @"Search";
    
    UIButton *settingsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [settingsView addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingsView setBackgroundImage:[UIImage imageNamed:@"DeleteIcon"] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsView];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"GeneralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        SegmentedControlCell *cell = [SegmentedControlCell segmentedControlCell];
        cell.delegate = self;
        [cell setFirstSegmentTitle:@"Campus Ride" secondSementTitle:@"Activity Ride"];
        [cell addHandlerToSegmentedControl];
        cell.controlId = 0;
        
#ifdef DEBUG
        // add label for kif test
        [[[[cell segmentedControl] subviews] objectAtIndex:0] setAccessibilityLabel:@"Activity"];
        [[[[cell segmentedControl] subviews] objectAtIndex:1] setAccessibilityLabel:@"Campus"];
        [[[[cell segmentedControl] subviews] objectAtIndex:0] setIsAccessibilityElement:YES];
        [[[[cell segmentedControl] subviews] objectAtIndex:1] setIsAccessibilityElement:YES];
#endif
        return cell;
    } else if(indexPath.row ==  1 || indexPath.row == 3 || indexPath.row == 5) {
        
        if (indexPath.row < [self.tableValues count] && [self.tableValues objectAtIndex:indexPath.row] != nil) {
            cell.detailTextLabel.text = [self.tableValues objectAtIndex:indexPath.row];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        }
        cell.textLabel.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    } else if(indexPath.row == 2 || indexPath.row == 4) {
        SliderCell *cell = [SliderCell sliderCell];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    } else if(indexPath.row == 6) {
        ButtonCell *cell = [ButtonCell buttonCell];
        cell.delegate = self;
        return cell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1 || indexPath.row == 3) {
        DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
        destinationVC.rideTableIndexPath = indexPath;
        destinationVC.delegate = self;
        destinationVC.headers = [NSMutableArray arrayWithObjects:@"Search History", @"Search Results", nil];
        destinationVC.predefinedDestinations = [NSMutableArray arrayWithObjects:@"Anywhere", @"Arcistraße 21, München", @"Garching-Hochbrück", @"Garching Forschungszentrum", nil];
        [self.navigationController pushViewController:destinationVC animated:YES];
    } else if (indexPath.row == 5) {
        RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
        dateSelectionVC.delegate = self;
        [dateSelectionVC show];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 4) {
        return 100;
    } else if(indexPath.row == 6) {
        return 60;
    }
    return 44;
}

-(void)buttonSelected {
    // TODO: add enum
    NSString *departurePlace = [self.tableValues objectAtIndex:1];
    if ([departurePlace isEqualToString:@"Anywhere"]) {
        departurePlace = @"";
    }
    NSString *departurePlaceThreshold = [self.tableValues objectAtIndex:2];
    NSString *destination = [self.tableValues objectAtIndex:3];
    if ([destination isEqualToString:@"Anywhere"]) {
        destination = @"";
    }
    NSString *destinationThreshold = [self.tableValues objectAtIndex:4];
    NSString *departureTime = [self.tableValues objectAtIndex:5];
    
    if ((departurePlace == nil || departurePlace.length == 0) && (destination == nil || destination.length == 0) ) {
        [ActionManager showAlertViewWithTitle:@"Invalid search" description:@"Please specify departure and destination place"];
        return;
    }
    NSDate *date = nil;
    if (departureTime != nil && departureTime.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
        date = [formatter dateFromString:departureTime];
    }
    
    if (departurePlace.length == 0 && destination.length == 0 && departureTime.length == 0) {
        [ActionManager showAlertViewWithTitle:@"Invalid search" description:@"All search fields can't be empty"];
        return;
    }
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    [queryParams setValue:departurePlace forKey:@"departure_place"];
    [queryParams setValue:departurePlaceThreshold forKey:@"departure_place_threshold"];
    [queryParams setValue:destination forKey:@"destination"];
    [queryParams setValue:destinationThreshold forKey:@"destination_threshold"];
    [queryParams setValue:[NSNumber numberWithBool:self.searchType] forKey:@"ride_type"];
    if (date != nil) {
        [queryParams setValue:date forKey:@"departure_time"];
    }
    
    [RecentPlaceUtilities createRecentPlaceWithName:departurePlace coordinate:self.departureCoordinate];
    [RecentPlaceUtilities createRecentPlaceWithName:destination coordinate:self.destinationCoordinate];
    [[RidesStore sharedStore] filterAllFavoriteRides];
    
    SearchResultViewController *searchResultVC = [[SearchResultViewController alloc] init];
    searchResultVC.queryParams = queryParams;
    [self.navigationController pushViewController:searchResultVC animated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(void)closeButtonPressed {
    [self.navigationController popViewControllerWithFade];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - RMDateSelectionViewController Delegates

-(void)didSelectValue:(NSString *)value forIndexPath:(NSIndexPath *)indexPath {
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:value];
}

-(void)selectedDestination:(NSString *)destination coordinate:(CLLocationCoordinate2D)coordinate indexPath:(NSIndexPath *)indexPath {
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:destination];
    if (indexPath.row == 1) {
        self.departureCoordinate = coordinate;
    } else if(indexPath.row == 3) {
        self.destinationCoordinate = coordinate;
    }
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateString = [ActionManager stringFromDate:aDate];
    [self.tableValues replaceObjectAtIndex:5 withObject:dateString];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    
}

-(void)segmentedControlChangedToIndex:(NSInteger)index segmentedControlId:(NSInteger)controlId {
    self.searchType = index;
}

-(void)sliderChangedToValue:(NSInteger)value indexPath:(NSIndexPath *)indexPath {
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:value]];
}

@end
