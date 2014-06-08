//
//  RideSearch.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/7/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity;

@interface RideSearch : NSManagedObject

@property (nonatomic, retain) NSNumber * rideSearchId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * departurePlace;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSDate * departureTime;
@property (nonatomic, retain) NSNumber * rideType;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Activity *activity;

@end
