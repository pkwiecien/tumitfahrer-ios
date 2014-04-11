//
//  Ride.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

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
@property (nonatomic, retain) User *driver;
@property (nonatomic, retain) NSSet *passengers;
@end

@interface Ride (CoreDataGeneratedAccessors)

- (void)addPassengersObject:(User *)value;
- (void)removePassengersObject:(User *)value;
- (void)addPassengers:(NSSet *)values;
- (void)removePassengers:(NSSet *)values;

@end
