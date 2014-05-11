//
//  TimelineMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ActivitiesMapping.h"
#import "RideMapping.h"

@implementation ActivitiesMapping

+(RKEntityMapping *)generalActivityMapping {
    RKEntityMapping *rideMapping = [RKEntityMapping mappingForEntityForName:@"Activities" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    rideMapping.identificationAttributes = @[@"activityId"];
    [rideMapping addAttributeMappingsFromDictionary:@{@"id": @"activityId",
                                                      @"created_at": @"createdAt",
                                                      @"updated_at": @"updatedAt"
                                                      }];
    
    
    [rideMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"campus_rides" toKeyPath:@"rides" withMapping:[RideMapping generalRideMapping]]];

    return rideMapping;
}

+(RKResponseDescriptor *)getActivityResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:API_ACTIVITIES keyPath:@"activities"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
