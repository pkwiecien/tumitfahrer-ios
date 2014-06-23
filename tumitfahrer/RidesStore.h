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

@class Ride, Request, User;

@protocol RideStoreDelegate <NSObject>

@optional

- (void)didRecieveRidesFromWebService: (NSArray*)rides;
- (void)didReceivePhotoForRide: (NSNumber *)rideId;

@end

@interface RidesStore : NSObject <LocationControllerDelegate, PanoramioUtilitiesDelegate>

+ (instancetype)sharedStore;

- (NSArray *)allRides;
- (NSArray *)allRidesByType:(ContentType)contentType;
- (NSArray *)ridesNearbyByType:(ContentType)contentType;
- (NSArray *)favoriteRidesByType:(ContentType)contentType;

+ (void)initRide:(Ride *)ride block:(boolCompletionHandler)block;
+ (void)initRide:(Ride *)ride index:(NSInteger)index block:(completionHandlerWithIndex)block;
- (void)initAllRidesFromCoreData;
- (void)initRidesByType:(NSInteger)rideType block:(boolCompletionHandler)block;
- (Ride *)containsRideWithId:(NSNumber *)rideId;
- (void)fetchNewRides:(boolCompletionHandler)block;
- (void)deleteRideFromCoreData:(Ride *)ride;
- (void)deleteRideRequest:(Request *)request;

- (void)addRideToStore:(Ride*)ride;
- (void)addRideRequestToStore:(Request *)request forRide:(Ride *)ride;
- (void)addObserver:(id<RideStoreDelegate>) observer;
- (void)removeObserver:(id<RideStoreDelegate>)observer;
- (void)notifyAllAboutNewImageForRideId:(NSNumber *)rideId;

- (void)fetchSingleRideFromWebserviceWithId:(NSNumber *)rideId block:(boolCompletionHandler)block;
- (Ride *)fetchRideFromCoreDataWithId:(NSNumber *)rideId;
- (void)fetchPastRidesFromCoreData;
- (NSMutableArray *)pastRides;
- (void)fetchRidesForCurrentUser:(boolCompletionHandler)block ;

- (BOOL)addPassengerForRideId:(NSNumber *)rideId requestor:(User *)requestor;
- (BOOL)removeRequestForRide:(NSNumber *)rideId request:(Request *)request;
- (BOOL)removePassengerForRide:(NSNumber *)rideId passenger:(User *)passenger;
- (void)saveToPersistentStore:(Ride *)ride;

- (void)filterAllFavoriteRides;
- (void)fetchRidesfromDate:(NSDate *)date rideType:(NSInteger)rideType block:(boolCompletionHandler)block;
- (void)fetchImageForCurrentRide:(Ride *)ride;
- (void)fetchRidesFromDate:(NSDate *)date;
- (NSArray *)fetchUserRequestsFromCoreDataForUserId:(NSNumber *)userId;

@end
