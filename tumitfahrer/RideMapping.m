//
//  RideMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideMapping.h"
#import "UserMapping.h"
#import "RideSearch.h"

@implementation RideMapping

+(RKEntityMapping *)generalRideMapping {
    RKEntityMapping *rideMapping = [RKEntityMapping mappingForEntityForName:@"Ride" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    rideMapping.identificationAttributes = @[@"rideId"];
    [rideMapping addAttributeMappingsFromDictionary:@{@"id": @"rideId",
                                                      @"departure_place": @"departurePlace",
                                                      @"destination": @"destination",
                                                      @"meeting_point":@"meetingPoint",
                                                      @"departure_time":@"departureTime",
                                                      @"free_seats":@"freeSeats",
                                                      @"duration":@"duration",
                                                      @"distance":@"distance",
                                                      @"ride_type":@"rideType",
                                                      @"created_at": @"createdAt",
                                                      @"updated_at": @"updatedAt"
                                                      }];
    
    [rideMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"driver" toKeyPath:@"driver" withMapping:[UserMapping userMapping]]];
    
    [rideMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"passengers" toKeyPath:@"passengers" withMapping:[UserMapping userMapping]]];
    
    [rideMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"requests" toKeyPath:@"requests" withMapping:[UserMapping userMapping]]];
    return rideMapping;
}

+(RKObjectMapping*)getRideSearchesMapping {
    
    RKObjectMapping *rideMapping = [RKObjectMapping mappingForClass:[RideSearch class]];
    
    [rideMapping addAttributeMappingsFromDictionary:@{@"id": @"rideId",
                                                      @"departure_place": @"departurePlace",
                                                      @"destination": @"destination",
                                                      @"meeting_point":@"meetingPoint",
                                                      @"departure_time":@"departureTime",
                                                      @"free_seats":@"freeSeats",
                                                      @"detour":@"detour",
                                                      @"driver_id":@"driverId",
                                                      @"ride_type":@"rideType",
                                                      @"created_at": @"createdAt",
                                                      @"updated_at": @"updatedAt"
                                                      }];
    
    return rideMapping;

}

+(RKResponseDescriptor *)getRideSearchesResponseDescriptorWithMapping:(RKObjectMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST pathPattern:API_SEARCH keyPath:@"rides"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKResponseDescriptor *)getRidesResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    // create response description for rides
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:API_RIDES keyPath:@"rides"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

+(RKEntityMapping *)postRideMapping {
    
    RKEntityMapping *rideMapping = [self generalRideMapping];
    return rideMapping;
}

+(RKResponseDescriptor *)postRideResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:mapping method:RKRequestMethodPOST pathPattern:API_RIDES keyPath:@"ride" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
