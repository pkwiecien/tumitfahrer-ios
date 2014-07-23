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

/**
 *  Protocol that notifies about new changes in rides objects
 */
@protocol RideStoreDelegate <NSObject>

@optional

/**
 *  Notifies about completing fetching of rides from the webservice
 *
 *  @param rides NSArray with fetched rides.
 */
- (void)didRecieveRidesFromWebService: (NSArray*)rides;

/**
 *  Notifies about fetching a photo from Panoramio API for a specific ride.
 *
 *  @param rideId Id of the ride
 */
- (void)didReceivePhotoForRide: (NSNumber *)rideId;

@end

@interface RidesStore : NSObject <LocationControllerDelegate, PanoramioUtilitiesDelegate>

typedef void(^rideCompletionHandler)(Ride *);

/**
 *  Singelton object
 *
 *  @return shared object.
 */
+ (instancetype)sharedStore;

/**
 *  Return an array of all rides.
 *
 *  @return NSArray with all rides.
 */
- (NSArray *)allRides;

/**
 *  Returns all rides by specific type (e.g. campus or acitivites)
 *
 *  @param contentType Ride type
 *
 *  @return NSArray with rides of the type contentType.
 */
- (NSArray *)allRidesByType:(ContentType)contentType;

/**
 *  Return an array with rides that departure place or destination is near the current location.
 *
 *  @param contentType Type of the ride (e.g. campus or activity)
 *
 *  @return An array with rides nearby
 */
- (NSArray *)ridesNearbyByType:(ContentType)contentType;

/**
 *  Returns an array with rides that match the recent places from the Core data. Recent places are based on user's search requests.
 *
 *  @param contentType Type of the ride
 *
 *  @return An array with favourite rides
 */
- (NSArray *)favoriteRidesByType:(ContentType)contentType;

/**
 *  Asynchronously initializes ride object, e.g. assigns coordinates of departure and destination place, fetches a photo from the Panoramio API.
 *
 *  @param ride  The ride object
 *  @param block The completion handler.
 */
+ (void)initRide:(Ride *)ride block:(boolCompletionHandler)block;

/**
 *   Asynchronously initializes ride object, e.g. assigns coordinates of departure and destination place, fetches a photo from the Panoramio API.
 *
 *  @param ride  The ride object
 *  @param index index in the table of this ride (for updating a specific row, not the whole table)
 *  @param block The completion handler.
 */
+ (void)initRide:(Ride *)ride index:(NSInteger)index block:(completionHandlerWithIndex)block;

/**
 *  Fetches all rides for the current user from core data.
 */
- (void)initAllRidesFromCoreData;
/**
 *  Initializes all rides with a given type (e.g. campus or acitvity). Assigns coordinates of departure and destination place, fetches a photo from the Panoramio API.
 *
 *  @param rideType Type of the ride
 *  @param block    The completion handler.
 */
- (void)initRidesByType:(NSInteger)rideType block:(boolCompletionHandler)block;

/**
 *  Checks whether the current store contains a specific ride.
 *
 *  @param rideId Id of the ride.
 *
 *  @return If the ride is found, then it's returned, otherwise return nil.
 */
- (Ride *)containsRideWithId:(NSNumber *)rideId;

/**
 *  Fetches new rides from the webservice.
 *
 *  @param block The completion handler of type bool (YES if fetched successfully).
 */
- (void)fetchNewRides:(boolCompletionHandler)block;

/**
 *  Deletes a specific ride from the Core Data.
 *
 *  @param ride The Ride object.
 */
- (void)deleteRideFromCoreData:(Ride *)ride;

/**
 *  Deletes a specific ride request from the Core Data.
 *
 *  @param request The Request object.
 */
- (void)deleteRideRequest:(Request *)request;

/**
 *  Add a new ride to the local ride store.
 *
 *  @param ride The ride object.
 */
- (void)addRideToStore:(Ride*)ride;

/**
 *  Add a new request for a given ride to the local store.
 *
 *  @param request The request object.
 *  @param ride    The ride object.
 */
- (void)addRideRequestToStore:(Request *)request forRide:(Ride *)ride;

/**
 *  Adds a new observer to the Ride store.
 *
 *  @param observer The observer object.
 */
- (void)addObserver:(id<RideStoreDelegate>) observer;
/**
 *  Removes an existing observer from the Ride store.
 *
 *  @param observer The observer object.
 */
- (void)removeObserver:(id<RideStoreDelegate>)observer;
/**
 *  Notifies all observers about fetching new image from Panoramio API for a specific ride.
 *
 *  @param rideId The ride object.
 */
- (void)notifyAllAboutNewImageForRideId:(NSNumber *)rideId;

/**
 *  Asynchronously fetches a single ride with a given id from the webservice.
 *
 *  @param rideId Id of the ride
 *  @param block  The completion handler.
 */
- (void)fetchSingleRideFromWebserviceWithId:(NSNumber *)rideId block:(rideCompletionHandler)block;

/**
 *  Fetches a specific ride from the core data.
 *
 *  @param rideId Id of the ride.
 *
 *  @return The ride object (if found), otherwise nil.
 */
- (Ride *)fetchRideFromCoreDataWithId:(NSNumber *)rideId;

/**
 *  Fetches all user's past rides from the core data.
 */
- (void)fetchPastRidesFromCoreData;

/**
 *  Returns an array with past rides in the system.
 *
 *  @return An array with past rides in the system.
 */
- (NSMutableArray *)pastRides;

/**
 *  Returns an array with user's past rides.
 *
 *  @return An array with user's past rides.
 */
- (NSMutableArray *)userPastRides;

/**
 *  Asynchronously fetches from webservice all upcoming rides of the given user.
 *
 *  @param block The completion handler (YES if fetched successfully).
 */
- (void)fetchRidesForCurrentUser:(boolCompletionHandler)block ;

/**
 *  Adds a passenger to the given ride.
 *
 *  @param rideId    Id of the ride.
 *  @param requestor The User object who is a passenger
 *
 *  @return True if passenger was added successfully.
 */
- (BOOL)addPassengerForRideId:(NSNumber *)rideId requestor:(User *)requestor;

/**
 *  Removes a ride request for the given ride.
 *
 *  @param rideId  Id of the ride.
 *  @param request The request object.
 *
 *  @return True if request was removed successfully.
 */
- (BOOL)removeRequestForRide:(NSNumber *)rideId request:(Request *)request;

/**
 *  Removes a passenger from the given ride.
 *
 *  @param rideId    Id of the ride.
 *  @param passenger The User object who is a passenger.
 *
 *  @return <#return value description#>
 */
- (BOOL)removePassengerForRide:(NSNumber *)rideId passenger:(User *)passenger;
/**
 *  Saves changed ride to the core data.
 *
 *  @param ride The Ride object.
 */
- (void)saveToPersistentStore:(Ride *)ride;

/**
 *  Filter all rides and find all rides that correspond to user's favourite rides (based on recent places object).
 */
- (void)filterAllFavoriteRides;

/**
 *  Asynchronously fetches rides from the webservice that were updated after a specific date.
 *
 *  @param date     The data after which the ride should be updated.
 *  @param rideType Type of the ride.
 *  @param block    The completion handler (YES if fetched successfully).
 */
- (void)fetchRidesfromDate:(NSDate *)date rideType:(NSInteger)rideType block:(boolCompletionHandler)block;

/**
 * Asynchronously fetches an image from the Panoramio API for a given ride.
 *
 *  @param ride The ride object.
 */
- (void)fetchImageForCurrentRide:(Ride *)ride;
/**
 *  Fetches ride requests of the specific user from the core data.
 *
 *  @param userId Id of the user.
 *
 *  @return Array with user's ride requests.
 */
- (NSArray *)fetchUserRequestsFromCoreDataForUserId:(NSNumber *)userId;

/**
 *  Updates time when details of the specific rides were seen (needed for My profile to check if there are any new messages, etc.)
 *
 *  @param ride The ride object.
 */
+ (void)updateLastSeenTime:(Ride *)ride;
/**
 *  Fetches a ride request from the core data.
 *
 *  @param requestId Id of the ride request.
 *
 *  @return The request object.
 */
+ (Request *)fetchRequestFromCoreDataWithId:(NSNumber *)requestId;

/**
 *  Fetches user's past rides from the core data. They can be then read by calling a userPastRides getter.
 */
- (void)fetchUserPastRidesFromCoreData;

@end
