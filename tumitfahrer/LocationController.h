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
@property (nonatomic, strong) UIImage *currentLocationImage;
@property (nonatomic, strong) NSString *currentAddress;

+ (LocationController*)sharedInstance; // Singleton method

typedef void(^locationAndUrlCompletionHandler)(CLLocation *, NSURL *);
typedef void(^locationCompletionHandler)(CLLocation *);

- (void)fetchLocationForAddress:(NSString *)address rideId:(NSInteger)rideId;
- (void)fetchPhotoURLForAddress:(NSString *)address rideId:(NSInteger)rideId completionHandler:(locationAndUrlCompletionHandler)block;
- (void)fetchLocationForAddress:(NSString *)address completionHandler:(locationCompletionHandler)block;

- (void)startUpdatingLocation;
- (void)addObserver:(id<LocationControllerDelegate>) observer;
- (void)notifyAllAboutNewCurrentLocation;
- (void)notifyAllAboutNewLocation:(CLLocation*)location rideWithRideId:(NSInteger)rideId;
- (void)removeObserver:(id<LocationControllerDelegate>)observer;

+ (BOOL)isLocation:(CLLocation *)location nearbyAnotherLocation:(CLLocation *)anotherLocation;
+ (CLLocation *)locationFromLongitude:(double)longitude latitude:(double)latitude;

@end
