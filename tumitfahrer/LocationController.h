//
//  LocationController.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/9/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  Protocol that notifies if the location is fetched.
 */
@protocol LocationControllerDelegate <NSObject>

@optional

/**
 *  Notify about fetching the current's user location.
 *
 *  @param location Fetched location.
 */
- (void)didReceiveCurrentLocation: (CLLocation*)location;

/**
 *  Notify about fetching location for the given ride.
 *
 *  @param location Fetched location
 *  @param rideId   Id of the ride.
 */
- (void)didReceiveLocationForAddress: (CLLocation*)location rideId:(NSNumber *)rideId;

@end

/**
 *  Class that handles fetching location and initializing fetching photos based on the location.
 */
@interface LocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation; // todo add getting network location
@property (nonatomic, strong) UIImage *currentLocationImage;
@property (nonatomic, strong) NSString *currentAddress;

/**
 *  The singleton object
 *
 *  @return shared object
 */
+ (LocationController*)sharedInstance; // Singleton method

typedef void(^locationAndUrlCompletionHandler)(CLLocation *, NSURL *);
typedef void(^locationCompletionHandler)(CLLocation *);

/**
 *  Fetches location for the string with address.
 *
 *  @param address String with address
 *  @param rideId  Id of the ride that contains this address.
 */
- (void)fetchLocationForAddress:(NSString *)address rideId:(NSNumber *)rideId;

/**
 *  Asynchronously fetches location for the given address.
 *
 *  @param address String with address
 *  @param block   The completion handler.
 */
- (void)fetchLocationForAddress:(NSString *)address completionHandler:(locationCompletionHandler)block;

/**
 *  Starts getting current location.
 */
- (void)startUpdatingLocation;

/**
 *  Adds observer to the Location controller.
 *
 *  @param observer The Observer object.
 */
- (void)addObserver:(id<LocationControllerDelegate>) observer;
/**
 *  Notifies observers about fetching the current location.
 */
- (void)notifyAllAboutNewCurrentLocation;
/**
 *  Notify observers about fetching the location for the ride.
 *
 *  @param location Fetched location
 *  @param rideId   Id of the ride.
 */
- (void)notifyAllAboutNewLocation:(CLLocation*)location rideWithRideId:(NSNumber *)rideId;
/**
 *  Removes observer from the Location Controller.
 *
 *  @param observer The Observer object.
 */
- (void)removeObserver:(id<LocationControllerDelegate>)observer;

/**
 *  Checks whether distance between two locations is within the given threshold.
 *
 *  @param location          First Location
 *  @param anotherLocation   Second Location
 *  @param thresholdInMeters Threshold in meters
 *
 *  @return True if distance is within threshold.
 */
+ (BOOL)isLocation:(CLLocation *)location nearbyAnotherLocation:(CLLocation *)anotherLocation thresholdInMeters:(NSInteger)thresholdInMeters;
/**
 *  Gets location object from longitude and latitude.
 *
 *  @param longitude Double with longitude
 *  @param latitude  Double with latitude
 *
 *  @return Location object.
 */
+ (CLLocation *)locationFromLongitude:(double)longitude latitude:(double)latitude;

typedef void (^PlacemarkBlock)(CLPlacemark *placemark, NSError *error);
/**
 *  Return placemark from the given address.
 *
 *  @param block   The completion handler with the Placemark.
 *  @param address String with address.
 */
+ (void)resolveGecodePlaceToPlacemark:(PlacemarkBlock)block address:(NSString *)address;
/**
 *  Checks whether location services are enabled.
 *
 *  @return True if enabled.
 */
+ (BOOL)locationServicesEnabled;

@end
