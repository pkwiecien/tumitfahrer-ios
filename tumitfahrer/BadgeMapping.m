//
//  BadgeMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "BadgeMapping.h"

@implementation BadgeMapping

+(RKEntityMapping *)badgeMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Badge" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    mapping.identificationAttributes = @[@"badgeId"];
    [mapping addAttributeMappingsFromDictionary:@{@"id": @"badgeId",
                                                  @"campus_badge" : @"campusBadge",
                                                  @"campus_updated_at" : @"campusUpdatedAt",
                                                  @"activity_badge" : @"activityBadge",
                                                  @"activity_updated_at" : @"activityUpdatedAt",
                                                  @"timeline_badge" : @"timelineBadge",
                                                  @"timeline_updated_at" : @"timelineUpdatedAt",
                                                  @"my_rides_badge" : @"myRidesBadge",
                                                  @"my_rides_updated_at" : @"myRidesUpdatedAt",
                                                  @"created_at" : @"createdAt"
                                                          }];
    
    
    return mapping;
}

+(RKResponseDescriptor *)getBadgesResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodGET pathPattern:API_ACTIVITIES_BADGES keyPath:@"badge_counter"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
