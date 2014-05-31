//
//  AddRideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AddRideViewController.h"
#import "CustomBarButton.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "Ride.h"
#import "ActionManager.h"
#import "LocationController.h"
#import "SwitchTableViewCell.h"
#import "RidesStore.h"
#import "NavigationBarUtilities.h"
#import "MMDrawerBarButtonItem.h"
#import "SearchRideViewController.h"
#import "SegmentedControlCell.h"
#import "KGStatusBar.h"
#import "RideDetailViewController.h"
#import "LocationController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AddRideViewController () <NSFetchedResultsControllerDelegate, SementedControlCellDelegate, SwitchTableViewCellDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *shareValues;
@property (nonatomic, strong) NSMutableArray *tableValue;
@property (nonatomic, strong) NSMutableArray *tablePassengerValues;
@property (nonatomic, strong) NSMutableArray *tableDriverValues;
@property (nonatomic, strong) NSMutableArray *tablePlaceholders;
@property (nonatomic, strong) NSMutableArray *tableSectionHeaders;
@property (nonatomic, strong) NSMutableArray *tableSectionIcons;

@end

@implementation AddRideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableValue = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"1", @"", @"", @"", nil];
        self.shareValues = [[NSMutableArray alloc] initWithObjects:@"Facebook", @"Email", nil];
        self.tableSectionIcons = [[NSMutableArray alloc] initWithObjects:[ActionManager colorImage:[UIImage imageNamed:@"DetailsIcons"] withColor:[UIColor whiteColor]], [ActionManager colorImage:[UIImage imageNamed:@"ShareIcon"] withColor:[UIColor whiteColor]], nil];
        self.tableSectionHeaders = [[NSMutableArray alloc] initWithObjects:@"Details", @"Share", nil];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTables];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSString *departurePlace = [LocationController sharedInstance].currentAddress;
    
    if(departurePlace!=nil)
        [self.tableValue replaceObjectAtIndex:1 withObject:departurePlace];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor customLightGray];
    
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AddRideTableHeader" owner:self options:nil] objectAtIndex:0];
    self.tableView.tableHeaderView = headerView;
    self.RideType = ContentTypeCampusRides;
    self.displayEnum = ShouldDisplayNormally;
}

-(void)initTables {
    
    if(self.TableType == Passenger) {
        if (self.tablePassengerValues != nil) {
            self.tableValue = [NSMutableArray arrayWithArray:self.tablePassengerValues];
        } else {
            self.tableValue = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", nil];
        }
        self.tablePlaceholders = [[NSMutableArray alloc] initWithObjects:@"", @"Departure", @"Destination", @"Time", @"", nil];
    } else {
        if(self.tableDriverValues != nil) {
            self.tableValue = [NSMutableArray arrayWithArray:self.tableDriverValues];
        } else {
            self.tableValue = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", nil];
        }
        self.tablePlaceholders = [[NSMutableArray alloc] initWithObjects:@"", @"Departure", @"Destination", @"Time", @"Free Seats", @"Car", @"Meeting Point", @"", nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self setupNavigationBar];
    
    if(self.RideDisplayType == ShowAsViewController)
        [self setupLeftMenuButton];
    if (self.shouldClose) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    
    // right button of the navigation bar
    CustomBarButton *searchButton = [[CustomBarButton alloc] initWithTitle:@"Add"];
    [searchButton addTarget:self action:@selector(addRideButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    self.title = @"Add ride";
    
    UIButton *settingsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [settingsView addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingsView setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"DeleteIcon2"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsView];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.tablePlaceholders count]; // plus one for the first row with selection of driver/passenger
    } else if (section == 1){
        return [self.shareValues count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"GeneralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        
        if(indexPath.row == 0) {
            SegmentedControlCell *cell = [SegmentedControlCell segmentedControlCell];
            cell.delegate = self;
            cell.segmentedControl.selectedSegmentIndex = self.TableType;
            [cell setFirstSegmentTitle:@"I am Passenger" secondSementTitle:@"I am Driver"];
            [cell addHandlerToSegmentedControl];
            cell.controlId = 0;
            return cell;
        } else if(self.TableType == Driver && indexPath.row == 4) {
            FreeSeatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeSeatsTableViewCell"];
            
            if(cell == nil){
                cell = [FreeSeatsTableViewCell freeSeatsTableViewCell];
            }
            
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.stepperLabelText.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
            return  cell;
        } else if(indexPath.row == [self.tableValue count]-1) {
            SegmentedControlCell *cell = [SegmentedControlCell segmentedControlCell];
            [cell setFirstSegmentTitle:@"Campus" secondSementTitle:@"Activity"];
            cell.segmentedControl.selectedSegmentIndex = self.RideType;
            cell.delegate = self;
            [cell addHandlerToSegmentedControl];
            cell.controlId = 1;
            return cell;
        }
        
        if (indexPath.row < [self.tableValue count] && [self.tableValue objectAtIndex:indexPath.row] != nil) {
            cell.detailTextLabel.text = [self.tableValue objectAtIndex:indexPath.row];
        }
        cell.textLabel.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    } else if(indexPath.section == 1) {
        SwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        
        if (switchCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SwitchTableViewCell" owner:self options:nil];
            switchCell = [nib objectAtIndex:0];
        }
        switchCell.switchCellTextLabel.text = [self.shareValues objectAtIndex:indexPath.row];
        switchCell.switchCellTextLabel.textColor = [UIColor blackColor];
        switchCell.backgroundColor = [UIColor clearColor];
        switchCell.contentView.backgroundColor = [UIColor clearColor];
        switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        switchCell.switchId = indexPath.row;
        switchCell.delegate = self;
        
        return switchCell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Meeting Point"] || [[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Car"]) {
            MeetingPointViewController *meetingPointVC = [[MeetingPointViewController alloc] init];
            meetingPointVC.selectedValueDelegate = self;
            meetingPointVC.indexPath = indexPath;
            meetingPointVC.title = [self.tableValue objectAtIndex:indexPath.row];
            meetingPointVC.startText = [self.tableValue objectAtIndex:indexPath.row];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40.0)];
    headerView.backgroundColor = [UIColor lighterBlue];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 20, 20)];
    imageView.image = [self.tableSectionIcons objectAtIndex:section];
    [headerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 10, 10)];
    label.text = [self.tableSectionHeaders objectAtIndex:section];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [headerView addSubview:label];
    return headerView;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Details";
    } else if (section ==1)
    {
        return @"Share a ride";
    } else if(section == 2) {
        return @"Passengers";
    }
    return @"Default";
}

-(void)addRideButtonPressed {
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *queryParams;
    // add enum
    NSString *departurePlace = [self.tableValue objectAtIndex:1];
    NSString *destination = [self.tableValue objectAtIndex:2];
    NSString *departureTime = [self.tableValue objectAtIndex:3];
    
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
    if(self.TableType == Driver) {
        
        NSString *freeSeats = [self.tableValue objectAtIndex:4];
        if (freeSeats.length == 0) {
            freeSeats = @"1";
        }
        NSString *car = [self.tableValue objectAtIndex:5];
        NSString *meetingPoint = [self.tableValue objectAtIndex:6];
        if (!meetingPoint) {
            [ActionManager showAlertViewWithTitle:@"No meeting place" description:@"To add a ride please specify the meeting place"];
            return;
        }
        
        queryParams = @{@"departure_place": departurePlace, @"destination": destination, @"departure_time": time, @"free_seats": freeSeats, @"meeting_point": meetingPoint, @"ride_type": [NSNumber numberWithInt:self.RideType], @"driver":@"true"};
        
        rideParams = @{@"ride": queryParams};
       
    } else { // passenger
        queryParams = @{@"departure_place": departurePlace, @"destination": destination, @"departure_time": time, @"ride_type": [NSNumber numberWithInt:self.RideType], @"passenger":@"true"};
        
        rideParams = @{@"ride": queryParams};
    }
    
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"apiKey" value:[[CurrentUser sharedInstance] user].apiKey];

    NSLog(@"user api key: %@", [CurrentUser sharedInstance].user.apiKey);
    [objectManager postObject:nil path:[NSString stringWithFormat:@"/api/v2/users/%@/rides", [CurrentUser sharedInstance].user.userId] parameters:rideParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Ride *ride = (Ride *)[mappingResult firstObject];
        [[RidesStore sharedStore] addRideToStore:ride];
        [[LocationController sharedInstance] fetchLocationForAddress:ride.destination rideId:ride.rideId];
        self.tablePassengerValues = nil;
        self.tableDriverValues = nil;
        [KGStatusBar showSuccessWithStatus:@"Ride added"];
        if (self.RideDisplayType == ShowAsModal) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
            rideDetailVC.ride = ride;
            rideDetailVC.displayEnum = self.displayEnum;
            rideDetailVC.shouldGoBackEnum = GoBackToList;
            [self.navigationController pushViewController:rideDetailVC animated:YES];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [ActionManager showAlertViewWithTitle:[error localizedDescription]];
        RKLogError(@"Load failed with error: %@", error);
    }];
}

-(void)closeButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(NSFetchedResultsController *)fetchedResultsController {
    
    if (self.fetchedResultsController != nil) {
        return self.fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Ride"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[RKManagedObjectStore defaultStore].
                                     mainQueueManagedObjectContext
                                     sectionNameKeyPath:nil cacheName:@"Ride"];
    self.fetchedResultsController.delegate = self;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        [ActionManager showAlertViewWithTitle:[error localizedDescription]];
    }
    
    return self.fetchedResultsController;
}

#pragma mark - RMDateSelectionViewController Delegates

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateString = [ActionManager stringFromDate:aDate];
    [self.tableValue replaceObjectAtIndex:3 withObject:dateString];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    
}

-(void)didSelectValue:(NSString *)value forIndexPath:(NSIndexPath *)indexPath {
    [self.tableValue replaceObjectAtIndex:indexPath.row withObject:value];
}

-(void)selectedDestination:(NSString *)destination indexPath:(NSIndexPath*)indexPath{
    [self.tableValue replaceObjectAtIndex:indexPath.row withObject:destination];
    
}

-(void)stepperValueChanged:(NSInteger)stepperValue {
    [self.tableValue replaceObjectAtIndex:4 withObject:[[NSNumber numberWithInt:(int)stepperValue] stringValue]];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)segmentedControlChangedToIndex:(NSInteger)index segmentedControlId:(NSInteger)controlId{
    if (controlId == 0) { // driver or passenger
        if (index == 0) {
            self.TableType = Passenger;
        } else {
            self.TableType = Driver;
        }
        [self saveTableValues];
        [self initTables];
        [self.tableView reloadData];
    } else if(controlId == 1) { //ride type
        if (index == 0) {
            self.RideType = ContentTypeCampusRides;
        } else {
            self.RideType = ContentTypeActivityRides;
        }
    }
}

-(void)saveTableValues {
    if (self.TableType == Driver) {
        self.tablePassengerValues = [NSMutableArray arrayWithArray:self.tableValue];
    } else {
        self.tableDriverValues = [NSMutableArray arrayWithArray:self.tableValue];
    }
}

-(void)switchChangedToStatus:(BOOL)status switchId:(NSInteger)switchId {
    if (switchId == 0) { // share on facebook
        if (status) {
            self.displayEnum = ShouldShareRideOnFacebook;
        } else
        {
            self.displayEnum = ShouldDisplayNormally;
        }
    }
    if (switchId == 1) { // go to email
        
    }
}

@end
