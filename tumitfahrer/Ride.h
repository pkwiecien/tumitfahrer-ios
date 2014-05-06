//
//  Ride.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Request, User;

@interface Ride : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * departurePlace;
@property (nonatomic, retain) NSDate * departureTime;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSData * destinationImage;
@property (nonatomic, retain) NSNumber * destinationLatitude;
@property (nonatomic, retain) NSNumber * destinationLongitude;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * freeSeats;
@property (nonatomic, retain) NSNumber * isFinished;
@property (nonatomic, retain) NSNumber * isPaid;
@property (nonatomic, retain) NSString * meetingPoint;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSDate * realtimeDepartureTime;
@property (nonatomic, retain) NSNumber * realtimeKm;
@property (nonatomic, retain) NSNumber * rideId;
@property (nonatomic, retain) NSNumber * rideType;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *driver;
@property (nonatomic, retain) NSSet *passengers;
@property (nonatomic, retain) NSSet *requests;
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
