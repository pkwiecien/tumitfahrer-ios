//
//  Activity.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rating, Request, Ride;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *ratings;
@property (nonatomic, retain) NSSet *requests;
@property (nonatomic, retain) NSSet *rides;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addRatingsObject:(Rating *)value;
- (void)removeRatingsObject:(Rating *)value;
- (void)addRatings:(NSSet *)values;
- (void)removeRatings:(NSSet *)values;

- (void)addRequestsObject:(Request *)value;
- (void)removeRequestsObject:(Request *)value;
- (void)addRequests:(NSSet *)values;
- (void)removeRequests:(NSSet *)values;

- (void)addRidesObject:(Ride *)value;
- (void)removeRidesObject:(Ride *)value;
- (void)addRides:(NSSet *)values;
- (void)removeRides:(NSSet *)values;

@end
