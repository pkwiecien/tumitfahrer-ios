//
//  RideDetailViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/2/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideDetailViewController.h"
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
#import "HeaderContentView.h"
#import "RideDetailMapViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "RidesPageViewController.h"
#import "RideRequestInformationCell.h"

@interface RideDetailViewController () <NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, RideStoreDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) MKRoute *currentRoute;
@property (nonatomic, strong) MKPolyline *routeOverlay;

@property (strong, nonatomic) NSDictionary *backLinkInfo;
@property (weak, nonatomic) UIView *backLinkView;
@property (weak, nonatomic) UILabel *backLinkLabel;

@end

@implementation RideDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.rideDetail = [[HeaderContentView alloc] initWithFrame:self.view.bounds];
    self.rideDetail.tableViewDataSource = self;
    self.rideDetail.tableViewDelegate = self;
    self.rideDetail.parallaxScrollFactor = 0.3; // little slower than normal.
    [self.view addSubview:self.rideDetail];
    
    _headerView.backgroundColor = [UIColor darkerBlue];
    [self.view bringSubviewToFront:_headerView];
    [[RidesStore sharedStore] addObserver:self];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 22, 40, 40);
    [buttonBack setImage:[ActionManager colorImage:[UIImage imageNamed:@"ArrowLeft"]  withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    self.rideDetail.headerView = _headerView;
}

-(void)viewWillAppear:(BOOL)animated {
    self.rideDetail.selectedImageData = self.ride.destinationImage;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.headerViewLabel.text = [@"To " stringByAppendingString:self.ride.destination];
    [self printRequestsAndPassengers];
    [self prepareDirections];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.refererAppLink) {
        self.backLinkInfo = delegate.refererAppLink;
        [self _showBackLink];
    }
    delegate.refererAppLink = nil;
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.displayEnum == ShouldShareRideOnFacebook) {
        [self shareLinkWithShareDialog];
        self.displayEnum = ShouldDisplayNormally;
    }
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
        if (self.ride.driver == nil) {
            return 160.0f;
        }
        return 240.0f;
    }
    else if(indexPath.row == 3){
        return 170.0f;
    }
    else if(indexPath.row == 4) {
        return 100*(1+(self.ride.freeSeats-1)/3);
    }else
        return 100.0f; //cell for comments, in reality the height has to be adjustable
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.ride.driver == nil) {
        return 4; // it's a ride request, so don't show passengers
    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        RideNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideNoticeCell"];
        
        if(cell == nil){
            cell = [RideNoticeCell rideNoticeCell];
        }
        
        if (self.ride.driver == nil) {
            cell.noticeLabel.text = @"Ride Request";
        } else if(self.ride.rideType == 0) {
            cell.noticeLabel.text = @"Campus Ride";
        } else {
            cell.noticeLabel.text = @"Activity Ride";
        }
        return cell;
    }
    else if(indexPath.row == 1) {
        
        RideActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsMessagesChoiceCell"];
        
        if(cell == nil){
            cell = [RideActionCell detailsMessagesChoiceCell];
        }
        if (self.ride.driver == nil) {
            [cell.joinRideButton setTitle:@"Offer a ride" forState:UIControlStateNormal];
            [cell.contactDriverButton setTitle:@"Contact passenger" forState:UIControlStateNormal];
        } else {
            [self makeJoinButtonDescriptionForCell:cell];
        }
        cell.delegate = self;
        return cell;
    }
    else if(indexPath.row == 2) {
        if (self.ride.driver != nil) {
            RideInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideInformationCell"];
            if(cell == nil){
                cell = [RideInformationCell rideInformationCell];
            }
            cell.departurePlaceLabel.text = self.ride.departurePlace;
            cell.destinationLabel.text = self.ride.destination;
            cell.timeLabel.text = [ActionManager timeStringFromDate:self.ride.departureTime];
            cell.dateLabel.text = [ActionManager dateStringFromDate:self.ride.departureTime];
            if (self.ride.driver.car == nil) {
                cell.carLabel.text = @"Not specified";
            } else {
                cell.carLabel.text = self.ride.driver.car;
            }
            cell.informationLabel.text = self.ride.meetingPoint;
            
            return cell;
        } else {
            RideRequestInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RideRequestInformationCell"];
            if(cell == nil){
                cell = [RideRequestInformationCell rideRequestInformationCell];
            }
            cell.departurePlaceLabel.text = self.ride.departurePlace;
            cell.destinationLabel.text = self.ride.destination;
            cell.timeLabel.text = [ActionManager timeStringFromDate:self.ride.departureTime];
            cell.dateLabel.text = [ActionManager dateStringFromDate:self.ride.departureTime];
            
            return cell;
        }
    } else if(indexPath.row == 3) {
        if(self.ride.driver == nil) {
            DriverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DriverCell"];
            if (cell == nil) {
                cell = [DriverCell driverCell];
            }
            
            //            cell.driverNameLabel.text = self.ride.req.firstName;
            //            cell.driverRatingLabel.text = [NSString stringWithFormat:@"%.01f", [self.ride.driver.ratingAvg floatValue]];
            
            cell.mapView.delegate = self;
            UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTap)];
            // Set required taps and number of touches
            [mapTap setNumberOfTapsRequired:1];
            [mapTap setNumberOfTouchesRequired:1];
            // Add the gesture to the view
            [cell.mapView addGestureRecognizer:mapTap];
            self.map = cell.mapView;
            
            return cell;
        } else {
            DriverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DriverCell"];
            if (cell == nil) {
                cell = [DriverCell driverCell];
            }
            cell.driverNameLabel.text = self.ride.driver.firstName;
            cell.driverRatingLabel.text = [NSString stringWithFormat:@"%.01f", [self.ride.driver.ratingAvg floatValue]];
            
            cell.mapView.delegate = self;
            UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTap)];
            // Set required taps and number of touches
            [mapTap setNumberOfTapsRequired:1];
            [mapTap setNumberOfTouchesRequired:1];
            // Add the gesture to the view
            [cell.mapView addGestureRecognizer:mapTap];
            self.map = cell.mapView;
            
            return cell;
        }
    } else if(indexPath.row == 4 && self.ride.driver != nil) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - LocationDetailViewDelegate

#pragma mark - Button actions

- (void)back {
    if (self.shouldGoBackEnum == GoBackNormally) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.ride.rideType == ContentTypeCampusRides) {
            RidesPageViewController *campusRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeCampusRides];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:campusRidesVC];
            [self.sideBarController setCenterViewController:navController  withCloseAnimation:YES completion:nil];
        } else {
            RidesPageViewController *activityRidesVC = [[RidesPageViewController alloc] initWithContentType:ContentTypeActivityRides];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:activityRidesVC];
            [self.sideBarController setCenterViewController:navController withCloseAnimation:YES completion:nil];
        }
    }
}

-(void)contactDriverButtonPressed {
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)joinRideButtonPressed {
    // check if the user is not trying to send a request to himself
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    Request *request = [self requestFoundInCoreData];
    
    if ([self.ride.driver.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
        [objectManager deleteObject:self.ride path:[NSString stringWithFormat:@"/api/v2/rides/%d", self.ride.rideId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            [[CurrentUser sharedInstance].user removeRidesAsDriverObject:self.ride];
            [[RidesStore sharedStore] deleteRideFromCoreData:self.ride];
            [[RidesStore sharedStore] fetchRidesFromCoreDataByType:ContentTypeCampusRides];
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            RKLogError(@"Load failed with error: %@", error);
        }];
    } else if(request != nil) {
        [objectManager deleteObject:request path:[NSString stringWithFormat:@"/api/v2/rides/%d/requests/%d", self.ride.rideId, [request.requestId intValue]] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            [KGStatusBar showSuccessWithStatus:@"Request canceled"];
            
            [self.ride removeRequestsObject:request];
            [[RidesStore sharedStore] deleteRideRequestFromCoreData:request];
            
            [self.rideDetail.tableView reloadData];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            RKLogError(@"Load failed with error: %@", error);
        }];
    } else if(self.ride.driver == nil) {
        
    } else {
        NSDictionary *queryParams;
        // add enum
        NSString *userId = [NSString stringWithFormat:@"%@", [CurrentUser sharedInstance].user.userId];
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
    if([self.ride.driver.userId isEqualToNumber:[CurrentUser sharedInstance].user.userId]) {
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    
    return  renderer;
}

-(void)mapViewTap {
    RideDetailMapViewController *rideDetailMapVC = [[RideDetailMapViewController alloc] init];
    rideDetailMapVC.selectedRide = self.ride;
    [self.navigationController pushViewController:rideDetailMapVC animated:YES];
}


#pragma mark - delegate methods of RidesStore
-(void)didRecieveRidesFromWebService:(NSArray *)rides {
    
}

-(void)didReceivePhotoForRide:(NSInteger)rideId {
    
    self.ride = [[RidesStore sharedStore] getRideWithId:rideId];
    if (self.ride.destinationImage == nil) {
        NSLog(@"destination image is null");
    } else
    {
        NSLog(@"destination image is not null");
    }
    UIImage *img = [UIImage imageWithData:self.ride.destinationImage];
    [self.rideDetail.rideDetailHeaderView replaceMainImage:img];
}


#pragma mark - Facebook sharing methods

//------------------Sharing a link using the share dialog------------------
- (void)shareLinkWithShareDialog
{
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSString *caption = [NSString stringWithFormat:@"TUMitfahrer - carsharing platform for students"];
        NSString *departurePlaceName  = [self.ride.departurePlace componentsSeparatedByString: @","][0];
        NSString *destinationName  = [self.ride.destination componentsSeparatedByString: @","][0];
        
        NSString *description = [NSString stringWithFormat:@"I've just created a ride from %@ to %@, on %@. Join me!", departurePlaceName, destinationName, [ActionManager stringFromDate:self.ride.departureTime]];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"TUMitfaher", @"name",
                                       caption, @"caption",
                                       description, @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"https://raw.githubusercontent.com/pkwiecien/tumitfahrer/develop/public/TUMitfahrer-logo-small.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

//------------------------------------




//------------------------------------

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

//------------------------------------

//------------------Handling links back to app link launching app------------------

- (void) _showBackLink {
    if (nil == self.backLinkView) {
        // Set up the view
        UIView *backLinkView = [[UIView alloc] initWithFrame:
                                CGRectMake(0, 30, 320, 40)];
        backLinkView.backgroundColor = [UIColor darkGrayColor];
        UILabel *backLinkLabel = [[UILabel alloc] initWithFrame:
                                  CGRectMake(2, 2, 316, 36)];
        backLinkLabel.textColor = [UIColor whiteColor];
        backLinkLabel.textAlignment = NSTextAlignmentCenter;
        backLinkLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        [backLinkView addSubview:backLinkLabel];
        self.backLinkLabel = backLinkLabel;
        [self.view addSubview:backLinkView];
        self.backLinkView = backLinkView;
    }
    // Show the view
    self.backLinkView.hidden = NO;
    // Set up the back link label display
    self.backLinkLabel.text = [NSString
                               stringWithFormat:@"Touch to return to %@", self.backLinkInfo[@"app_name"]];
    // Set up so the view can be clicked
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(_returnToLaunchingApp:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.backLinkView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}

- (void)_returnToLaunchingApp:(id)sender {
    // Open the app corresponding to the back link
    NSURL *backLinkURL = [NSURL URLWithString:self.backLinkInfo[@"url"]];
    if ([[UIApplication sharedApplication] canOpenURL:backLinkURL]) {
        [[UIApplication sharedApplication] openURL:backLinkURL];
    }
    self.backLinkView.hidden = YES;
}



@end
