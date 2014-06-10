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
    
    for (id result in [[ActivityStore sharedStore] recentActivitiesByType:AllActivity]) {
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
        } else if([result isKindOfClass:[Request class]]) {
            RideSearch *rideSearch = (RideSearch *)result;
            [self.mapView addAnnotation:[self createAnnotationWithRideSearch:rideSearch title:@"Ride Search"]];
        }
    }
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
    NSString *dest = [[ride.destination componentsSeparatedByString:@","] firstObject];
    //NSString *depart = [[ride.departurePlace componentsSeparatedByString:@", "] firstObject];
    rideAnnotation.subtitle = [NSString stringWithFormat:@"Ride to %@\nOn %@", dest, [ActionManager dateStringFromDate:ride.departureTime]];
    rideAnnotation.coordinate = CLLocationCoordinate2DMake([ride.destinationLatitude doubleValue], [ride.destinationLongitude doubleValue]);
    rideAnnotation.annotationObject = ride;
    return rideAnnotation;
}


-(CustomAnnotation *)createAnnotationWithRideSearch:(RideSearch *)rideSearch title:(NSString *)title {
    CustomAnnotation *rideAnnotation = [[CustomAnnotation alloc] init];
    if (title!=nil) {
        rideAnnotation.title = title;
    }
    NSString *dest = [[rideSearch.destination componentsSeparatedByString:@","] firstObject];
    //NSString *depart = [[ride.departurePlace componentsSeparatedByString:@", "] firstObject];
    rideAnnotation.subtitle = [NSString stringWithFormat:@"Ride search to %@\nOn %@", dest, [ActionManager dateStringFromDate:rideSearch.departureTime]];
    rideAnnotation.coordinate = CLLocationCoordinate2DMake([rideSearch.destinationLatitude doubleValue], [rideSearch.destinationLongitude doubleValue]);

    return rideAnnotation;
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
    [self zoomToFitMapAnnotations:self.mapView];
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

@end
