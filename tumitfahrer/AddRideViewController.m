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

@interface AddRideViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *shareValues;
@property (nonatomic, strong) NSMutableArray *passengerValues;
@property (nonatomic, strong) NSMutableArray *tableValues;
@property (nonatomic, strong) NSMutableArray *tablePlaceholders;

@end

@implementation AddRideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tablePlaceholders = [[NSMutableArray alloc] initWithObjects:@"Departure", @"Destination", @"Free Seats", @"Meeting Point", nil];
        self.tableValues = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", nil];
        self.shareValues = [[NSMutableArray alloc] initWithObjects:@"Facebook", @"Email", nil];
        self.passengerValues = [[NSMutableArray alloc] initWithObjects:@"Add a passenger", @"Add second passenger", @"Add third passenger", @"Add fourth passenger", @"Add fifth passenger", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSString *departurePlace = [LocationController sharedInstance].currentAddress;
    
    if(departurePlace!=nil)
        [self.tableValues replaceObjectAtIndex:0 withObject:departurePlace];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self setupView];
}


-(void)setupView {
    self.view = [NavigationBarUtilities makeBackground:self.view];
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController];
    self.title = @"ADD RIDE";
    
    UIButton *settingsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [settingsView addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [settingsView setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"DeleteIcon2"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsView];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
    
    // right button of the navigation bar
    CustomBarButton *searchButton = [[CustomBarButton alloc] initWithTitle:@"Add"];
    [searchButton addTarget:self action:@selector(addRideButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.tablePlaceholders count];
    } else if (section == 1){
        return [self.shareValues count];
    } else {
        return [self.passengerValues count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"SettingsCell";
    NSString *SwitchIdentifier = @"SwitchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    SwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:SwitchIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (switchCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SwitchTableViewCell" owner:self options:nil];
        switchCell = [nib objectAtIndex:0];
    }
    if(indexPath.section == 0 && indexPath.row == 2) {
        
        FreeSeatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeSeatsTableViewCell"];
        
        if(cell == nil){
            cell = [FreeSeatsTableViewCell freeSeatsTableViewCell];
        }
        
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.stepperLabelText.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
        return  cell;
    }
    
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = [self.tableValues objectAtIndex:indexPath.row];
        cell.textLabel.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
    } else if(indexPath.section == 1) {
        switchCell.switchCellTextLabel.text = [self.shareValues objectAtIndex:indexPath.row];
    } else if(indexPath.section == 2) {
        cell.textLabel.text = [self.passengerValues objectAtIndex:indexPath.row];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    switchCell.switchCellTextLabel.textColor = [UIColor whiteColor];
    switchCell.backgroundColor = [UIColor clearColor];
    switchCell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:70 green:30 blue:180 alpha:0.3];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 1)
        return switchCell;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Meeting Point"]) {
            MeetingPointViewController *meetingPointVC = [[MeetingPointViewController alloc] init];
            meetingPointVC.selectedValueDelegate = self;
            [self.navigationController pushViewController:meetingPointVC animated:YES];
        }
        if (([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Destination"]) || [[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Departure"]) {
            DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
            destinationVC.delegate = self;
            destinationVC.rideTableIndexPath = indexPath;
            [self.navigationController pushViewController:destinationVC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
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
    NSString *departurePlace = [self.tableValues objectAtIndex:0];
    NSString *destination = [self.tableValues objectAtIndex:1];
    NSString *freeSeats = [self.tableValues objectAtIndex:2];
    NSString *meetingPoint = [self.tableValues objectAtIndex:3];
    if (!departurePlace || !destination || !meetingPoint) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSString *now = [formatter stringFromDate:[NSDate date]];

    queryParams = @{@"departure_place": departurePlace, @"destination": destination, @"departure_time": now, @"free_seats": freeSeats, @"meeting_point": meetingPoint, @"ride_type": [NSNumber numberWithInt:self.RideType]};
    NSDictionary *rideParams = @{@"ride": queryParams};
    
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"apiKey" value:[[CurrentUser sharedInstance] user].apiKey];
    
    [objectManager postObject:nil path:@"/api/v2/rides" parameters:rideParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Ride *ride = (Ride *)[mappingResult firstObject];
        [[RidesStore sharedStore] addRideToStore:ride];
        [[LocationController sharedInstance] fetchLocationForAddress:ride.destination rideId:ride.rideId];
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        NSLog(@"This is ride: %@", ride);
        NSLog(@"This is driver: %@", ride.driver);
        [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)selectedMeetingPoint:(NSString *)value {
    [self.tableValues replaceObjectAtIndex:3 withObject:value];
}

-(void)selectedDestination:(NSString *)destination indexPath:(NSIndexPath*)indexPath{
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:destination];
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    if(self.DisplayType == ShowAsModal)
        return NO;
    else
    return YES;
}

-(void)stepperValueChanged:(NSInteger)stepperValue {
    [self.tableValues replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:(int)stepperValue]];
}

@end
