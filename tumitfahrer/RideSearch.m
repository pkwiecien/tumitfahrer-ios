//
//  RideSearch.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/1/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideSearch.h"

@implementation RideSearch

-(NSString *)description {
    return [NSString stringWithFormat:@"Ride search result: id: %d, detour %d", self.rideId, self.detour];
}
@end