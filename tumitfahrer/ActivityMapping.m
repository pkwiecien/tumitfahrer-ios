//
//  TimelineMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ActivityMapping.h"
#import "RideMapping.h"

@implementation ActivityMapping

+(RKEntityMapping *)generalActivityMapping {
    RKEntityMapping *activityMapping = [RKEntityMapping mappingForEntityForName:@"Activity" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    activityMapping.identificationAttributes = @[@"activityId"];
    [activityMapping addAttributeMappingsFromDictionary:@{@"id": @"activityId",
                                                      @"created_at": @"createdAt",
                                                      @"updated_at": @"updatedAt"
                                                      }];
    
    [activityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rides" toKeyPath:@"rides" withMapping:[RideMapping generalRideMapping]]];
    
    return activityMapping;
}

+(RKResponseDescriptor *)getActivityResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:API_ACTIVITIES keyPath:@"activities"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
