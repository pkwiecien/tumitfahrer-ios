//
//  Rating.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/26/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Rating : NSManagedObject

@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) int32_t ratingId;
@property (nonatomic) int16_t ratingType;
@property (nonatomic) int32_t rideId;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, retain) User *givenRating;
@property (nonatomic, retain) User *receivedRating;

@end
