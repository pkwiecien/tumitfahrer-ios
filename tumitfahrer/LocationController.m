//
//  LocationController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "LocationController.h"

@interface LocationController ()

@property (nonatomic) BOOL hasReturnedLocation;

@end

@implementation LocationController

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.hasReturnedLocation = NO;
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

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
    self.hasReturnedLocation = NO;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.hasReturnedLocation) {
        self.location = [locations lastObject];
        self.hasReturnedLocation = YES;
        [self.delegate didReceiveLocation:self.location];
    }
    
    [self.locationManager stopUpdatingLocation];
}

@end
