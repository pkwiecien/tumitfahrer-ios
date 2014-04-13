//
//  LocationController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "LocationController.h"

@interface LocationController ()

@property (nonatomic) BOOL isLocationFetched;
@property (nonatomic, strong) NSMutableArray *observers;

@end

@implementation LocationController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.isLocationFetched = NO;
        self.observers = [[NSMutableArray alloc] init];
    }
    return self;
}

+(LocationController *)sharedInstance {
    static LocationController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

# pragma mark - observer methods
-(void)addObserver:(id<LocationControllerDelegate>)observer {
    [self.observers addObject:observer];
}

-(void)notifyAll {
    for (id<LocationControllerDelegate> observer in self.observers) {
        [observer didReceiveCurrentLocation:self.currentLocation];
    }
}

-(void)removeObserver:(id<LocationControllerDelegate>)observer {
    [self.observers removeObject:observer];
}

#pragma mark - location utilities

- (void)startUpdatingLocation {
    self.isLocationFetched = NO;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!self.isLocationFetched) {
        self.currentLocation = [locations lastObject];
        self.isLocationFetched = YES;
        [self notifyAll];
    }
    [self.locationManager stopUpdatingLocation];
}

# pragma mark - general functions

- (void)fetchLocationForAddress:(NSString *)address rideId:(NSInteger)rideId {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        
        //        for (CLPlacemark* aPlacemark in placemarks)
        CLPlacemark *aPlacemark = [placemarks firstObject];
        
        // Process the placemark.
        NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
        NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
        NSLog(@"Coordinates: %@ %@", latDest1, lngDest1);
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:aPlacemark.location.coordinate.latitude longitude:aPlacemark.location.coordinate.longitude];
    }];
}

@end
