//
//  Rating.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/19/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ride;

@interface Rating : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * ratingId;
@property (nonatomic, retain) NSNumber * ratingType;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * toUserId;
@property (nonatomic, retain) NSNumber * fromUserId;
@property (nonatomic, retain) NSNumber * rideId;
@property (nonatomic, retain) Ride *ride;

@end
