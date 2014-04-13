//
//  LocationController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationControllerDelegate <NSObject>

@optional

- (void)didReceiveCurrentLocation: (CLLocation*)location;
- (void)didReceiveLocationForAddress: (CLLocation*)location rideId:(NSInteger)rideId;

@end

@interface LocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) UIImage *locationImage;

+ (LocationController*)sharedInstance; // Singleton method

- (void)fetchLocationForAddress:(NSString *)address rideId:(NSInteger)rideId;
- (void)startUpdatingLocation;
- (void)addObserver:(id<LocationControllerDelegate>) observer;
- (void)notifyAll;
- (void)removeObserver:(id<LocationControllerDelegate>)observer;

@end
