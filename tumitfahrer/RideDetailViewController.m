//
//  RideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideDetailViewController.h"
#import "RideDetailView.h"
#import "RideInformationCell.h"
#import "PassengersCell.h"
#import "DriverCell.h"
#import "ChatViewController.h"
#import "ActionManager.h"
#import "User.h"
#import "Request.h"
#import "CurrentUser.h"
#import "KGStatusBar.h"
#import "Ride.h"
#import "RidesStore.h"
#import "RideNoticeCell.h"

@interface RideDetailViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) MKRoute *currentRoute;
@property (nonatomic, strong) MKPolyline *routeOverlay;

@end

@implementation RideDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.rideDetail = [[RideDetailView alloc] initWithFrame:self.view.bounds];
    self.rideDetail.tableViewDataSource = self;
    self.rideDetail.tableViewDelegate = self;
    
    self.rideDetail.parallaxScrollFactor = 0.3; // little slower than normal.
    
    [self.view addSubview:self.rideDetail];
    
    UIImage *croppedImage = [ActionManager cropImage:[UIImage imageNamed:@"gradientBackground"] newRect:CGRectMake(0, 0, 320, 65)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:croppedImage];
    imgView.frame = CGRectMake(0, 0, 320, 65);
    _headerView.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:imgView];
    [_headerView sendSubviewToBack:imgView];
    [self.view bringSubviewToFront:_headerView];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 22, 40, 40);
    [buttonBack setImage:[UIImage imageNamed:@"ArrowLeft"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    self.rideDetail.headerView = _headerView;
}

-(void)viewWillAppear:(BOOL)animated {
    self.rideDetail.selectedRide = self.ride;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
    [self printRequestsAndPassengers];
    [self prepareDirections];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 44.0f;
    }
    else if(indexPath.row == 1){
        return 44.0f;
    }
    else if(indexPath.row == 2){
        return 159.0f;
    }
    else if(indexPath.row == 3){
        return 120.0f;
    }
    else if(indexPath.row == 4) {
        //        return 124.0f*(1+(7-1)/3);
        return 100*(1+(self.ride.freeSeats-1)/3);
    }else
        return 100.0f; //cell for comments, in reality the height has to be adjustable
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        RideNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideNoticeCell"];
        
        if(cell == nil){
            cell = [RideNoticeCell rideNoticeCell];
        }
        
        if(self.ride.driver.userId == [CurrentUser sharedInstance].user.userId) {
            cell.noticeLabel.text = @"You are the driver";
        }
        else {
            cell.noticeLabel.text = @"Send ride request to the driver";
        }
        return cell;
    }
    else if(indexPath.row == 1) {
        
        RideActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsMessagesChoiceCell"];
        
        if(cell == nil){
            cell = [RideActionCell detailsMessagesChoiceCell];
        }
        
        [self makeJoinButtonDescriptionForCell:cell];
        
        cell.delegate = self;
        return cell;
    }
    else if(indexPath.row == 2) {
        RideInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideInformationCell"];
        if(cell == nil){
            cell = [RideInformationCell rideInformationCell];
        }
        cell.departurePlaceLabel.text = self.ride.departurePlace;
        cell.destinationLabel.text = self.ride.destination;
        cell.timeLabel.text = [ActionManager stringFromDate:self.ride.departureTime];
        cell.mapView.delegate = self;
        self.map = cell.mapView;
        
        return cell;
    } else if(indexPath.row == 3) {
        DriverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DriverCell"];
        if (cell == nil) {
            cell = [DriverCell driverCell];
        }
        
        cell.driverNameLabel.text = self.ride.driver.firstName;
        cell.driverRatingLabel.text = [NSString stringWithFormat:@"%.01f", [self.ride.driver.ratingAvg floatValue]];
        if (self.ride.driver.car == nil || [self.ride.driver.car isEqualToString:@""]) {
            cell.carLabel.text = @"Not specified";
        } else {
            cell.carLabel.text = self.ride.driver.car;
        }
        return cell;
    } else if(indexPath.row == 4) {
        PassengersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PassengersCell"];
        if (cell == nil) {
            cell = [PassengersCell passengersCell];
        }
        [cell drawCirlesWithPassengersNumber:[self.ride.passengers count] freeSeats:self.ride.freeSeats];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
        }
        
        cell.textLabel.text = @"Default cell";
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - LocationDetailViewDelegate

#pragma mark - MKMap View methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *MyPinAnnotationIdentifier = @"Pin";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier:MyPinAnnotationIdentifier];
    if (!pinView){
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:MyPinAnnotationIdentifier];
        
        annotationView.image = [UIImage imageNamed:@"pin_map_blue"];
        
        return annotationView;
        
    }else{
        
        pinView.image = [UIImage imageNamed:@"pin_map_blue"];
        
        return pinView;
    }
    
    return nil;
}

#pragma mark - Button actions

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)contactDriverButtonPressed {
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)joinRideButtonPressed {
    // check if the user is not trying to send a request to himself
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    Request *request = [self requestFoundInCoreData];

    if (self.ride.driver.userId == [CurrentUser sharedInstance].user.userId) {
        [objectManager deleteObject:self.ride path:[NSString stringWithFormat:@"/api/v2/rides/%d", self.ride.rideId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            [[CurrentUser sharedInstance].user removeRidesAsDriverObject:self.ride];
            [[RidesStore sharedStore] deleteRideFromCoreData:self.ride];
            [[RidesStore sharedStore] fetchRidesFromCoreDataByType:ContentTypeCampusRides];
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            RKLogError(@"Load failed with error: %@", error);
        }];
    } else if(request != nil) {
        [objectManager deleteObject:request path:[NSString stringWithFormat:@"/api/v2/rides/%d/requests/%d", self.ride.rideId, request.requestId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

            [KGStatusBar showSuccessWithStatus:@"Request canceled"];
            
            [self.ride removeRequestsObject:request];
            [[RidesStore sharedStore] deleteRideRequestFromCoreData:request];
            
            [self.rideDetail.tableView reloadData];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            RKLogError(@"Load failed with error: %@", error);
        }];
    } else {
        NSDictionary *queryParams;
        // add enum
        NSString *userId = [NSString stringWithFormat:@"%d", [CurrentUser sharedInstance].user.userId];
        queryParams = @{@"passenger_id": userId, @"requested_from": self.ride.departurePlace, @"request_to":self.ride.destination};
        NSDictionary *requestParams = @{@"request": queryParams};
        
        [objectManager postObject:nil path:[NSString stringWithFormat:@"/api/v2/rides/%d/requests", self.ride.rideId] parameters:requestParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [KGStatusBar showSuccessWithStatus:@"Request was sent"];
            Request *rideRequest = (Request *)[mappingResult firstObject];
          //  [[RidesStore sharedStore] addRideToUserRequests:ride];
            NSLog(@"Ride request: %@", rideRequest);
            [self.ride addRequestsObject:rideRequest];
            [self.rideDetail.tableView reloadData];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [ActionManager showAlertViewWithTitle:[error localizedDescription]];
            RKLogError(@"Load failed with error: %@", error);
        }];
    }
}

-(NSFetchedResultsController *)fetchedResultsController {
    if (self.fetchedResultsController != nil) {
        return self.fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Request"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[RKManagedObjectStore defaultStore].
                                     mainQueueManagedObjectContext
                                     sectionNameKeyPath:nil cacheName:@"Request"];
    self.fetchedResultsController.delegate = self;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        [ActionManager showAlertViewWithTitle:[error localizedDescription]];
    }
    
    return self.fetchedResultsController;
}

- (void)printRequestsAndPassengers {
    NSLog(@"Number of passengers: %d", (int)[self.ride.passengers count]);
    for (User *user in [self.ride passengers]) {
        NSLog(@"User: %@", user);
    }
    
    NSLog(@"Number of requests: %d", (int)[self.ride.requests count]);
    for (Request *reques in [self.ride requests]) {
        NSLog(@"Request: %@", reques);
    }
}

-(Request *)requestFoundInCoreData {
    for (Request *request in self.ride.requests) {
        if (request.passengerId == [CurrentUser sharedInstance].user.userId) {
            return request;
        }
    }
    return nil;
}

-(void)makeJoinButtonDescriptionForCell:(RideActionCell *)cell{
    if(self.ride.driver.userId == [CurrentUser sharedInstance].user.userId) {
        [cell.joinRideButton setTitle:@"Delete ride" forState:UIControlStateNormal];
    } else if([self requestFoundInCoreData] != nil) {
        [cell.joinRideButton setTitle:@"Cancel request" forState:UIControlStateNormal];
    } else {
        [cell.joinRideButton setTitle:@"Join ride" forState:UIControlStateNormal];
    }
}

#pragma mark - map view methods

// method from: https://github.com/ShinobiControls/iOS7-day-by-day/blob/master/13-mapkit-directions/13-mapkit-directions.md

- (void)prepareDirections {
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];

    // Make the destination
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(self.ride.destinationLatitude, self.ride.destinationLongitude);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.ride.departurePlace completionHandler:^(NSArray* placemarks, NSError* error){
        
        CLPlacemark *aPlacemark = [placemarks firstObject];
                
        // Make the destination
        CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude, aPlacemark.location.coordinate.longitude);
        MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
        MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
        [self.map setCenterCoordinate:sourceCoords];
        // Set the source and destination on the request
        [directionsRequest setSource:source];
        [directionsRequest setDestination:destination];
        
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            // Now handle the result
            if (error) {
                NSLog(@"There was an error getting your directions");
                return;
            }
            
            // So there wasn't an error - let's plot those routes
            _currentRoute = [response.routes firstObject];
            [self plotRouteOnMap:_currentRoute];
        }];
    }];
}

- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.map removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.map addOverlay:_routeOverlay];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;

    return  renderer;
}


@end
