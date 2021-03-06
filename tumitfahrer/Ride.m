//
//  Ride.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 7/25/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "Ride.h"
#import "Activity.h"
#import "Conversation.h"
#import "Photo.h"
#import "Rating.h"
#import "Request.h"
#import "User.h"


@implementation Ride

@dynamic car;
@dynamic createdAt;
@dynamic departureLatitude;
@dynamic departureLongitude;
@dynamic departurePlace;
@dynamic departureTime;
@dynamic destination;
@dynamic destinationImage;
@dynamic destinationLatitude;
@dynamic destinationLongitude;
@dynamic freeSeats;
@dynamic isPaid;
@dynamic regularRideId;
@dynamic isRideRequest;
@dynamic lastCancelTime;
@dynamic lastSeenTime;
@dynamic meetingPoint;
@dynamic price;
@dynamic rideId;
@dynamic rideType;
@dynamic updatedAt;
@dynamic activities;
@dynamic conversations;
@dynamic passengers;
@dynamic photo;
@dynamic ratings;
@dynamic requests;
@dynamic rideOwner;

@end
