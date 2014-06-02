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
#import "CustomAnnotation.h"
#import <CoreLocation/CoreLocation.h>

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
    
    CustomAnnotation *departureAnnotation = [self createAnnotationWithCoordinates:CLLocationCoordinate2DMake(self.selectedRide.departureLatitude, self.selectedRide.departureLongitude) title:@"Departure"];
    CustomAnnotation *destinationAnnotation = [self createAnnotationWithCoordinates:CLLocationCoordinate2DMake(self.selectedRide.destinationLatitude, self.selectedRide.destinationLongitude) title:@"Destination"];
    
    [self.mapView addAnnotation:departureAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

- (CustomAnnotation *)createAnnotationWithCoordinates:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    CustomAnnotation *rideAnnotation = [[CustomAnnotation alloc] init];
    rideAnnotation.title = title;
    rideAnnotation.coordinate = coordinate;
    return rideAnnotation;
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self prepareDirections];
}

-(void)viewDidAppear:(BOOL)animated {
    [self zoomToFitMapAnnotations:self.mapView];
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
    
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *pinIdentifier = @"pinIndentifier";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    if (pinView == nil)
    {
        // if an existing pin view was not available, create one
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        customPinView.pinColor = MKPinAnnotationColorRed;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        return customPinView;
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    // Add extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.4;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

-(void)dealloc {
    self.mapView.delegate = nil;
}

@end
