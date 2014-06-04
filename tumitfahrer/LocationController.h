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
- (void)didReceiveLocationForAddress: (CLLocation*)location rideId:(NSNumber *)rideId;

@end

@interface LocationController : NSObject <CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation; // todo add getting network location
@property (nonatomic, strong) UIImage *currentLocationImage;
@property (nonatomic, strong) NSString *currentAddress;

+ (LocationController*)sharedInstance; // Singleton method

typedef void(^locationAndUrlCompletionHandler)(CLLocation *, NSURL *);
typedef void(^locationCompletionHandler)(CLLocation *);

- (void)fetchLocationForAddress:(NSString *)address rideId:(NSNumber *)rideId;
- (void)fetchPhotoURLForAddress:(NSString *)address rideId:(NSNumber *)rideId completionHandler:(locationAndUrlCompletionHandler)block;
- (void)fetchLocationForAddress:(NSString *)address completionHandler:(locationCompletionHandler)block;

- (void)startUpdatingLocation;
- (void)addObserver:(id<LocationControllerDelegate>) observer;
- (void)notifyAllAboutNewCurrentLocation;
- (void)notifyAllAboutNewLocation:(CLLocation*)location rideWithRideId:(NSNumber *)rideId;
- (void)removeObserver:(id<LocationControllerDelegate>)observer;

+ (BOOL)isLocation:(CLLocation *)location nearbyAnotherLocation:(CLLocation *)anotherLocation;
+ (CLLocation *)locationFromLongitude:(double)longitude latitude:(double)latitude;

typedef void (^PlacemarkBlock)(CLPlacemark *placemark, NSError *error);
+ (void)resolveGecodePlaceToPlacemark:(PlacemarkBlock)block address:(NSString *)address;

@end
