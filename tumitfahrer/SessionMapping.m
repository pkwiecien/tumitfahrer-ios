//
//  SessionMapping.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 4/11/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "SessionMapping.h"

@implementation SessionMapping

+ (RKEntityMapping *)sessionMapping {
    RKEntityMapping *sessionMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]];
    sessionMapping.identificationAttributes = @[ @"userId" ];
    [sessionMapping addAttributeMappingsFromDictionary:@{
                                                         @"id":             @"userId",
                                                         @"first_name":     @"firstName",
                                                         @"last_name":      @"lastName",
                                                         @"email":          @"email",
                                                         @"is_student":     @"isStudent",
                                                         @"phone_number":   @"phoneNumber",
                                                         @"car":            @"car",
                                                         @"department":     @"department",
                                                         @"api_key":        @"apiKey",
                                                         @"created_at":     @"createdAt",
                                                         @"updated_at":     @"updatedAt"}];
    
    return sessionMapping;
}

+ (RKResponseDescriptor *)postSessionResponseDescriptorWithMapping:(RKEntityMapping*)mapping {
    // create response description for user's session
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping                                                                                            method:RKRequestMethodPOST                                                                                       pathPattern:API_SESSIONS                                                                                           keyPath:@"user"                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    return responseDescriptor;
}

@end
