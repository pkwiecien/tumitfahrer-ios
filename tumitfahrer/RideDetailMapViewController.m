//
//  RideDetailMapViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/20/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideDetailMapViewController.h"
#import "NavigationBarUtilities.h"
#import "Ride.h"

@interface RideDetailMapViewController ()

@property (nonatomic, strong) MKRoute *currentRoute;
@property (nonatomic, strong) MKPolyline *routeOverlay;

@end

@implementation RideDetailMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self prepareDirections];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor darkerBlue]];
    self.title = @"Ride Detail Map";
}

- (void)prepareDirections {
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    
    // Make the destination
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(self.selectedRide.destinationLatitude, self.selectedRide.destinationLongitude);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.selectedRide.departurePlace completionHandler:^(NSArray* placemarks, NSError* error){
        
        CLPlacemark *aPlacemark = [placemarks firstObject];
        
        // Make the destination
        CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude, aPlacemark.location.coordinate.longitude);
        MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
        MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
        [self.mapView setCenterCoordinate:sourceCoords];
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

- (void)plotRouteOnMap:(MKRoute *)route {
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    
    CLLocationCoordinate2D track = CLLocationCoordinate2DMake(self.selectedRide.departureLatitude, self.selectedRide.departureLongitude);
    MKCoordinateRegion region;
    MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
    region.span = span;
    region.center = track;
    
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    
    return  renderer;
}

@end
