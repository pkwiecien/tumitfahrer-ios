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
                                                        @"to_user_id":@"toUserId",
                                                        @"from_user_id":@"fromUserId",
                                                        @"ride_id":@"rideId",
                                                        @"rating_type":@"ratingType",
                                                        @"created_at": @"createdAt",
                                                        @"updated_at": @"updatedAt"
                                                        }];
    return ratingMapping;
}

+(RKResponseDescriptor *)postRatingResponseDescriptorWithMapping:(RKEntityMapping *)mapping {
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:mapping method:RKRequestMethodPOST pathPattern:API_USERS_RATINGS keyPath:@"rating" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
