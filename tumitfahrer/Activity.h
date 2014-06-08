//
//  Activity.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/8/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Request, Ride, RideSearch;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSSet *requests;
@property (nonatomic, retain) NSSet *rides;
@property (nonatomic, retain) NSSet *rideSearches;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addRequestsObject:(Request *)value;
- (void)removeRequestsObject:(Request *)value;
- (void)addRequests:(NSSet *)values;
- (void)removeRequests:(NSSet *)values;

- (void)addRidesObject:(Ride *)value;
- (void)removeRidesObject:(Ride *)value;
- (void)addRides:(NSSet *)values;
- (void)removeRides:(NSSet *)values;

- (void)addRideSearchesObject:(RideSearch *)value;
- (void)removeRideSearchesObject:(RideSearch *)value;
- (void)addRideSearches:(NSSet *)values;
- (void)removeRideSearches:(NSSet *)values;

@end
