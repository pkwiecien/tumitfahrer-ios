//
//  RideSearch.h
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RideSearch : NSObject

@property (nonatomic, retain) NSString * departurePlace;
@property (nonatomic) NSDate * departureTime;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSData * destinationImage;
@property (nonatomic) double destinationLatitude;
@property (nonatomic) double destinationLongitude;
@property (nonatomic) float distance;
@property (nonatomic) float duration;
@property (nonatomic) int32_t freeSeats;
@property (nonatomic, retain) NSString * meetingPoint;
@property (nonatomic) float price;
@property (nonatomic) NSNumber * rideId;
@property (nonatomic) int32_t driverId;
@property (nonatomic) int32_t detour;
@property (nonatomic) NSDate * updatedAt;
@property (nonatomic) NSDate * createdAt;
@property (nonatomic) int16_t rideType;

@end