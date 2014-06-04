//
//  RidesStore.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationController.h"
#import "PanoramioUtilities.h"

@class Ride, Request;

@protocol RideStoreDelegate <NSObject>

- (void)didRecieveRidesFromWebService: (NSArray*)rides;
- (void)didReceivePhotoForRide: (NSNumber *)rideId;

@end

@interface RidesStore : NSObject <LocationControllerDelegate, PanoramioUtilitiesDelegate>

+ (instancetype)sharedStore;

- (NSArray *)allRides;
- (NSArray *)allRidesByType:(ContentType)contentType;
- (NSArray *)ridesNearbyByType:(ContentType)contentType;
- (NSArray *)favoriteRidesByType:(ContentType)contentType;

- (Ride *)getRideWithId:(NSNumber *)rideId;
- (Ride *)containsRideWithId:(NSNumber *)rideId;
- (NSArray *)rideRequestForUserWithId:(NSNumber *)userId;
- (void)loadRidesFromCoreDataByType:(ContentType)contentType;
- (void)fetchNewRides:(boolCompletionHandler)block;
- (void)deleteRideFromCoreData:(Ride *)ride;
- (void)deleteRideRequestFromCoreData:(Request *)request;

- (void)addRideToStore:(Ride*)ride;
- (void)addObserver:(id<RideStoreDelegate>) observer;
- (void)notifyAllAboutNewImageForRideId:(NSNumber *)rideId;
- (void)removeObserver:(id<RideStoreDelegate>)observer;

- (void)fetchSingleRideFromWebserviceWithId:(NSNumber *)rideId block:(boolCompletionHandler)block;
- (Ride *)fetchRideFromCoreDataWithId:(NSNumber *)rideId;

@end
