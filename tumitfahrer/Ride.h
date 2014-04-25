//
//  Ride.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Request, User;

@interface Ride : NSManagedObject

@property (nonatomic) int rideId;
@property (nonatomic, retain) NSString * departurePlace;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSString * meetingPoint;
@property (nonatomic, retain) NSDate * departureTime;
@property (nonatomic) int freeSeats;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * updatedAt;
@property (nonatomic) float realtimeKm;
@property (nonatomic, retain) NSDate * realtimeDepartureTime;
@property (nonatomic) float price;
@property (nonatomic) float duration;
@property (nonatomic) float distance;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) BOOL isPaid;
@property (nonatomic, strong) UIImage * destinationImage;
@property (nonatomic) double destinationLatitude;
@property (nonatomic) double destinationLongitude;
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
