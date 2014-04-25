//
//  Rating.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Rating : NSManagedObject

@property (nonatomic, retain) NSNumber * ratingType;
@property (nonatomic, retain) NSNumber * rideId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * ratingId;
@property (nonatomic, retain) User *receivedRating;
@property (nonatomic, retain) User *givenRating;

@end
