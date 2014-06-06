//
//  RideSearchMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/6/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RideSearchMapping.h"

@implementation RideSearchMapping

+(RKEntityMapping *)generalRideSearchMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"RideSearch" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    
    mapping.identificationAttributes = @[@"rideSearchId"];
    [mapping addAttributeMappingsFromDictionary:@{@"id": @"rideSearchId",
                                                        @"departure_place":@"departurePlace",
                                                        @"destination":@"destination",
                                                        @"departure_time":@"departureTime",
                                                        @"ride_type":@"ride_type",
                                                        @"created_at": @"createdAt",
                                                        @"updated_at": @"updatedAt"
                                                        }];
    
    return mapping;
}

@end
