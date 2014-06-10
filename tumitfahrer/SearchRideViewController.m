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

@interface SearchRideViewController () <SementedControlCellDelegate, DestinationViewControllerDelegate, RMDateSelectionViewControllerDelegate, SliderCellDelegate, ButtonCellDelegate>

@property (nonatomic) UIColor *customGrayColor;
@property (nonatomic, assign) NSInteger searchType;
@property (nonatomic, strong) NSMutableArray *tableValue;
@property (nonatomic, strong) NSMutableArray *tablePlaceholders;

@end

@implementation SearchRideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableValue = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"1", @"", @"", @"", nil];
        self.tablePlaceholders = [[NSMutableArray alloc] initWithObjects:@"", @"Departure", @"", @"Destination", @"", @"Time", @"", nil];
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
    
    if(self.SearchDisplayType == ShowAsViewController)
        [self setupLeftMenuButton];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    self.title = @"Search rides";
    
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
        return cell;
    } else if(indexPath.row ==  1 || indexPath.row == 3 || indexPath.row == 5) {
        
        if (indexPath.row < [self.tableValue count] && [self.tableValue objectAtIndex:indexPath.row] != nil) {
            cell.detailTextLabel.text = [self.tableValue objectAtIndex:indexPath.row];
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
    if(indexPath.row == 1 || indexPath.row == 3) {
        DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
        destinationVC.rideTableIndexPath = indexPath;
        destinationVC.delegate = self;
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
    NSString *departurePlace = [self.tableValue objectAtIndex:1];
    NSString *departurePlaceThreshold = [self.tableValue objectAtIndex:2];
    NSString *destination = [self.tableValue objectAtIndex:3];
    NSString *destinationThreshold = [self.tableValue objectAtIndex:4];
    NSString *departureTime = [self.tableValue objectAtIndex:5];
    
    if ((departurePlace == nil || departurePlace.length == 0) && (destination == nil || destination.length == 0) ) {
        [ActionManager showAlertViewWithTitle:@"Invalid search" description:@"Please specify departure and destination place"];
        return;
    }
    NSString *time = nil;
    if (departureTime != nil && departureTime.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
        NSDate *dateString = [formatter dateFromString:departureTime];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        time = [formatter stringFromDate:dateString];
    }
    
    if (departurePlace.length == 0 && destination.length == 0 && departureTime.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No data" description:@"All search fields can't be empty"];
        return;
    }
    
    NSDictionary *queryParams = @{@"departure_place": departurePlace, @"departure_place_threshold" : departurePlaceThreshold, @"destination": destination, @"destination_threshold":destinationThreshold, @"departure_time": time, @"ride_type": [NSNumber numberWithBool:self.searchType]};
    
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
    [self.tableValue replaceObjectAtIndex:indexPath.row withObject:value];
}

-(void)selectedDestination:(NSString *)destination indexPath:(NSIndexPath*)indexPath{
    [self.tableValue replaceObjectAtIndex:indexPath.row withObject:destination];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateString = [ActionManager stringFromDate:aDate];
    [self.tableValue replaceObjectAtIndex:5 withObject:dateString];
    
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
    [self.tableValue replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:value]];
}

@end
