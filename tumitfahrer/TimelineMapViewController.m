//
//  TimlineMapViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/14/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TimelineMapViewController.h"
#import "NavigationBarUtilities.h"
#import "CustomAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "ActivityStore.h"
#import "Ride.h"
#import "ActionManager.h"
#import "RideDetailViewController.h"
#import "Request.h"
#import "RidesStore.h"
#import "RideSearch.h"

@interface TimelineMapViewController ()

typedef enum {
    Departure = 0,
    Destination = 1
} LocationTypeEnum;

@property (nonatomic, strong) UISegmentedControl *navBarSegmentedControl;
@property (nonatomic, assign) LocationTypeEnum locationTypeEnum;

@end

@implementation TimelineMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.locationTypeEnum = Departure;
    
    [self addSegmentedControlToNavBar];
    [self initAnnotations];
}

-(void)addSegmentedControlToNavBar {
    self.navBarSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Departure", @"Destination", nil]];
    [self.navBarSegmentedControl sizeToFit];
    self.navBarSegmentedControl.selectedSegmentIndex = 0;
    [self.navBarSegmentedControl addTarget:self action:@selector(segmentedControlChanged) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.navBarSegmentedControl;
}

-(void)initAnnotations {
    for (id result in [[ActivityStore sharedStore] recentActivitiesByType:self.contentType]) {
        if ([result isKindOfClass:[Ride class]]) {
            Ride *ride = (Ride *)result;
            if (ride != nil) {
                [self.mapView addAnnotation:[self createAnnotationWithRide:ride title:nil]];
            }
        } else if ([result isKindOfClass:[Request class]]) {
            Request *request = (Request *)result;
            Ride *ride = [[RidesStore sharedStore] containsRideWithId:request.rideId];
            if (ride != nil) {
                [self.mapView addAnnotation:[self createAnnotationWithRide:ride title:@"Ride Request"]];
            }
            // TODO fetch ride from core data/webservice if not exist
        } else if([result isKindOfClass:[RideSearch class]]) {
            RideSearch *rideSearch = (RideSearch *)result;
            if (self.locationTypeEnum == Destination) {
                if ([rideSearch.destinationLatitude doubleValue] == 0 || [rideSearch.destinationLongitude doubleValue] == 0) {
                    [[LocationController sharedInstance] fetchLocationForAddress:rideSearch.destination completionHandler:^(CLLocation *location) {
                        rideSearch.destinationLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
                        rideSearch.destinationLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                        [self.mapView addAnnotation:[self createAnnotationWithRideSearch:rideSearch title:@"Ride Search"]];
                        
                    }];
                } else {
                    [self.mapView addAnnotation:[self createAnnotationWithRideSearch:rideSearch title:@"Ride Search"]];
                }
            } else {
                if ([rideSearch.departureLongitude doubleValue] == 0 || [rideSearch.departureLongitude doubleValue] == 0) {
                    [[LocationController sharedInstance] fetchLocationForAddress:rideSearch.departurePlace completionHandler:^(CLLocation *location) {
                        rideSearch.departureLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
                        rideSearch.departureLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                        [self.mapView addAnnotation:[self createAnnotationWithRideSearch:rideSearch title:@"Ride Search"]];
                    }];
                } else {
                    [self.mapView addAnnotation:[self createAnnotationWithRideSearch:rideSearch title:@"Ride Search"]];
                }
            }
        }
    }
    [self zoomToFitMapAnnotations:self.mapView];
}

-(void)removeAllAnnoations {
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (CustomAnnotation *)createAnnotationWithRide:(Ride *)ride title:(NSString *)title {
    //Create Annotation
    CustomAnnotation *rideAnnotation = [[CustomAnnotation alloc] init];
    if (title!=nil) {
        rideAnnotation.title = title;
    } else if (ride.rideType == 0) {
        rideAnnotation.title = @"Campus Ride";
    } else {
        rideAnnotation.title = @"Activity Ride";
    }
    if (self.locationTypeEnum == Departure) {
        NSString *depart = [[ride.departurePlace componentsSeparatedByString:@","] firstObject];
        rideAnnotation.subtitle = [NSString stringWithFormat:@"Ride from %@\nOn %@", depart, [ActionManager dateStringFromDate:ride.departureTime]];
        rideAnnotation.coordinate = CLLocationCoordinate2DMake([ride.departureLatitude doubleValue], [ride.departureLongitude doubleValue]);
        
    } else {
        NSString *dest = [[ride.destination componentsSeparatedByString:@","] firstObject];
        rideAnnotation.subtitle = [NSString stringWithFormat:@"Ride to %@\nOn %@", dest, [ActionManager dateStringFromDate:ride.departureTime]];
        rideAnnotation.coordinate = CLLocationCoordinate2DMake([ride.destinationLatitude doubleValue], [ride.destinationLongitude doubleValue]);
    }
    rideAnnotation.annotationObject = ride;
    return rideAnnotation;
}


-(CustomAnnotation *)createAnnotationWithRideSearch:(RideSearch *)rideSearch title:(NSString *)title {
    CustomAnnotation *rideAnnotation = [[CustomAnnotation alloc] init];
    if (title!=nil) {
        rideAnnotation.title = title;
    }
    if (self.locationTypeEnum == Departure) {
        NSString *dest = [[rideSearch.departurePlace componentsSeparatedByString:@","] firstObject];
        rideAnnotation.subtitle = [NSString stringWithFormat:@"Ride search from %@\nOn %@", dest, [ActionManager dateStringFromDate:rideSearch.departureTime]];
        rideAnnotation.coordinate = CLLocationCoordinate2DMake([rideSearch.departureLatitude doubleValue], [rideSearch.departureLongitude doubleValue]);
    } else {
        NSString *dest = [[rideSearch.destination componentsSeparatedByString:@","] firstObject];
        rideAnnotation.subtitle = [NSString stringWithFormat:@"Ride search to %@\nOn %@", dest, [ActionManager dateStringFromDate:rideSearch.departureTime]];
        rideAnnotation.coordinate = CLLocationCoordinate2DMake([rideSearch.destinationLatitude doubleValue], [rideSearch.destinationLongitude doubleValue]);
    }
    
    return rideAnnotation;
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
}

-(void)setupNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navController = self.navigationController;
    [NavigationBarUtilities setupNavbar:&navController withColor:[UIColor darkestBlue]];
    self.title = @"Timeline Map";
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
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        return customPinView;
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}

-(void)showDetails {
    CustomAnnotation *result = (CustomAnnotation *)[[self.mapView selectedAnnotations] firstObject];
    
    if ([result.annotationObject isKindOfClass:[Ride class]]) {
        RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
        rideDetailVC.ride = (Ride *)result.annotationObject;
        [self.navigationController pushViewController:rideDetailVC animated:YES];
    } else if([result.annotationObject isKindOfClass:[Request class]]) {
        Request *res = (Request *)result.annotationObject;
        Ride *ride = [[RidesStore sharedStore] containsRideWithId:res.rideId];
        if (ride != nil) {
            res.requestedRide = ride;
            RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
            rideDetailVC.ride = ride;
            [self.navigationController pushViewController:rideDetailVC animated:YES];
        } else {
            [[RidesStore sharedStore] fetchSingleRideFromWebserviceWithId:res.rideId block:^(BOOL completed) {
                if(completed) {
                    RideDetailViewController *rideDetailVC = [[RideDetailViewController alloc] init];
                    Ride *ride = [[RidesStore sharedStore] fetchRideFromCoreDataWithId:res.rideId];
                    rideDetailVC.ride = ride;
                    [self.navigationController pushViewController:rideDetailVC animated:YES];
                }
            }];
        }
    }
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

-(void)segmentedControlChanged {
    if([self.navBarSegmentedControl selectedSegmentIndex] == 0) {
        self.locationTypeEnum = Departure;
    } else {
        self.locationTypeEnum = Destination;
    }
    
    [self removeAllAnnoations];
    [self initAnnotations];
}

@end
