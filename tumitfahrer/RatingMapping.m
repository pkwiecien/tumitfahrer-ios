//
//  RatingMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 5/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RatingMapping.h"

@implementation RatingMapping

+(RKEntityMapping *)ratingMapping {
    
    RKEntityMapping *ratingMapping = [RKEntityMapping mappingForEntityForName:@"Rating" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    ratingMapping.identificationAttributes = @[@"ratingId"];
    [ratingMapping addAttributeMappingsFromDictionary:@{@"id": @"ratingId",
                                                         @"ride_id":@"rideId",
                                                         @"rating_type":@"ratingType",
                                                         @"created_at": @"createdAt",
                                                         @"updated_at": @"updatedAt"
                                                         }];
    return ratingMapping;
}

@end
