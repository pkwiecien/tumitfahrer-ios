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
- (void)didReceivePhotoForRide: (NSInteger)rideId;

@end

@interface RidesStore : NSObject <LocationControllerDelegate, PanoramioUtilitiesDelegate>

+ (instancetype)sharedStore;

- (NSArray *)allRides;
- (NSArray *)allCampusRides;
- (NSArray *)allActivityRides;
- (NSArray *)allRidesByType:(ContentType)contentType;
- (NSArray *)ridesNearbyByType:(ContentType)contentType;
- (NSArray *)favoriteRidesByType:(ContentType)contentType;

- (Ride *)getRideWithId:(NSInteger)rideId;
- (Ride *)containsRideWithId:(NSInteger)rideId;
- (NSArray *)rideRequestForUserWithId:(NSInteger)userId;
- (void)fetchRidesFromCoreDataByType:(ContentType)contentType;
- (void)fetchRidesFromWebservice:(boolCompletionHandler)block;
- (void)fetchNextRides:(boolCompletionHandler)block;
- (void)deleteRideFromCoreData:(Ride *)ride;
- (void)deleteRideRequestFromCoreData:(Request *)request;

- (void)addRideToStore:(Ride*)ride;
- (void)addObserver:(id<RideStoreDelegate>) observer;
- (void)notifyAllAboutNewImageForRideId:(NSInteger)rideId;
- (void)removeObserver:(id<RideStoreDelegate>)observer;

- (void)fetchSingleRideFromWebserviceWithId:(NSInteger)rideId block:(boolCompletionHandler)block;
- (Ride *)fetchRideFromCoreDataWithId:(NSInteger)rideId;

@end
