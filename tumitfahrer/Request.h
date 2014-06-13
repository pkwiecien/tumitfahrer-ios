//
//  Request.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/13/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Ride;

@interface Request : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * passengerId;
@property (nonatomic, retain) NSNumber * requestId;
@property (nonatomic, retain) NSNumber * rideId;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Activity *activities;
@property (nonatomic, retain) Ride *requestedRide;

@end
