//
//  AddRideViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/23/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "AddRideViewController.h"
#import "ActionManager.h"
#import "CurrentUser.h"
#import "Ride.h"
#import "LocationController.h"
#import "SwitchTableViewCell.h"
#import "RidesStore.h"
#import "NavigationBarUtilities.h"
#import "MMDrawerBarButtonItem.h"
#import "SegmentedControlCell.h"
#import "KGStatusBar.h"
#import "OwnerOfferViewController.h"
#import "OwnerRequestViewController.h"
#import "RideDetailActionCell.h"
#import "Photo.h"
#import "CustomRepeatViewController.h"
#import "MenuViewController.h"
#import "WebserviceRequest.h"
#import "RMDateSelectionViewController.h"
#import "MeetingPointViewController.h"
#import "DestinationViewController.h"
#import "FreeSeatsTableViewCell.h"

@interface AddRideViewController () <SegmentedControlCellDelegate, SwitchTableViewCellDelegate, CustomRepeatViewController, RMDateSelectionViewControllerDelegate, MeetingPointDelegate, DestinationViewControllerDelegate, FreeSeatsCellDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D departureCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D destinationCoordinate;
@property (nonatomic, strong) NSMutableArray *shareValues;
@property (nonatomic, strong) NSMutableArray *tablePassengerValues;
@property (nonatomic, strong) NSMutableArray *tableDriverValues;
@property (nonatomic, strong) NSMutableArray *tablePlaceholders;
@property (nonatomic, strong) NSMutableArray *tableSectionHeaders;
@property (nonatomic, strong) NSMutableArray *tableSectionIcons;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImage *destinationImage;
@property (nonatomic, strong) Photo *destinationPassengerPhotoInfo;
@property (nonatomic, strong) Photo *destinationDriverPhotoInfo;
@property (nonatomic, strong) NSArray *repeatDates;
@property (nonatomic, strong) NSMutableDictionary *selectedRepeatValues;

@end

NSString *const kDriverRole = @"Driver Role";
NSString *const kDeparturePlace = @"Departure Place";
NSString *const kDestination = @"Destination";
NSString *const kDepartureTime = @"Departure Time";
NSString *const kRepeat = @"Repeat";
NSString *const kSeats = @"Driver Role";
NSString *const kCar = @"Car";
NSString *const kMeetingPoint = @"Meeting Point";
NSString *const kRideType = @"Ride Type";

@implementation AddRideViewController {
    RideDetailActionCell *addActionCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shareValues = [[NSMutableArray alloc] initWithObjects:@"Facebook", nil];
        self.tableSectionIcons = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"DetailsIcon"], [UIImage imageNamed:@"ShareIcon"], nil];
        self.tableSectionHeaders = [[NSMutableArray alloc] initWithObjects:@"Details", @"Share", @"Add", nil];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.repeatDates = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor customLightGray];
    
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"AddRideTableHeader" owner:self options:nil] objectAtIndex:0];
    self.tableView.tableHeaderView = self.headerView;
    self.RideType = ContentTypeCampusRides;
    self.displayEnum = ShouldDisplayNormally;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    self.tableView.tableFooterView = footerView;
}

-(void)initTables {
    
    if(self.TableType == Passenger) {
        if (self.tablePassengerValues != nil) {
            self.tableValues = [NSMutableArray arrayWithArray:self.tablePassengerValues];
        } else {
            self.tableValues = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", nil];
            [self setDepartureLabelForCurrentLocation];
        }
        self.tablePlaceholders = [[NSMutableArray alloc] initWithObjects:@"", @"Departure", @"Destination", @"Time", @"Meeting Point", @"", nil];
    } else {
        if(self.tableDriverValues != nil) {
            self.tableValues = [NSMutableArray arrayWithArray:self.tableDriverValues];
        } else {
            self.tableValues = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"No", @"", @"", @"", @"", nil];
            [self setDepartureLabelForCurrentLocation];
        }
        
        // init departureCoordinate, destinationCoordinate and fetchPhoto
        [self initDepartureAndDestinationCoordinates];
        
        self.tablePlaceholders = [[NSMutableArray alloc] initWithObjects:@"", @"Departure", @"Destination", @"Time", @"Repeat", @"Free Seats", @"Car", @"Meeting Point", @"", nil];
    }
}

-(void)initDepartureAndDestinationCoordinates {
    NSString *departure = [self.tableValues objectAtIndex:1];
    NSString *destination = [self.tableValues objectAtIndex:2];
    if ([departure length] == 0 || [destination length] == 0) {
        return;
    }
    [[LocationController sharedInstance] fetchLocationForAddress:departure completionHandler:^(CLLocation *location) {
        [self setDepartureCoordinate:location.coordinate];
        
        [[LocationController sharedInstance] fetchLocationForAddress:destination completionHandler:^(CLLocation *location) {
            [self setDestinationCoordinate:location.coordinate];
            [self fetchPhotoForDestinationCoordinate];
        }];
    }];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Add ride view";
    [self initTables];
    
    [self.tableView reloadData];
    [self setupNavigationBar];
    
    if(self.RideDisplayType == ShowAsViewController) {
        [self setupLeftMenuButton];
    }
    if ([[self.tableValues objectAtIndex:DRIVER_DEPARTURE_ENUM] isEqualToString:@""]) {
        [self setDepartureLabelForCurrentLocation];
    }
    [self.tableView sendSubviewToBack:self.headerView];
}

-(void)setDepartureLabelForCurrentLocation {
    self.departureCoordinate = [LocationController sharedInstance].currentLocation.coordinate;
    NSString *departurePlace = [LocationController sharedInstance].currentAddress;
    
    if(departurePlace!=nil)
        [self.tableValues replaceObjectAtIndex:1 withObject:departurePlace];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupNavigationBar {
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor lighterBlue]];
    
    self.title = @"Add";
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [deleteButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"DeleteIcon"] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.tablePlaceholders count];
    } else if (section == 1){
        return [self.shareValues count];
    } else if(section == 2) {
        return 1;
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
        } else if(self.TableType == Driver && indexPath.row == 5) {
            FreeSeatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeSeatsTableViewCell"];
            
            if(cell == nil){
                cell = [FreeSeatsTableViewCell freeSeatsTableViewCell];
            }
            
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.stepperLabelText.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
            return  cell;
        } else if(indexPath.row == [self.tablePlaceholders count]-1) {
            SegmentedControlCell *cell = [SegmentedControlCell segmentedControlCell];
            [cell setFirstSegmentTitle:@"Campus" secondSementTitle:@"Activity"];
            cell.segmentedControl.selectedSegmentIndex = self.RideType;
            cell.delegate = self;
            [cell addHandlerToSegmentedControl];
            cell.controlId = 1;
            return cell;
        }
        
        if (indexPath.row < [self.tablePlaceholders count] && [self.tableValues objectAtIndex:indexPath.row] != nil) {
            cell.detailTextLabel.text = [self.tableValues objectAtIndex:indexPath.row];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        }
        cell.textLabel.text = [self.tablePlaceholders objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor customLightGray];
        cell.contentView.backgroundColor = [UIColor customLightGray];
        
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
    } else if (indexPath.section == 2) {
        addActionCell = [RideDetailActionCell offerRideCell];
        [addActionCell.actionButton addTarget:self action:@selector(addRideButtonPressed) forControlEvents:UIControlEventTouchDown];
        [addActionCell.actionButton setTitle:@"Add" forState:UIControlStateNormal];
        [addActionCell.actionButton setBackgroundImage:[ActionManager colorImage:[UIImage imageNamed:@"BlueButton"] withColor:[UIColor lighterBlue]] forState:UIControlStateNormal];
        
        return addActionCell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if ([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Meeting Point"] || [[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Car"]) {
            MeetingPointViewController *meetingPointVC = [[MeetingPointViewController alloc] init];
            meetingPointVC.selectedValueDelegate = self;
            meetingPointVC.indexPath = indexPath;
            meetingPointVC.title = [self.tablePlaceholders objectAtIndex:indexPath.row];
            meetingPointVC.startText = [self.tableValues objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:meetingPointVC animated:YES];
        }
        else if (([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Destination"]) || [[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Departure"]) {
            DestinationViewController *destinationVC = [[DestinationViewController alloc] init];
            destinationVC.delegate = self;
            destinationVC.rideTableIndexPath = indexPath;
            [self.navigationController pushViewController:destinationVC animated:YES];
        } else if([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Time"]) {
            if (![[self.tableValues objectAtIndex:4] isEqualToString:@"No"]) {
                return;
            }
            RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
            dateSelectionVC.delegate = self;
            dateSelectionVC.hideNowButton = YES;
#ifdef DEBUG
            [dateSelectionVC.datePicker setAccessibilityLabel:@"Date Picker"];
            [dateSelectionVC.datePicker setIsAccessibilityElement:YES];
#endif
            [dateSelectionVC show];
        } else if([[self.tablePlaceholders objectAtIndex:indexPath.row] isEqualToString:@"Repeat"]) {
            CustomRepeatViewController *customRepeatVC = [[CustomRepeatViewController alloc] init];
            customRepeatVC.title = @"Repeat ride";
            customRepeatVC.delegate = self;
            customRepeatVC.values = self.selectedRepeatValues;
            [self.navigationController pushViewController:customRepeatVC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 10;
    }
    return 30.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40.0)];
        headerView.backgroundColor = [UIColor lighterBlue];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 20)];
        imageView.image = [self.tableSectionIcons objectAtIndex:section];
        [headerView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 10, 10)];
        label.text = [self.tableSectionHeaders objectAtIndex:section];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        [label sizeToFit];
        [headerView addSubview:label];
        
        return headerView;
    } {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10.0)];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    }
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
    // prevent from adding same ride twice
    addActionCell.actionButton.enabled = NO;
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *queryParams;
    // add enum
    NSString *departurePlace = [self.tableValues objectAtIndex:1];
    NSString *destination = [self.tableValues objectAtIndex:2];
    NSString *departureTime = [self.tableValues objectAtIndex:3];
    
    if (!departurePlace || departurePlace.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No departure time" description:@"To add a ride please specify the departure place"];
        addActionCell.actionButton.enabled = YES;
        return;
    } else if(!destination || destination.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No destination" description:@"To add a ride please specify the destination"];
        addActionCell.actionButton.enabled = YES;
        return;
    } else if(!departureTime || departureTime.length == 0) {
        [ActionManager showAlertViewWithTitle:@"No departure time" description:@"To add a ride please specify the departure time"];
        addActionCell.actionButton.enabled = YES;
        return;
    }
    
    BOOL isNearby = [LocationController isLocation:[[CLLocation alloc] initWithLatitude:self.departureCoordinate.latitude longitude:self.departureCoordinate.longitude] nearbyAnotherLocation:[[CLLocation alloc] initWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude] thresholdInMeters:1000];
    if (isNearby) {
        [ActionManager showAlertViewWithTitle:@"Problem" description:@"The route is too short"];
        addActionCell.actionButton.enabled = YES;
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
    NSDate *dateString = [formatter dateFromString:departureTime];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSString *time = [formatter stringFromDate:dateString];
    
    if ([dateString compare:[NSDate date]] == NSOrderedAscending) {
        [ActionManager showAlertViewWithTitle:@"Problem" description:@"You can't add ride in the past"];
        addActionCell.actionButton.enabled = YES;
        return;
    }
    
    NSDictionary *rideParams = nil;
    if(self.TableType == Driver) {
        
        NSString *freeSeats = [self.tableValues objectAtIndex:5];
        if (freeSeats.length == 0) {
            freeSeats = @"1";
        }
        
        NSString *car = [self.tableValues objectAtIndex:6];
        if (car.length == 0 && [CurrentUser sharedInstance].user.car != nil) {
            car = [CurrentUser sharedInstance].user.car;
        }
        
        NSString *meetingPoint = [self.tableValues objectAtIndex:7];
        if (!meetingPoint || meetingPoint.length == 0) {
            [ActionManager showAlertViewWithTitle:@"No meeting place" description:@"To add a ride please specify the meeting place"];
            addActionCell.actionButton.enabled = YES;
            return;
        }
        
        queryParams = @{@"departure_place": departurePlace, @"destination": destination, @"departure_time": time, @"free_seats": freeSeats, @"meeting_point": meetingPoint, @"ride_type": [NSNumber numberWithInt:self.RideType], @"car": car, @"is_driving": [NSNumber numberWithBool:YES], @"departure_latitude" : [NSNumber numberWithDouble:self.departureCoordinate.latitude], @"departure_longitude" : [NSNumber numberWithDouble:self.departureCoordinate.longitude], @"destination_latitude": [NSNumber numberWithDouble:self.destinationCoordinate.latitude],
                        @"destination_longitude" : [NSNumber numberWithDouble:self.destinationCoordinate.longitude], @"repeat_dates" : self.repeatDates};
        
        rideParams = @{@"ride": queryParams};
        
    } else { // passenger
        
        NSString *meetingPoint = [self.tableValues objectAtIndex:4];
        if (!meetingPoint || meetingPoint.length == 0) {
            [ActionManager showAlertViewWithTitle:@"No meeting place" description:@"To add a ride please specify the meeting place"];
            addActionCell.actionButton.enabled = YES;
            return;
        }
        
        queryParams = @{@"departure_place": departurePlace, @"destination": destination, @"departure_time": time, @"ride_type": [NSNumber numberWithInt:self.RideType], @"is_driving": [NSNumber numberWithBool:NO], @"meeting_point" : meetingPoint};
        
        rideParams = @{@"ride": queryParams};
    }
    
    [objectManager postObject:nil path:[NSString stringWithFormat:@"/api/v2/users/%@/rides", [CurrentUser sharedInstance].user.userId] parameters:rideParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        for (Ride *ride in [mappingResult array]) {
            
            if (self.destinationImage != nil) {
                ride.destinationImage = UIImageJPEGRepresentation(self.destinationImage, 0.8);
            }
            
            if (self.destinationDriverPhotoInfo != nil && self.TableType == Driver) {
                ride.photo = self.destinationDriverPhotoInfo;
            } else if(self.destinationPassengerPhotoInfo != nil && self.TableType == Passenger) {
                ride.photo = self.destinationDriverPhotoInfo;
            }
            
            if (ride.regularRideId != nil) { // we have a regular ride
                
            }
            
            [[RidesStore sharedStore] addRideToStore:ride];
        }
        
        [self resetTables];
        if(self.potentialRequestedRide != nil) {
            [self addPassengerToNewRide:[mappingResult firstObject]];
        } else {
            [self redirectToRideDetailsWithRide:[mappingResult firstObject]];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [ActionManager showAlertViewWithTitle:@"Error" description:@"Could not add a ride"];
        addActionCell.actionButton.enabled = YES;
        RKLogError(@"Load failed with error: %@", error);
    }];
}


-(void)redirectToRideDetailsWithRide:(Ride *)ride {
    [KGStatusBar showSuccessWithStatus:@"Ride added"];
    
    if ([ride.isRideRequest boolValue]) {
        OwnerRequestViewController *requestVC = [[OwnerRequestViewController alloc] init];
        requestVC.ride = ride;
        requestVC.displayEnum = self.displayEnum;
        requestVC.shouldGoBackEnum = GoBackToList;
        [self.navigationController pushViewController:requestVC animated:YES];
    } else {
        OwnerOfferViewController *rideDetailVC = [[OwnerOfferViewController alloc] init];
        rideDetailVC.ride = ride;
        rideDetailVC.displayEnum = self.displayEnum;
        rideDetailVC.shouldGoBackEnum = GoBackToList;
        [self.navigationController pushViewController:rideDetailVC animated:YES];
    }
}

-(void)addPassengerToNewRide:(Ride *)newRide {
    [WebserviceRequest addPassengerWithId:self.potentialRequestedRide.rideOwner.userId rideId:newRide.rideId block:^(BOOL isAdded) {
        if (isAdded) {
            User *user = self.potentialRequestedRide.rideOwner;
            [WebserviceRequest deleteRideFromWebservice:self.potentialRequestedRide block:^(BOOL isCompleted) {
                if (isCompleted) {
                    [[RidesStore sharedStore] addPassengerForRideId:newRide.rideId requestor:user];
                    [self redirectToRideDetailsWithRide:newRide];
                }
            }];
        }
    }];
}

-(void)resetTables {
    self.tablePassengerValues = nil;
    self.tableDriverValues = nil;
    self.destinationDriverPhotoInfo = nil;
    self.destinationPassengerPhotoInfo = nil;
    self.selectedRepeatValues = [NSMutableDictionary dictionary];
    [self setDepartureLabelForCurrentLocation];
}

-(void)closeButtonPressed {
    [self.navigationController popViewControllerWithFade];
}

#pragma mark - RMDateSelectionViewController Delegates

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSString *dateString = [ActionManager stringFromDate:aDate];
    [self.tableValues replaceObjectAtIndex:3 withObject:dateString];
    [self saveTableValues];
    
    [self.tableView reloadData];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    
}

-(void)didSelectValue:(NSString *)value forIndexPath:(NSIndexPath *)indexPath {
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:value];
    [self saveTableValues];
}

-(void)selectedDestination:(NSString *)destination coordinate:(CLLocationCoordinate2D)coordinate indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        self.departureCoordinate = coordinate;
    } else if (indexPath.row == 2){
        self.destinationCoordinate = coordinate;
        [self fetchPhotoForDestinationCoordinate];
    }
    [self.tableValues replaceObjectAtIndex:indexPath.row withObject:destination];
    [self saveTableValues];
}


-(void)fetchPhotoForDestinationCoordinate {
    if (CLLocationCoordinate2DIsValid(self.destinationCoordinate)) {
        [[PanoramioUtilities sharedInstance] fetchPhotoForLocation:[[CLLocation alloc] initWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude] completionHandler:^(Photo *photo) {
            if (photo != nil) {
                [self setDestinationPhoto:photo];
            }
        }];
    }
}

-(void)setDestinationPhoto:(Photo *)photo {
    if (self.TableType == Driver) {
        self.destinationDriverPhotoInfo = photo;
    } else if(self.TableType == Passenger) {
        self.destinationPassengerPhotoInfo = photo;
    }
    UIImageView *headerImage = (UIImageView *)[self.headerView viewWithTag:10];
    NSURL *url = [NSURL URLWithString:photo.photoFileUrl];
    self.destinationImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    headerImage.image = self.destinationImage;
}

-(void)stepperValueChanged:(NSInteger)stepperValue {
    [self.tableValues replaceObjectAtIndex:5 withObject:[[NSNumber numberWithInt:(int)stepperValue] stringValue]];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    MenuViewController *menu = (MenuViewController *)self.sideBarController.leftDrawerViewController;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:2];
    [menu.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    [self.sideBarController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)segmentedControlChangedToIndex:(NSInteger)index segmentedControlId:(NSInteger)controlId{
    if (controlId == 0) { // driver or passenger
        [self saveTableValues];
        if (index == 0) {
            self.TableType = Passenger;
            
            UIImageView *headerImage = (UIImageView *)[self.headerView viewWithTag:10];
            NSURL *url = [NSURL URLWithString:self.destinationPassengerPhotoInfo.photoFileUrl];
            self.destinationImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if (self.destinationImage == nil) {
                self.destinationImage = [UIImage imageNamed:@"MainCampus.jpg"];
            }
            headerImage.image = self.destinationImage;
        } else {
            self.TableType = Driver;
            
            UIImageView *headerImage = (UIImageView *)[self.headerView viewWithTag:10];
            NSURL *url = [NSURL URLWithString:self.destinationDriverPhotoInfo.photoFileUrl];
            self.destinationImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if (self.destinationImage == nil) {
                self.destinationImage = [UIImage imageNamed:@"MainCampus.jpg"];
            }
            headerImage.image = self.destinationImage;
        }
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
        self.tableDriverValues = [NSMutableArray arrayWithArray:self.tableValues];
    } else {
        self.tablePassengerValues = [NSMutableArray arrayWithArray:self.tableValues];
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
}

-(void)didSelectRepeatDates:(NSArray *)repeatDates descriptionLabel:(NSString *)descriptionLabel selectedValues:(NSMutableDictionary *)selectedValues {
    self.selectedRepeatValues = selectedValues;
    self.repeatDates = repeatDates;
    if (repeatDates.count > 0) {
        NSString *dateString = [ActionManager stringFromDate:[repeatDates firstObject]];
        [self.tableValues replaceObjectAtIndex:3 withObject:dateString];
        [self.tableValues replaceObjectAtIndex:4 withObject:descriptionLabel];
    } else {
        [self.tableValues replaceObjectAtIndex:4 withObject:@"No"];
    }
    [self saveTableValues];
}

-(NSString *)stringForName:(CellName)paramName {
    __strong NSString **pointer = (NSString **)&kDriverRole;
    pointer += paramName;
    return *pointer;
}

@end
