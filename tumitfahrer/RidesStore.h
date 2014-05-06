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

- (NSArray *)allCampusRides;
- (NSArray *)allActivityRides;
- (NSArray *)allRideRequests;
- (NSArray *)allRidesByType:(ContentType)contentType;
- (Ride *)getRideWithId:(NSInteger)rideId;
- (NSArray *)rideRequestForUserWithId:(NSInteger)userId;

- (void)addRideToStore:(Ride*)ride;
- (void)addObserver:(id<RideStoreDelegate>) observer;
- (void)notifyAllAboutNewImageForRideId:(NSInteger)rideId;
- (void)removeObserver:(id<RideStoreDelegate>)observer;

@end
