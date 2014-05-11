//
//  Ride.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Request, User;

@interface Ride : NSManagedObject

@property (nonatomic) NSDate * createdAt;
@property (nonatomic, retain) NSString * departurePlace;
@property (nonatomic) NSDate * departureTime;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSData * destinationImage;
@property (nonatomic) double destinationLatitude;
@property (nonatomic) double destinationLongitude;
@property (nonatomic) float distance;
@property (nonatomic) float duration;
@property (nonatomic) int32_t freeSeats;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) BOOL isPaid;
@property (nonatomic, retain) NSString * meetingPoint;
@property (nonatomic) float price;
@property (nonatomic) NSDate * realtimeDepartureTime;
@property (nonatomic) float realtimeKm;
@property (nonatomic) int32_t rideId;
@property (nonatomic) NSDate * updatedAt;
@property (nonatomic) int16_t rideType;
@property (nonatomic, retain) User *driver;
@property (nonatomic, retain) NSSet *passengers;
@property (nonatomic, retain) NSSet *requests;
@property (nonatomic, retain) Activity *activities;

@end

@interface Ride (CoreDataGeneratedAccessors)

- (void)addPassengersObject:(User *)value;
- (void)removePassengersObject:(User *)value;
- (void)addPassengers:(NSSet *)values;
- (void)removePassengers:(NSSet *)values;

- (void)addRequestsObject:(Request *)value;
- (void)removeRequestsObject:(Request *)value;
- (void)addRequests:(NSSet *)values;
- (void)removeRequests:(NSSet *)values;

@end
