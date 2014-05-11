//
//  Rating.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, User;

@interface Rating : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * ratingId;
@property (nonatomic, retain) NSNumber * ratingType;
@property (nonatomic, retain) NSNumber * rideId;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *givenRating;
@property (nonatomic, retain) User *receivedRating;
@property (nonatomic, retain) Activity *activities;

@end
