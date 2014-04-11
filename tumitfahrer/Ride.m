//
//  Ride.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "Ride.h"
#import "User.h"


@implementation Ride

@dynamic rideId;
@dynamic departurePlace;
@dynamic destination;
@dynamic meetingPoint;
@dynamic departureTime;
@dynamic freeSeats;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic realtimeKm;
@dynamic realtimeDepartureTime;
@dynamic price;
@dynamic duration;
@dynamic distance;
@dynamic isFinished;
@dynamic isPaid;
@dynamic destinationImage;
@dynamic driver;
@dynamic passengers;

-(NSString *)description {
    return [NSString stringWithFormat:@"Ride id: %d, departure: %@", self.rideId, self.departurePlace];
}

@end
